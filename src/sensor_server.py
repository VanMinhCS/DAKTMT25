import threading
from flask import Flask, request, jsonify
import logging

# Tắt log mặc định của Flask để đỡ rối terminal
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

class SensorServer:
    def __init__(self, config, data_callback=None):
        self.config = config
        self.port = self.config.get('sensor_server_port', 5000)
        self.app = Flask(__name__)
        self.running = False
        self.thread = None
        self.data_callback = data_callback # Hàm callback để xử lý dữ liệu (ví dụ: gửi lên ThingsBoard)

        # Đăng ký routes
        self.app.add_url_rule('/api/sensor', 'receive_sensor_data', self.receive_sensor_data, methods=['POST'])

    def receive_sensor_data(self):
        try:
            data = request.json
            if not data:
                return jsonify({"status": "error", "message": "No JSON data provided"}), 400
            
            print(f"[SensorServer] Received data: {data}")
            
            # Gọi callback nếu có (để chuyển dữ liệu sang IoTClient)
            if self.data_callback:
                self.data_callback(data)
                
            return jsonify({"status": "success", "message": "Data received"}), 200
        except Exception as e:
            print(f"[SensorServer] Error processing request: {e}")
            return jsonify({"status": "error", "message": str(e)}), 500

    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._run_server, daemon=True)
        self.thread.start()
        print(f"HTTP Sensor Server started on port {self.port}")

    def _run_server(self):
        # host='0.0.0.0' để nhận request từ mọi IP trong mạng LAN
        self.app.run(host='0.0.0.0', port=self.port, debug=False, use_reloader=False)

    def stop(self):
        self.running = False
        # Flask thread là daemon nên sẽ tự tắt khi main thread tắt
