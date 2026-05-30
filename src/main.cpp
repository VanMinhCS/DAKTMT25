#include <Arduino.h>
#include <HardwareSerial.h>
#include <WiFi.h>
#include <ArduinoJson.h>
#include <HTTPClient.h>

// --- CẤU HÌNH WIFI ---
struct WiFiConfig {
    const char* ssid;
    const char* pass;
};

// Định nghĩa danh sách WiFi (Thứ tự ưu tiên từ trên xuống dưới)
WiFiConfig wifiList[] = {
    {"Thanh Le", "010203nu"},   // WiFi chính (Ưu tiên 1)
    {"Start Coffee & Tea L2_2", "xincamon"} // WiFi phụ (Ưu tiên 2)
};

const char* serverURL = "http://192.168.1.27:5000/api/sensor";

int currentWiFiIdx = 0;
int retryCount = 0;
const int MAX_RETRIES = 5;

// Định nghĩa chân RX, TX mới
#define RS485RX D12
#define RS485TX D13

HardwareSerial mySerial(2);

#define SENSOR_FRAME_SIZE 19
#define SENSOR_TIMEOUT 1000

const uint32_t SEND_INTERVAL_MS = 2400;
const uint32_t MINUTE_MS = 60000;
const uint8_t SENDS_PER_MINUTE = 24;

byte requestFrame[8] = {0x01, 0x03, 0x00, 0x00, 0x00, 0x07, 0x04, 0x08};
byte responseFrame[19];

uint32_t lastRequestTime = 0;
uint32_t minuteStartTime = 0;
uint8_t sendCount = 0;
uint32_t lastWiFiCheck = 0;

void connectWiFi(int idx) {
    Serial.printf("\nDang ket noi vao: %s", wifiList[idx].ssid);
    WiFi.disconnect(); // Ngắt kết nối cũ để làm sạch
    WiFi.begin(wifiList[idx].ssid, wifiList[idx].pass);
}

void handleWiFiLogic() {
    // 1. Kiểm tra ưu tiên WiFi 1 (nếu đang dùng WiFi khác)
    if (currentWiFiIdx != 0 && (millis() - lastWiFiCheck > 30000)) { 
        Serial.println("\n[He thong] Dang kiem tra lai WiFi uu tien 1...");
        // Thử quét xem WiFi 1 có xuất hiện lại không (không ngắt mạng hiện tại)
        int n = WiFi.scanNetworks();
        for (int i = 0; i < n; ++i) {
            if (WiFi.SSID(i) == wifiList[0].ssid) {
                Serial.println("[He thong] Thay WiFi 1 da online! Dang quay lai...");
                currentWiFiIdx = 0;
                retryCount = 0;
                connectWiFi(0);
                return;
            }
        }
        lastWiFiCheck = millis();
    }

    // 2. Xử lý mất mạng hoặc thử lại
    if (WiFi.status() != WL_CONNECTED) {
        if (retryCount < MAX_RETRIES) {
            delay(1000);
            Serial.print(".");
            retryCount++;
        } else {
            // Đã thử 5 lần không được, đổi sang WiFi tiếp theo
            currentWiFiIdx = (currentWiFiIdx + 1) % (sizeof(wifiList) / sizeof(WiFiConfig));
            retryCount = 0;
            Serial.printf("\n[Canh bao] Ket noi that bai! Chuyen sang: %s", wifiList[currentWiFiIdx].ssid);
            connectWiFi(currentWiFiIdx);
        }
    } else {
        retryCount = 0; // Reset count nếu đang online ổn định
    }
}

uint16_t calculateCRC(byte *frame, byte length) {
  uint16_t crc = 0xFFFF;
  for (byte i = 0; i < length; i++) {
    crc ^= frame[i];
    for (byte j = 0; j < 8; j++) {
      if (crc & 0x0001) {
        crc >>= 1;
        crc ^= 0xA001;
      } else {
        crc >>= 1;
      }
    }
  }
  return crc;
}

void sendDataToServer(float moisture, float temp, int ec, float ph, int n, int p, int k) {
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        http.begin(serverURL);
        http.addHeader("Content-Type", "application/json");

        JsonDocument doc;
        doc["soil_moisture"] = moisture;
        doc["temperature"] = temp;
        doc["ec"] = ec;
        doc["ph"] = ph;
        doc["nitrogen"] = n;
        doc["phosphorus"] = p;
        doc["potassium"] = k;

        String requestBody;
        serializeJson(doc, requestBody);
        int httpResponseCode = http.POST(requestBody);

        if (httpResponseCode > 0) {
            Serial.printf("[HTTP] Thanh cong: %d\n", httpResponseCode);
        } else {
            Serial.printf("[HTTP] Loi: %s\n", http.errorToString(httpResponseCode).c_str());
        }
        http.end();
    }
}

void processSensorData() {
    int16_t rawMoisture = (responseFrame[3] << 8) | responseFrame[4];
    int16_t rawTemp     = (responseFrame[5] << 8) | responseFrame[6];
    uint16_t rawEC      = (responseFrame[7] << 8) | responseFrame[8];
    uint16_t rawPH      = (responseFrame[9] << 8) | responseFrame[10];
    uint16_t rawN       = (responseFrame[11] << 8) | responseFrame[12];
    uint16_t rawP       = (responseFrame[13] << 8) | responseFrame[14];
    uint16_t rawK       = (responseFrame[15] << 8) | responseFrame[16];

    float f_moisture = (float)rawMoisture / 10.0;
    float f_temp = (float)rawTemp / 10.0;
    float f_ph = (float)rawPH / 10.0;

    Serial.println("\n--- DATA READ SUCCESS ---");
    Serial.printf("Temp: %.1fC | Hum: %.1f%% | pH: %.1f | ec: %duS/cm | NPK: %d,%d,%d\n", f_temp, f_moisture, f_ph, rawEC, rawN, rawP, rawK);

    sendDataToServer(f_moisture, f_temp, rawEC, f_ph, rawN, rawP, rawK);
}

void TaskLEDControl(void *pvParameters) {
  pinMode(GPIO_NUM_48, OUTPUT); // Initialize LED pin
  int ledState = 0;
  while(1) {
    
    if (ledState == 0) {
      digitalWrite(GPIO_NUM_48, HIGH); // Turn ON LED
    } else {
      digitalWrite(GPIO_NUM_48, LOW); // Turn OFF LED
    }
    ledState = 1 - ledState;
    vTaskDelay(2000);
  }
}

void setup() {
    Serial.begin(115200);
    // while (!Serial) {};

    mySerial.begin(4800, SERIAL_8N1, RS485RX, RS485TX);
    // xTaskCreate(TaskLEDControl, "LED Control", 2048, NULL, 2, NULL);

    Serial.println("\n--- HE THONG DOC CAM BIEN QUA RS485 ---");
    delay(1000);
    lastRequestTime = millis();
    minuteStartTime = lastRequestTime;
    sendCount = 0;
}

void loop() {
    // Luôn xử lý logic WiFi đầu vòng lặp
    handleWiFiLogic();

    uint32_t now = millis();
    if (now - minuteStartTime >= MINUTE_MS) {
        uint32_t minutesElapsed = (now - minuteStartTime) / MINUTE_MS;
        minuteStartTime += minutesElapsed * MINUTE_MS;
        sendCount = 0;
        lastRequestTime = minuteStartTime;
    }

    if (sendCount < SENDS_PER_MINUTE && (now - lastRequestTime >= SEND_INTERVAL_MS)) {
        Serial.print("\n<TX> Requesting Sensor...");
        
        while(mySerial.available()) mySerial.read(); 
        mySerial.write(requestFrame, 8);
        
        unsigned long resptime = millis();
        while ((mySerial.available() < SENSOR_FRAME_SIZE) && ((millis() - resptime) < SENSOR_TIMEOUT)) {
            delay(1);
        }

        if (mySerial.available() >= SENSOR_FRAME_SIZE) {
            for (int n = 0; n < SENSOR_FRAME_SIZE; n++) {
                responseFrame[n] = mySerial.read();
            }

            if (responseFrame[0] == 0x01 && responseFrame[1] == 0x03) {
                uint16_t receivedCRC = (responseFrame[18] << 8) | responseFrame[17];
                if (receivedCRC == calculateCRC(responseFrame, 17)) {
                    processSensorData();
                } else {
                    Serial.println(">>> CRC Error!");
                }
            }
        } else {
            Serial.println(">>> Sensor Timeout!");
        }
        lastRequestTime = millis();
        sendCount++;
    }
}