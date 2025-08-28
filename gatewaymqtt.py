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
MQTT_BROKER = "localhost"
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
    while True:
        try:
            client.reconnect()
            print("Reconnect to IoT Broker")
            break
        except:
            print("Reconnect failed")
            time.sleep(1)

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
mqttClient.connect(MQTT_SERVER, int(MQTT_PORT), 120)

mqttClient.loop_start()

# Local Client
def local_connected(client, userdata, flags, reasonCode, properties):
    print("Connect local broker with reson code: ", reasonCode)
    client.subscribe("#")

def local_subscribed(client, userdata, mid, granted_qos, properties=None):
    print("Subscribed to Topic!!!")

def local_recv_message(client, userdata, message):
    payload = message.payload.decode("utf-8")
    print(f"Recive message: {payload} on topic {message.topic} with QoS {message.qos}")
    data_queue.put(payload)
    
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

# Main thread
def forward_loop():
    while True:
        if not data_queue.empty():
            data = data_queue.get()
            try:
                json.loads(data)
            except:
                data = json.dumps(data)
            print(f"[FORWARD] Đẩy lên CoreIoT: {data}")
            mqttClient.publish(MQTT_TOPIC, data, qos=1)
        time.sleep(0.1)

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