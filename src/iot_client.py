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
        self.client.on_disconnect = self._on_disconnect
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
                payload = json.dumps(data)
                size_kb = len(payload) / 1024
                print(f"[IoT] Sending telemetry... Size: {size_kb:.2f} KB")
                
                info = self.client.publish('v1/devices/me/telemetry', payload)
                if info.rc != mqtt.MQTT_ERR_SUCCESS:
                    print(f"Send Error: MQTT Return Code {info.rc}")
            except Exception as e:
                print(f"Send Error: {e}")
        else:
            print("Send Error: MQTT Client not connected.")

    def _on_connect(self, client, userdata, flags, rc, properties=None):
        if rc == 0:
            self.connected = True
            print("Connected to ThingsBoard!")
            client.subscribe('v1/devices/me/attributes')
            client.publish('v1/devices/me/attributes/request/1', '{"sharedKeys":"target_version,firmware_url"}')
        else:
            print(f"Connection failed with code {rc}")

    def _on_disconnect(self, client, userdata, flags, rc, properties=None):
        self.connected = False
        print(f"Disconnected from ThingsBoard! (Code: {rc})")

    def _on_message(self, client, userdata, msg):
        if msg.topic.startswith('v1/devices/me/attributes'):
            try:
                data = json.loads(msg.payload.decode())
                data = data.get('shared', data)
                
                # Xử lý OTA
                if data.get('target_version') and self.on_update_received:
                    self.on_update_received(data.get('target_version'), data.get('firmware_url'))
                
                # Xử lý Test Ảnh (Hỗ trợ key 'image_request' là JSON {image, uuid} HOẶC raw base64 string)
                if data.get('image_request') and self.on_test_image_received:
                    payload = data.get('image_request')
                    b64_img = None
                    req_id = None

                    try:
                        # 1. Thử xử lý như JSON Object
                        parsed = None
                        print(f"[IoT] Received image_request. Type: {type(payload)}")
                        if isinstance(payload, str):
                            print(f"[IoT] Payload start: {payload[:50]}...")
                            print(f"[IoT] Payload length: {len(payload)}")

                        if isinstance(payload, dict):
                            parsed = payload
                        elif isinstance(payload, str):
                            s_payload = payload.strip()
                            if s_payload.startswith('{'):
                                try:
                                    parsed = json.loads(s_payload)
                                    print("[IoT] Parsed JSON successfully.")
                                except Exception as e:
                                    print(f"[IoT] JSON parse error: {e}")
                            elif s_payload.startswith('uuid:'):
                                try:
                                    import re
                                    # Format: uuid:...,image:...
                                    # Cải thiện regex để chấp nhận khoảng trắng
                                    match = re.search(r'uuid:\s*([^,]+),\s*image:\s*(.+)', s_payload, re.DOTALL)
                                    if match:
                                        req_id = match.group(1).strip()
                                        b64_img = match.group(2).strip()
                                        print(f"[IoT] Parsed custom format. UUID: {req_id}")
                                    else:
                                        print("[IoT] Custom format regex failed to match.")
                                except Exception as e:
                                    print(f"[IoT] Custom format parse error: {e}")

                        if parsed and isinstance(parsed, dict):
                            b64_img = parsed.get('image')
                            req_id = parsed.get('uuid')
                            if b64_img:
                                print(f"[IoT] Extracted image from JSON. Length: {len(b64_img)}")
                            else:
                                print("[IoT] No 'image' key in JSON.")
                        
                        # 2. Fallback: Nếu chưa lấy được ảnh và payload là string (không phải JSON object)
                        if b64_img is None and isinstance(payload, str) and not payload.strip().startswith('{') and not payload.strip().startswith('uuid:'):
                            print("[IoT] Fallback to raw string as image.")
                            b64_img = payload

                    except Exception as e:
                        print(f"Error parsing image_request: {e}")

                    # Chỉ xử lý nếu có ảnh
                    if b64_img:
                        threading.Thread(target=self.on_test_image_received, args=(b64_img, req_id), daemon=True).start()
            except Exception as e:
                print(f"Message Error: {e}")
