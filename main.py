import time
import threading

from src.core.utils          import load_config
from src.core.logger         import get_logger
from src.services.alert_engine   import AlertEngine
from src.ai.image_processor import ImageProcessor
from src.services.ota_manager    import OTAManager
from src.services.report_builder import ReportBuilder, DEFAULT_SENSORS

logger = get_logger("Main")

# ══════════════════════════════════════════════════════════════════════════════
# Feature-flag guarded imports
# Chỉ import khi tính năng được bật, tránh crash khi thiếu dependency
# ══════════════════════════════════════════════════════════════════════════════

def _import_camera():
    from src.hardware.camera import Camera
    return Camera

def _import_ai_engine():
    from src.ai.ai_engine import AIEngine
    return AIEngine

def _import_iot():
    from src.network.iot_client import IoTClient
    return IoTClient

def _import_streamer():
    from src.network.streamer import RTSPStreamer
    return RTSPStreamer

def _import_sensor_server():
    from src.hardware.sensor_server import SensorServer
    return SensorServer

def _import_lstm():
    from src.ai.lstm_predictor import LSTMPredictor
    return LSTMPredictor

def _import_cloud_uploader():
    from src.services.cloud_uploader import CloudUploader
    return CloudUploader

# ── Frame Cacher ──────────────────────────────────────────────────────────────
class FrameCacher:
    """A mock queue to cache the latest frame from the camera."""
    def __init__(self):
        self.latest_frame = None
        self.lock = threading.Lock()
        
    def put_nowait(self, frame):
        with self.lock:
            self.latest_frame = frame
            
    def get_latest(self):
        with self.lock:
            return self.latest_frame



# ══════════════════════════════════════════════════════════════════════════════
class MainApp:
    """
    Điểm kết nối (orchestrator) của toàn bộ hệ thống.

    Nhiệm vụ DUY NHẤT của class này:
      - Khởi tạo và wire các module lại với nhau.
      - Quản lý lifecycle (start / stop).
      - Điều phối luồng dữ liệu giữa các module.

    Mọi business logic đều nằm trong các class chuyên biệt:
      AlertEngine, ImageProcessor, OTAManager, ReportBuilder.
    """

    def __init__(self):
        self.config  = load_config("config.json")
        self.running = True

        # ── Feature flags ──────────────────────────────────────────────────
        self.f_camera   = self.config.get("enable_camera",   True)
        self.f_sensor   = self.config.get("enable_sensor",   True)
        self.f_mqtt     = self.config.get("enable_mqtt",     True)
        self.f_streamer = self.config.get("enable_streamer", True)
        self.f_lstm     = self.config.get("enable_lstm",     True)
        self.f_cloud    = self.config.get("enable_cloud_upload", False)
        self._print_flags()

        # ── Shared sensor cache ────────────────────────────────────────────
        self.latest_sensor_data = None
        self.sensor_lock        = threading.Lock()
        self.frame_cacher       = FrameCacher()

        # ── Hardware / network modules ─────────────────────────────────────
        self.camera        = self._init_camera()
        self.ai_engine     = self._init_ai_engine()
        self.iot_client    = self._init_iot_client()
        self.streamer      = self._init_streamer()
        self.sensor_server = self._init_sensor_server()
        self.lstm          = self._init_lstm()

        # ── Business-logic services ────────────────────────────────────────
        self.alert_engine    = AlertEngine()
        self.image_processor = ImageProcessor()
        self.ota_manager     = OTAManager(self.config)
        self.report_builder  = ReportBuilder()
        self.cloud_uploader  = self._init_cloud_uploader()

        # ── Wire modules & start report thread ────────────────────────────
        self._wire_modules()
        self.report_thread = threading.Thread(
            target=self._report_loop, daemon=True
        )

    # ──────────────────────────────────────────────────────────────────────
    # Init helpers — mỗi module có 1 hàm _init_* riêng, dễ đọc và override
    # ──────────────────────────────────────────────────────────────────────

    def _init_camera(self):
        if not self.f_camera:
            return None
        return _import_camera()(self.config)

    def _init_ai_engine(self):
        if not self.f_camera:
            return None

        app = self  # reference để SensorProvider đọc latest_sensor_data

        class SensorProvider:
            def get_data(self_inner):
                with app.sensor_lock:
                    return app.latest_sensor_data or DEFAULT_SENSORS

        return _import_ai_engine()(self.config, sensor_manager=SensorProvider())

    def _init_iot_client(self):
        if not self.f_mqtt:
            return None
        return _import_iot()(self.config)

    def _init_streamer(self):
        if not (self.f_streamer and self.f_camera):
            return None
        return _import_streamer()(self.config)

    def _init_sensor_server(self):
        if not self.f_sensor:
            return None
        return _import_sensor_server()(
            self.config, data_callback=self.update_sensor_data
        )

    def _init_lstm(self):
        if not self.f_lstm:
            return None
        return _import_lstm()(self.config)

    def _init_cloud_uploader(self):
        if not self.f_cloud:
            return None
        return _import_cloud_uploader()(self.config)

    def _wire_modules(self):
        """Kết nối các queue giữa các module với nhau."""
        if self.camera and self.ai_engine:
            self.camera.add_queue(self.ai_engine.input_queue)
        if self.camera and self.streamer:
            self.camera.add_queue(self.streamer.frame_queue)
        if self.camera:
            self.camera.add_queue(self.frame_cacher)
        if self.ai_engine and self.streamer:
            self.streamer.result_queue = self.ai_engine.output_queue
        if self.iot_client:
            self.iot_client.on_test_image_received = self.handle_test_image
            self.iot_client.on_update_received     = self.handle_ota_update

    # ──────────────────────────────────────────────────────────────────────
    # Lifecycle
    # ──────────────────────────────────────────────────────────────────────

    def _print_flags(self):
        print("=" * 50)
        print("  FEATURE FLAGS")
        print("=" * 50)
        print(f"  Camera   : {'[ON]' if self.f_camera   else '[OFF]'}")
        print(f"  Sensor   : {'[ON]' if self.f_sensor   else '[OFF]'}")
        print(f"  MQTT     : {'[ON]' if self.f_mqtt     else '[OFF]'}")
        print(f"  Streamer : {'[ON]' if self.f_streamer else '[OFF]'}")
        print(f"  LSTM     : {'[ON]' if self.f_lstm     else '[OFF]'}")
        print(f"  Cloud    : {'[ON]' if self.f_cloud    else '[OFF]'}")
        print("=" * 50)

    def start(self):
        logger.info("Starting System...")
        if self.camera:        self.camera.start()
        if self.ai_engine:     self.ai_engine.start()
        if self.streamer:      self.streamer.start()
        if self.iot_client:    self.iot_client.start()
        if self.sensor_server: self.sensor_server.start()
        if self.cloud_uploader: self.cloud_uploader.start()
        self.report_thread.start()

        try:
            while self.running:
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop()

    def stop(self):
        logger.info("Stopping System...")
        self.running = False
        if self.camera:     self.camera.stop()
        if self.ai_engine:  self.ai_engine.stop()
        if self.streamer:   self.streamer.stop()
        if self.iot_client: self.iot_client.stop()
        if self.cloud_uploader: self.cloud_uploader.stop()
        logger.info("System Stopped.")

    # ──────────────────────────────────────────────────────────────────────
    # Event handlers — nhận sự kiện từ IoT, ủy thác xử lý cho service
    # ──────────────────────────────────────────────────────────────────────

    def handle_test_image(self, b64_image, report_id=None):
        """Callback khi nhận ảnh test từ ThingsBoard."""
        if not self.ai_engine:
            logger.warning("AI Engine OFF — cannot process test image.")
            return

        logger.info("Processing test image...")
        result = self.ai_engine.process_test_image(b64_image, report_id)
        if result:
            result = self.image_processor.compress_if_needed(result)
            if self.iot_client:
                self.iot_client.send_telemetry({"image_report": result})
                logger.info("Test image result sent.")

    def handle_ota_update(self, target_version, url):
        """Callback khi nhận lệnh cập nhật OTA từ ThingsBoard."""
        self.ota_manager.handle_update(
            target_version, url, stop_callback=self.stop
        )

    def update_sensor_data(self, data):
        """Callback xử lý dữ liệu cảm biến từ ESP32 (qua HTTP)."""
        # Chuẩn hóa về dạng list[{type, value, unit}]
        if isinstance(data, list):
            normalized = data
        elif isinstance(data, dict):
            normalized = []
            for key, value in data.items():
                unit = ""
                if "temp"     in key.lower(): unit = "C"
                elif "humid"  in key.lower(): unit = "%"
                elif "moisture" in key.lower(): unit = "%"
                normalized.append({"type": key, "value": value, "unit": unit})
        else:
            return

        with self.sensor_lock:
            self.latest_sensor_data = normalized

        if self.lstm:
            self.lstm.update(normalized)

    # ──────────────────────────────────────────────────────────────────────
    # Report loop — thu thập, build và gửi báo cáo định kỳ
    # ──────────────────────────────────────────────────────────────────────

    def _report_loop(self):
        """Gửi báo cáo tổng hợp lên ThingsBoard theo chu kỳ."""
        while self.running:
            interval = self.config.get('send_interval_seconds', 10)
            for _ in range(interval):
                if not self.running:
                    return
                time.sleep(1)

            # 1. Kết quả YOLO
            plant_report = self.report_builder.build_plant_report(self.ai_engine)

            # 2. Dữ liệu cảm biến hiện tại
            with self.sensor_lock:
                sensors = self.latest_sensor_data or DEFAULT_SENSORS

            # 3. Dự đoán LSTM
            sensor_health = self.report_builder.build_sensor_health(self.lstm)

            # 4. Cảnh báo tổng hợp YOLO + LSTM
            lstm_status_str = (
                sensor_health.get("lstm_status")
                if sensor_health and sensor_health.get("lstm_ready") else None
            )
            alert = self.alert_engine.build(
                yolo_status=plant_report["stable_health_status"],
                lstm_status=lstm_status_str,
            )

            # 5. Build payload cuối & gửi
            device_report = self.report_builder.build_device_report(
                self.config, plant_report, sensors, alert, sensor_health
            )
            if self.iot_client:
                self.iot_client.send_telemetry({"device_report": device_report})
                
            # 6. Cloud upload (chỉ upload khi phát hiện bất thường)
            if self.cloud_uploader:
                self.cloud_uploader.enqueue_record(
                    frame=self.frame_cacher.get_latest(),
                    plant_report=plant_report,
                    sensors=sensors,
                    lstm_status=lstm_status_str,
                    alert_level=alert["level"],
                )

            lstm_info = (
                f"LSTM: {sensor_health['lstm_status']}"
                if sensor_health else "LSTM: OFF"
            )
            logger.info("Report sent | YOLO: %s | %s | Alert: %s",
                        plant_report['stable_health_status'],
                        lstm_info, alert['level'])


if __name__ == "__main__":
    app = MainApp()
    app.start()