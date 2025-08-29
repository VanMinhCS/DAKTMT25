#include <iostream>
#include <cstring>
#include <string>
#include <mutex>
#include <thread>
#include <chrono>
#include <atomic>
#include <queue>
#include <condition_variable>
#include "mqtt/async_client.h"
#include "mqtt/message.h"
#include "nlohmann/json.hpp"

using namespace std;
using json = nlohmann::json;

// Định nghĩa hằng tĩnh bị thiếu (do lỗi thư viện)
const string mqtt::message::EMPTY_STR;
const mqtt::binary mqtt::message::EMPTY_BIN;

const string MQTT_SERVER = "tcp://app.coreiot.io:1883";
const string MQTT_CLIENT_ID = "publisher";
const string MQTT_USERNAME = "YOUR_USER_NAME"; // No need so much
const string MQTT_TOKEN = "YOUR_TOKEN";
const string MQTT_PASSWORD = "";
const string MQTT_TOPIC = "v1/devices/me/telemetry";
const string MQTT_ATTRIBUTE = "v1/devices/me/attributes";
const int MQTT_QOS = 1;

const std::string LOCAL_BROKER("tcp://localhost:1883");
const std::string LOCAL_CLIENT_ID("subscriber");
const std::string LOCAL_TOPIC("#"); // lắng nghe trên mọi topic
const int LOCAL_QOS = 1;

const int TIMEOUT = 1000;

queue<string> message_queue;
atomic<bool> running{true};

class PublisherCallback : public virtual mqtt::callback
{
public:
    void connection_lost(const std::string& cause) override
    {
        std::cout << "Publisher connection lost: " << cause << std::endl;
    }

    void connected (const string& cause) override {
        cout << "Publisher connected.\n";
    }

    void delivery_complete(mqtt::delivery_token_ptr token) override
    {
        std::cout << "Message delivered" << std::endl;
    }
};

class SubscriberCallback : public virtual mqtt::callback
{
public:
    void connection_lost(const std::string& cause) override
    {
        std::cout << "Connection lost: " << cause << std::endl;
    }

    void connected (const string& cause) override {
        cout << "Subscriber connected.\n";
    }

    void message_arrived(mqtt::const_message_ptr message) override
    {
        try
        {
            string recieved_payload = message->get_payload_str();
            message_queue.push(recieved_payload);
            cout << "Recived message: " << recieved_payload << '\n';
        }
        catch(const mqtt::exception& e)
        {
            std::cerr << "Error reciving message" << e.what() << '\n';
        }
        

    }

    void delivery_complete(mqtt::delivery_token_ptr token) override
    {
        std::cout << "Message delivered" << std::endl;
    }
};

int main() {
    mqtt::async_client local_client(LOCAL_BROKER, LOCAL_CLIENT_ID);
    mqtt::connect_options local_connOpts;
    local_connOpts.set_keep_alive_interval(60);
    local_connOpts.set_clean_session(true);
    local_connOpts.set_automatic_reconnect(true);
    

    mqtt::async_client mqtt_client(MQTT_SERVER, MQTT_CLIENT_ID);
    mqtt::connect_options mqtt_connOpts;
    mqtt_connOpts.set_keep_alive_interval(60);
    mqtt_connOpts.set_clean_session(true);
    mqtt_connOpts.set_automatic_reconnect(true);
    mqtt_connOpts.set_user_name(MQTT_TOKEN);
    mqtt_connOpts.set_password(MQTT_PASSWORD);

    try {
        PublisherCallback mqtt_callback;
        mqtt_client.set_callback(mqtt_callback);
        mqtt::token_ptr mqtt_connection_token = mqtt_client.connect(mqtt_connOpts);
        mqtt_connection_token->wait();
        if (mqtt_connection_token->is_complete()) {
            cout << "Connected to Core IoT server!\n";
        }
        else {
            cerr << "Failed to connect to Core IoT server!\n";
            return -1;
        }

        SubscriberCallback local_callback;
        local_client.set_callback(local_callback);
        mqtt::token_ptr local_connection_token = local_client.connect(local_connOpts);
        local_connection_token->wait();
        if (local_connection_token->is_complete()) {
            cout << "Connected to local broker!\n";
        }
        else {
            cerr << "Failed to connect to local broker!\n";
            return -1;
        }
        local_client.subscribe(LOCAL_TOPIC, LOCAL_QOS)->wait();
        while (true){
            if (!message_queue.empty()) {
                string send = message_queue.front();
                mqtt::message_ptr pubMessage = mqtt::make_message(MQTT_TOPIC, send, MQTT_QOS, false);
                mqtt_client.publish(pubMessage);
                message_queue.pop();
            }
            this_thread::sleep_for(chrono::milliseconds(10));
        }

        // shutdown
        running = false;

        local_client.disconnect()->wait();
        mqtt_client.disconnect()->wait();
    }
    catch (const mqtt::exception& ex) {
        cerr << "MQTT exception: " << ex.what() << '\n';
        return -1;
    }

    cout << "End of gateway!\n";
    return 0;

}
