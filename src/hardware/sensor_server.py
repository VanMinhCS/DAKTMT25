import threading
from flask import Flask, request, jsonify
from ..core.logger import get_logger

logger = get_logger("SensorServer")


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
                return jsonify({"status": "error", "message": "No JSON data provided"}), 400

            logger.debug("Received sensor data: %s", data)

            if self.data_callback:
                self.data_callback(data)

            return jsonify({"status": "success", "message": "Data received"}), 200

        except Exception as e:
            logger.error("Error processing sensor request: %s", e)
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
