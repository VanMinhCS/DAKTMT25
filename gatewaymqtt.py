import paho.mqtt.client as mqtt
import json
import time
import queue
import threading

data_queue = queue.Queue()

# Core IoT info
MQTT_SERVER = "app.coreiot.io"
MQTT_PORT = 1883
MQTT_USERNAME = "97d6dfc0-784a-11f0-a34b-bd0b37111391"
MQTT_TOKEN = "pVOXiHmqVMOf7ZkpDnED"
MQTT_PASSWORD = ""
MQTT_TOPIC = "v1/devices/me/telemetry"
MQTT_ATTRIBUTE = "v1/devices/me/attributes"

# Mosquitto info
MQTT_BROKER = "192.168.1.42"
MQTT_BROKER_PORT = 1883

# Core IoT Client 
def mqtt_connected(client, userdata, flags, reasonCode, properties):
    print("Connect with IoT Broker reson code: ", reasonCode)
    client.subscribe(MQTT_ATTRIBUTE)

def mqtt_subscribed(client, userdata, mid, granted_qos, properties=None):
    print("Subscribed to Topic!!!")

def mqtt_recv_message(client, userdata, message):
    print("Received message " + message.payload.decode("utf-8")
          + " on topic '" + message.topic
          + "' with QoS " + str(message.qos))
    
def mqtt_unsubscribed (client, userdata, mid, rc, properties):
    print("Disconnect IoT Broker with reason code: ", rc)

mqttClient = mqtt.Client(
    client_id="IoT Broker",
    userdata=None,
    protocol=mqtt.MQTTv5,
    transport="tcp",
    callback_api_version=mqtt.CallbackAPIVersion.VERSION2
)
mqttClient.username_pw_set(MQTT_TOKEN, MQTT_PASSWORD)
mqttClient.on_connect = mqtt_connected
mqttClient.on_subscribe = mqtt_subscribed
mqttClient.on_message = mqtt_recv_message
mqttClient.on_disconnect = mqtt_unsubscribed
mqttClient.connect(MQTT_SERVER, int(MQTT_PORT), 60)

mqttClient.loop_start()

# Local Client
def local_connected(client, userdata, flags, reasonCode, properties):
    print("Connect local broker with reson code: ", reasonCode)
    client.subscribe("#")

def local_subscribed(client, userdata, mid, granted_qos, properties=None):
    print("Subscribed to Topic!!!")

def local_recv_message(client, userdata, message):
    payload = message.payload.decode("utf-8")
    topic = message.topic
    print(f"Recive message: {payload} on topic {message.topic} with QoS {message.qos}")
    data_queue.put((topic, payload))
    
def local_unsubscribed (client, userdata, mid, rc, properties):
    print("Disconnect local broker with reason code: ", rc)

local_client = mqtt.Client(
    client_id="Local Broker",
    userdata={"mqttClient": mqttClient},
    protocol=mqtt.MQTTv5,
    transport="tcp",
    callback_api_version=mqtt.CallbackAPIVersion.VERSION2
    
)
local_client.on_connect = local_connected
local_client.on_subscribe = local_subscribed
local_client.on_message = local_recv_message
local_client.on_disconnect = local_unsubscribed
local_client.connect(MQTT_BROKER, MQTT_BROKER_PORT, 60)

local_client.loop_start()

device_data = {}
#  Main thread
def forward_loop():
    global device_data
    last_send = time.time()
    while True:
        if not data_queue.empty():
            topic, payload = data_queue.get()
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
                device_data[flat_key] = value

            # gửi mỗi giây
            if time.time() - last_send >= 1 and device_data:
                payload = json.dumps(device_data)
                print(f"[FORWARD] Đẩy lên CoreIoT: {payload}")
                mqttClient.publish(MQTT_TOPIC, payload, qos=1)
                last_send = time.time()
        time.sleep(0.1)

forward_thread = threading.Thread(target=forward_loop, daemon=True)
forward_thread.start()

forward_thread = threading.Thread(target=forward_loop, daemon=True)
forward_thread.start()

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("Stopping")
    mqttClient.loop_stop()
    mqttClient.disconnect()
    local_client.loop_stop()
    local_client.disconnect()