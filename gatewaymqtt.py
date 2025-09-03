import paho.mqtt.client as mqtt
import json
import time
import queue
import threading

class MQTTGateway:
    def __init__(self):
        self.data_queue = queue.Queue()
        self.device_data = {}
        
        # Core IoT info
        self.MQTT_SERVER = "app.coreiot.io"
        self.MQTT_PORT = 1883
        self.MQTT_USERNAME = "YOUR_USER_NAME"
        self.MQTT_TOKEN = "YOUR_TOKEN"
        self.MQTT_PASSWORD = ""
        self.MQTT_TOPIC = "v1/devices/me/telemetry"
        self.MQTT_ATTRIBUTE = "v1/devices/me/attributes"
        
        # Mosquitto info
        self.MQTT_BROKER = "192.168.1.42" # demo
        self.MQTT_BROKER_PORT = 1883
        
        self.mqttClient = None
        self.local_client = None
        self.forward_thread = None
        
    # Core IoT Client callbacks
    def mqtt_connected(self, client, userdata, flags, reasonCode, properties):
        print("Connect with IoT Broker reason code: ", reasonCode)
        client.subscribe(self.MQTT_ATTRIBUTE)

    def mqtt_subscribed(self, client, userdata, mid, granted_qos, properties=None):
        print("Subscribed to Topic!!!")

    def mqtt_recv_message(self, client, userdata, message):
        print("Received message " + message.payload.decode("utf-8")
              + " on topic '" + message.topic
              + "' with QoS " + str(message.qos))
        
    def mqtt_unsubscribed(self, client, userdata, mid, rc, properties):
        print("Disconnect IoT Broker with reason code: ", rc)

    # Local Client callbacks
    def local_connected(self, client, userdata, flags, reasonCode, properties):
        print("Connect local broker with reason code: ", reasonCode)
        client.subscribe("#")

    def local_subscribed(self, client, userdata, mid, granted_qos, properties=None):
        print("Subscribed to Topic!!!")

    def local_recv_message(self, client, userdata, message):
        payload = message.payload.decode("utf-8")
        topic = message.topic
        print(f"Receive message: {payload} on topic {topic} with QoS {message.qos}")
        self.data_queue.put((topic, payload))
        
    def local_unsubscribed(self, client, userdata, mid, rc, properties):
        print("Disconnect local broker with reason code: ", rc)

    def setup_core_iot_client(self):
        """Khởi tạo và kết nối Core IoT client"""
        self.mqttClient = mqtt.Client(
            client_id="IoT Broker",
            userdata=None,
            protocol=mqtt.MQTTv5,
            transport="tcp",
            callback_api_version=mqtt.CallbackAPIVersion.VERSION2
        )
        self.mqttClient.username_pw_set(self.MQTT_TOKEN, self.MQTT_PASSWORD)
        self.mqttClient.on_connect = self.mqtt_connected
        self.mqttClient.on_subscribe = self.mqtt_subscribed
        self.mqttClient.on_message = self.mqtt_recv_message
        self.mqttClient.on_disconnect = self.mqtt_unsubscribed
        self.mqttClient.connect(self.MQTT_SERVER, int(self.MQTT_PORT), 60)
        self.mqttClient.loop_start()

    def setup_local_client(self):
        """Khởi tạo và kết nối Local client"""
        self.local_client = mqtt.Client(
            client_id="Local Broker",
            userdata={"mqttClient": self.mqttClient},
            protocol=mqtt.MQTTv5,
            transport="tcp",
            callback_api_version=mqtt.CallbackAPIVersion.VERSION2
        )
        self.local_client.on_connect = self.local_connected
        self.local_client.on_subscribe = self.local_subscribed
        self.local_client.on_message = self.local_recv_message
        self.local_client.on_disconnect = self.local_unsubscribed
        self.local_client.connect(self.MQTT_BROKER, self.MQTT_BROKER_PORT, 60)
        self.local_client.loop_start()

    def forward_loop(self):
        """Vòng lặp chính để forward dữ liệu"""
        last_send = time.time()
        while True:
            if not self.data_queue.empty():
                topic, payload = self.data_queue.get()
                try:
                    data = json.loads(payload)
                except:
                    continue
                
                device_id = data.get("device_id", "unknown")
                if "device_id" in data:
                    del data["device_id"]

                # Phẳng dữ liệu thành device.key
                for key, value in data.items():
                    flat_key = f"{device_id}.{key}"
                    self.device_data[flat_key] = value

                # gửi mỗi giây
                if time.time() - last_send >= 1 and self.device_data:
                    payload_to_send = json.dumps(self.device_data)
                    print(f"[FORWARD] Đẩy lên CoreIoT: {payload_to_send}")
                    self.mqttClient.publish(self.MQTT_TOPIC, payload_to_send, qos=1)
                    last_send = time.time()
            time.sleep(0.1)

    def start(self):
        """Khởi động gateway"""
        print("Starting MQTT Gateway...")
        self.setup_core_iot_client()
        self.setup_local_client()
        
        # Khởi động forward thread
        self.forward_thread = threading.Thread(target=self.forward_loop, daemon=True)
        self.forward_thread.start()
        
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop()

    def stop(self):
        """Dừng gateway"""
        print("Stopping MQTT Gateway...")
        if self.mqttClient:
            self.mqttClient.loop_stop()
            self.mqttClient.disconnect()
        if self.local_client:
            self.local_client.loop_stop()
            self.local_client.disconnect()

# Sử dụng
if __name__ == "__main__":
    gateway = MQTTGateway()
    gateway.start()