import threading
from flask import Flask, request, jsonify
from ..core.logger import get_logger
from ..core import metrics

logger = get_logger("SensorServer")

# Khoảng giới hạn hợp lệ để phát hiện sensor gửi dữ liệu rác
_SENSOR_BOUNDS = {
    "soil_moisture":    (0.0,   100.0),
    "moisture":         (0.0,   100.0),
    "soil_temperature": (-10.0, 80.0),
    "temperature":      (-10.0, 80.0),
    "temp":             (-10.0, 80.0),
    "ph":               (0.0,   14.0),
    "ec":               (0.0,   10000.0),
    "nitrogen":         (0.0,   1000.0),
    "phosphorus":       (0.0,   1000.0),
    "potassium":        (0.0,   1000.0),
}


class SensorServer:
    def __init__(self, config, data_callback=None):
        self.config = config
        self.port = self.config.get('sensor_server_port', 5000)
        self.app = Flask(__name__)
        self.running = False
        self.thread = None
        self.data_callback = data_callback

        # Đăng ký route
        self.app.add_url_rule(
            '/api/sensor', 'receive_sensor_data',
            self.receive_sensor_data, methods=['POST']
        )

    def receive_sensor_data(self):
        try:
            data = request.json
            if not data:
                metrics.log_iot_event("SENSOR_ERROR", {
                    "reason": "No JSON body in request",
                    "remote": request.remote_addr,
                })
                return jsonify({"status": "error", "message": "No JSON data provided"}), 400

            logger.debug("Received sensor data: %s", data)

            # Kiểm tra các giá trị ngoài khoảng hợp lệ
            items = data if isinstance(data, list) else [
                {"type": k, "value": v} for k, v in data.items()
                if isinstance(v, (int, float))
            ]
            for item in items:
                key   = str(item.get("type", "")).lower().strip()
                value = item.get("value")
                if key in _SENSOR_BOUNDS and value is not None:
                    lo, hi = _SENSOR_BOUNDS[key]
                    try:
                        fv = float(value)
                        if fv < lo or fv > hi:
                            metrics.log_iot_event("SENSOR_OUT_OF_RANGE", {
                                "sensor": key,
                                "value":  fv,
                                "valid_range": [lo, hi],
                            })
                    except (TypeError, ValueError):
                        metrics.log_iot_event("SENSOR_ERROR", {
                            "reason": f"Non-numeric value for sensor '{key}'",
                            "value":  str(value),
                        })

            if self.data_callback:
                self.data_callback(data)

            return jsonify({"status": "success", "message": "Data received"}), 200

        except Exception as e:
            logger.error("Error processing sensor request: %s", e)
            metrics.log_iot_event("SENSOR_ERROR", {"reason": str(e)})
            return jsonify({"status": "error", "message": str(e)}), 500

    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._run_server, daemon=True)
        self.thread.start()
        logger.info("HTTP Sensor Server started on port %s", self.port)

    def _run_server(self):
        # host='0.0.0.0' để nhận request từ mọi IP trong mạng LAN
        self.app.run(host='0.0.0.0', port=self.port, debug=False, use_reloader=False)

    def stop(self):
        self.running = False
        logger.info("Sensor Server stopped.")
