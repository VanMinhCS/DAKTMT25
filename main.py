import time
import sys
import os
import uuid
import json
import threading
import requests
import zipfile
from datetime import datetime

from src.utils import load_config
from src.camera import Camera
from src.ai_engine import AIEngine
from src.iot_client import IoTClient
from src.streamer import RTSPStreamer
from src.sensor_server import SensorServer

class MainApp:
    def __init__(self):
        self.config = load_config("config.json")
        self.running = True
        
        # Cache lưu dữ liệu sensor mới nhất.
        # Khởi tạo None để biết là chưa có dữ liệu thực
        self.latest_sensor_data = None
        self.sensor_lock = threading.Lock() # Lock để đồng bộ hóa dữ liệu

        # Khởi tạo các module
        self.camera = Camera(self.config)
        
        # Wrapper để AI Engine có thể lấy dữ liệu sensor mới nhất từ MainApp
        class SensorProvider:
            def __init__(self, app): self.app = app
            def get_data(self): 
                with self.app.sensor_lock:
                    # Nếu chưa có dữ liệu thực, trả về dữ liệu mặc định (giá trị 0) để tránh lỗi Dashboard
                    if self.app.latest_sensor_data is None:
                        return [
                            {"type": "temperature", "value": 0, "unit": "C"},
                            {"type": "humidity", "value": 0, "unit": "%"},
                            {"type": "soil_moisture", "value": 0, "unit": "%"}
                        ]
                    return self.app.latest_sensor_data
            
        self.ai_engine = AIEngine(self.config, sensor_manager=SensorProvider(self))
        
        self.iot_client = IoTClient(self.config)
        self.streamer = RTSPStreamer(self.config)

        # Khởi tạo Sensor Server
        # Khi nhận data: 1. Gửi lên TB ngay, 2. Cập nhật vào cache local
        self.sensor_server = SensorServer(self.config, data_callback=self.update_sensor_data)
        
        # Kết nối các module (Wiring)
        # 1. Camera đẩy frame cho AI và Streamer
        self.camera.add_queue(self.ai_engine.input_queue)
        self.camera.add_queue(self.streamer.frame_queue)
        
        # 2. AI đẩy kết quả vẽ cho Streamer
        # (Chúng ta cần một cơ chế để chuyển data từ queue này sang queue kia, 
        # hoặc để Streamer đọc trực tiếp từ queue của AI. 
        # Ở đây tôi gán queue của Streamer bằng queue output của AI để đơn giản hóa, 
        # nhưng đúng ra Streamer nên có queue riêng và ta forward dữ liệu qua)
        self.streamer.result_queue = self.ai_engine.output_queue
        
        # 3. Đăng ký callback cho IoT Client
        self.iot_client.on_test_image_received = self.handle_test_image
        self.iot_client.on_update_received = self.handle_ota_update

        # Thread gửi báo cáo định kỳ
        self.report_thread = threading.Thread(target=self._report_loop, daemon=True)

    def start(self):
        print("Starting System...")
        self.camera.start()
        self.ai_engine.start()
        self.streamer.start()
        self.iot_client.start()
        self.sensor_server.start()
        self.report_thread.start()
        
        try:
            while self.running:
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop()

    def stop(self):
        print("Stopping System...")
        self.running = False
        self.camera.stop()
        self.ai_engine.stop()
        self.streamer.stop()
        self.iot_client.stop()
        print("System Stopped.")

    def handle_test_image(self, b64_image, report_id=None):
        """Callback khi nhận được ảnh test từ IoT"""
        print("Processing test image...")
        result = self.ai_engine.process_test_image(b64_image, report_id)
        if result:
            self.iot_client.send_telemetry(result)
            print("Test result sent.")

    def handle_ota_update(self, target_version, url):
        """Callback khi có bản cập nhật"""
        current_version = self.config.get('current_version', 'v1.0')
        if target_version != current_version:
            print(f"Updating firmware to {target_version}...")
            try:
                r = requests.get(url, timeout=60)
                r.raise_for_status()
                with open("update.zip", "wb") as f:
                    f.write(r.content)
                with zipfile.ZipFile("update.zip", 'r') as z:
                    z.extractall(".")
                os.remove("update.zip")
                
                print("Update installed. Restarting...")
                self.stop()
                os.execv(sys.executable, ['python'] + sys.argv)
            except Exception as e:
                print(f"Update Failed: {e}")

    def update_sensor_data(self, data):
        """Callback xử lý dữ liệu từ Sensor Server"""
        # Chỉ cập nhật Cache, KHÔNG gửi lên ThingsBoard ngay lập tức
        
        # Trường hợp 1: Data là List (Format mới từ ESP32: [{"type":..., "value":...}])
        if isinstance(data, list):
            with self.sensor_lock:
                self.latest_sensor_data = data

        # Trường hợp 2: Data là Dict (Format cũ: {"temperature": 25, ...})
        elif isinstance(data, dict):
            # Convert sang List để lưu Cache
            formatted_list = []
            for key, value in data.items():
                unit = ""
                if "temp" in key.lower(): unit = "C"
                elif "humid" in key.lower() or "moisture" in key.lower(): unit = "%"
                
                formatted_list.append({
                    "type": key,
                    "value": value,
                    "unit": unit
                })
            
            with self.sensor_lock:
                self.latest_sensor_data = formatted_list
        # print(f"Local Sensor Cache Updated: {data}")

    def _report_loop(self):
        """Gửi báo cáo định kỳ"""
        while self.running:
            interval = self.config.get('send_interval_seconds', 10)
            for _ in range(interval):
                if not self.running: return
                time.sleep(1)
            
            # Lấy dữ liệu tổng hợp từ AI Engine
            detection_counts = self.ai_engine.get_aggregated_data()
            
            plant_report = {
                "report_id": str(uuid.uuid4()),
                "plant_name": "Unknown",
                "plant_disease": "None",
                "stable_health_status": "Checking",
                "detectedAt": datetime.now().isoformat()
            }

            if not detection_counts:
                plant_report["stable_health_status"] = "Checking"
            else:
                best_class = max(detection_counts, key=detection_counts.get)
                count = detection_counts[best_class]
                CONF_THRESH = 5
                
                parts = best_class.split('_', 1)
                p_name = parts[0].lower() if len(parts)==2 else "Unknown"
                d_name = parts[1].replace('_', ' ') if len(parts)==2 else best_class
                
                plant_report.update({
                    "plant_name": p_name,
                    "plant_disease": d_name,
                    "debug_detection_count": count
                })

                if "healthy" in best_class.lower():
                    plant_report["stable_health_status"] = "Healthy"
                elif count >= CONF_THRESH:
                    plant_report["stable_health_status"] = "Warning"
                else:
                    plant_report["stable_health_status"] = "Checking"

            # Lấy dữ liệu sensor (xử lý fallback nếu chưa có)
            current_sensors = None
            with self.sensor_lock:
                if self.latest_sensor_data is None:
                    current_sensors = [
                        {"type": "temperature", "value": 0, "unit": "C"},
                        {"type": "humidity", "value": 0, "unit": "%"},
                        {"type": "soil_moisture", "value": 0, "unit": "%"}
                    ]
                else:
                    current_sensors = self.latest_sensor_data

            full_payload = {
                "device_report": {
                    "deviceId": self.config.get("deviceId"),
                    "plantId": self.config.get("plantId"),
                    "plant": plant_report,
                    "sensors": current_sensors
                }
            }
            
            self.iot_client.send_telemetry(full_payload)
            print(f"Sent Periodic Report: {plant_report['stable_health_status']}")

if __name__ == "__main__":
    app = MainApp()
    app.start()
