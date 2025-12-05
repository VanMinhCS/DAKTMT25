import json
import paho.mqtt.client as mqtt
import threading
import time

class IoTClient:
    def __init__(self, config):
        self.config = config
        self.client = None
        self.connected = False
        self.on_test_image_received = None # Callback function
        self.on_update_received = None # Callback function

    def start(self):
        host = self.config.get('thingsboard_host')
        token = self.config.get('thingsboard_access_token')
        
        if not host or not token:
            print("IoT Config missing.")
            return

        self.client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2)
        self.client.on_connect = self._on_connect
        self.client.on_message = self._on_message
        self.client.username_pw_set(token)
        
        try:
            self.client.connect(host, 1883, 60)
            self.client.loop_start()
            print(f"Connecting to ThingsBoard at {host}...")
        except Exception as e:
            print(f"IoT Connection Error: {e}")

    def stop(self):
        if self.client:
            self.client.loop_stop()
            self.client.disconnect()

    def send_telemetry(self, data):
        if self.client and self.connected:
            try:
                self.client.publish('v1/devices/me/telemetry', json.dumps(data))
                # print("Telemetry sent.")
            except Exception as e:
                print(f"Send Error: {e}")

    def _on_connect(self, client, userdata, flags, rc, properties=None):
        if rc == 0:
            self.connected = True
            print("Connected to ThingsBoard!")
            client.subscribe('v1/devices/me/attributes')
            client.publish('v1/devices/me/attributes/request/1', '{"sharedKeys":"target_version,firmware_url"}')
        else:
            print(f"Connection failed with code {rc}")

    def _on_message(self, client, userdata, msg):
        if msg.topic.startswith('v1/devices/me/attributes'):
            try:
                data = json.loads(msg.payload.decode())
                data = data.get('shared', data)
                
                # Xử lý OTA
                if data.get('target_version') and self.on_update_received:
                    self.on_update_received(data.get('target_version'), data.get('firmware_url'))
                
                # Xử lý Test Ảnh
                if data.get('Image') and self.on_test_image_received:
                    # Chạy trên thread riêng để không block MQTT loop
                    threading.Thread(target=self.on_test_image_received, args=(data['Image'],), daemon=True).start()
            except Exception as e:
                print(f"Message Error: {e}")
