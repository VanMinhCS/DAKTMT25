
// --- Stepper Motor ---
#define EN_PIN      D8      // Enable  driver
#define STEP_PIN    D9      // Step    driver
#define DIR_PIN     D10      // Dir     driver

// --- RS485 ---
#define RS485_RX    D12     // RX  của HardwareSerial 2
#define RS485_TX    D13     // TX  của HardwareSerial 2

// --- LED trạng thái (tuỳ chọn, bỏ comment TaskLEDControl để dùng) ---
#define LED_PIN     GPIO_NUM_48


#include <Arduino.h>
#include <AccelStepper.h>
#include <HardwareSerial.h>
#include <WiFi.h>
#include <ArduinoJson.h>
#include <HTTPClient.h>

// ============================================================
//  CẤU HÌNH WIFI
// ============================================================
struct WiFiConfig {
    const char* ssid;
    const char* pass;
};

WiFiConfig wifiList[] = {
    {"Thanh Le",                "010203nu" },   // WiFi chính  (ưu tiên 1)
    {"VANMINH", "abcd1234" },   // WiFi phụ    (ưu tiên 2)
};

const char* serverURL = "http://192.168.1.27:5000/api/sensor";

int   currentWiFiIdx = 0;
int   retryCount     = 0;
const int MAX_RETRIES = 5;

// ============================================================
//  CẤU HÌNH RS485 / CẢM BIẾN
// ============================================================
HardwareSerial mySerial(2);

#define SENSOR_FRAME_SIZE   19
#define SENSOR_TIMEOUT      1000    // ms

const uint32_t SEND_INTERVAL_MS  = 2400;
const uint32_t MINUTE_MS         = 60000;
const uint8_t  SENDS_PER_MINUTE  = 24;

byte requestFrame[8]          = {0x01, 0x03, 0x00, 0x00, 0x00, 0x07, 0x04, 0x08};
byte responseFrame[SENSOR_FRAME_SIZE];

uint32_t lastRequestTime  = 0;
uint32_t minuteStartTime  = 0;
uint8_t  sendCount        = 0;
uint32_t lastWiFiCheck    = 0;

// ============================================================
//  CẤU HÌNH STEPPER
// ============================================================
AccelStepper stepper(AccelStepper::DRIVER, STEP_PIN, DIR_PIN);
int motorSpeed = 600;   // steps/s — âm = ngược chiều

// Mutex bảo vệ stepper khi truy cập từ nhiều task
SemaphoreHandle_t stepperMutex;

// ============================================================
//  HÀM WIFI
// ============================================================
void connectWiFi(int idx) {
    Serial.printf("\n[WiFi] Dang ket noi: %s", wifiList[idx].ssid);
    WiFi.disconnect();
    WiFi.begin(wifiList[idx].ssid, wifiList[idx].pass);
}

void handleWiFiLogic() {
    // Ưu tiên quay lại WiFi 1 nếu đang dùng WiFi khác
    if (currentWiFiIdx != 0 && (millis() - lastWiFiCheck > 30000)) {
        Serial.println("\n[WiFi] Kiem tra lai WiFi uu tien 1...");
        int n = WiFi.scanNetworks();
        for (int i = 0; i < n; ++i) {
            if (WiFi.SSID(i) == wifiList[0].ssid) {
                Serial.println("[WiFi] Thay WiFi 1! Quay lai...");
                currentWiFiIdx = 0;
                retryCount     = 0;
                connectWiFi(0);
                return;
            }
        }
        lastWiFiCheck = millis();
    }

    if (WiFi.status() != WL_CONNECTED) {
        if (retryCount < MAX_RETRIES) {
            delay(1000);
            Serial.print(".");
            retryCount++;
        } else {
            currentWiFiIdx = (currentWiFiIdx + 1) % (sizeof(wifiList) / sizeof(WiFiConfig));
            retryCount = 0;
            Serial.printf("\n[WiFi] Chuyen sang: %s", wifiList[currentWiFiIdx].ssid);
            connectWiFi(currentWiFiIdx);
        }
    } else {
        retryCount = 0;
    }
}

// ============================================================
//  HÀM CẢM BIẾN / HTTP
// ============================================================
uint16_t calculateCRC(byte* frame, byte length) {
    uint16_t crc = 0xFFFF;
    for (byte i = 0; i < length; i++) {
        crc ^= frame[i];
        for (byte j = 0; j < 8; j++) {
            crc = (crc & 0x0001) ? (crc >> 1) ^ 0xA001 : crc >> 1;
        }
    }
    return crc;
}

void sendDataToServer(float moisture, float temp, int ec,
                      float ph, int n, int p, int k) {
    if (WiFi.status() != WL_CONNECTED) return;

    HTTPClient http;
    http.begin(serverURL);
    http.addHeader("Content-Type", "application/json");

    JsonDocument doc;
    doc["soil_moisture"] = moisture;
    doc["temperature"]   = temp;
    doc["ec"]            = ec;
    doc["ph"]            = ph;
    doc["nitrogen"]      = n;
    doc["phosphorus"]    = p;
    doc["potassium"]     = k;

    String body;
    serializeJson(doc, body);

    int code = http.POST(body);
    if (code > 0) Serial.printf("[HTTP] OK: %d\n", code);
    else          Serial.printf("[HTTP] Loi: %s\n", http.errorToString(code).c_str());
    http.end();
}

void processSensorData() {
    int16_t  rawMoisture = (responseFrame[3]  << 8) | responseFrame[4];
    int16_t  rawTemp     = (responseFrame[5]  << 8) | responseFrame[6];
    uint16_t rawEC       = (responseFrame[7]  << 8) | responseFrame[8];
    uint16_t rawPH       = (responseFrame[9]  << 8) | responseFrame[10];
    uint16_t rawN        = (responseFrame[11] << 8) | responseFrame[12];
    uint16_t rawP        = (responseFrame[13] << 8) | responseFrame[14];
    uint16_t rawK        = (responseFrame[15] << 8) | responseFrame[16];

    float f_moisture = rawMoisture / 10.0f;
    float f_temp     = rawTemp     / 10.0f;
    float f_ph       = rawPH       / 10.0f;

    Serial.println("\n--- DATA READ SUCCESS ---");
    Serial.printf("Temp: %.1fC | Hum: %.1f%% | pH: %.1f | EC: %d uS/cm | NPK: %d,%d,%d\n",
                  f_temp, f_moisture, f_ph, rawEC, rawN, rawP, rawK);

    sendDataToServer(f_moisture, f_temp, rawEC, f_ph, rawN, rawP, rawK);
}

// ============================================================
//  TASK: SENSOR + WIFI  (Core 0)
// ============================================================
void TaskSensorWiFi(void* pvParameters) {
    // Khởi động WiFi
    connectWiFi(currentWiFiIdx);

    lastRequestTime  = millis();
    minuteStartTime  = lastRequestTime;
    sendCount        = 0;
    lastWiFiCheck    = 0;

    while (1) {
        handleWiFiLogic();

        uint32_t now = millis();

        // Reset bộ đếm mỗi phút
        if (now - minuteStartTime >= MINUTE_MS) {
            uint32_t elapsed  = (now - minuteStartTime) / MINUTE_MS;
            minuteStartTime  += elapsed * MINUTE_MS;
            sendCount         = 0;
            lastRequestTime   = minuteStartTime;
        }

        // Đọc cảm biến theo chu kỳ
        if (sendCount < SENDS_PER_MINUTE && (now - lastRequestTime >= SEND_INTERVAL_MS)) {
            Serial.print("\n<TX> Requesting Sensor...");

            while (mySerial.available()) mySerial.read();   // flush
            mySerial.write(requestFrame, 8);

            unsigned long t = millis();
            while (mySerial.available() < SENSOR_FRAME_SIZE && (millis() - t) < SENSOR_TIMEOUT) {
                delay(1);
            }

            if (mySerial.available() >= SENSOR_FRAME_SIZE) {
                for (int i = 0; i < SENSOR_FRAME_SIZE; i++) responseFrame[i] = mySerial.read();

                if (responseFrame[0] == 0x01 && responseFrame[1] == 0x03) {
                    uint16_t rxCRC = (responseFrame[18] << 8) | responseFrame[17];
                    if (rxCRC == calculateCRC(responseFrame, 17)) processSensorData();
                    else Serial.println(">>> CRC Error!");
                }
            } else {
                Serial.println(">>> Sensor Timeout!");
            }

            lastRequestTime = millis();
            sendCount++;
        }

        vTaskDelay(pdMS_TO_TICKS(10));   // nhường CPU
    }
}

// ============================================================
//  TASK: STEPPER MOTOR  (Core 1 – cùng core với Arduino loop)
// ============================================================
void TaskStepper(void* pvParameters) {
    pinMode(EN_PIN, OUTPUT);
    digitalWrite(EN_PIN, LOW);          // Enable driver

    stepper.setMaxSpeed(100000);
    stepper.setAcceleration(3000);
    stepper.setSpeed(motorSpeed);

    // Chạy vài bước khởi động
    for (int i = 0; i < 200; i++) {
        stepper.runSpeed();
        delayMicroseconds(50);
    }

    Serial.println("=== Motor READY ===");

    while (1) {
        if (xSemaphoreTake(stepperMutex, 0) == pdTRUE) {
            stepper.runSpeed();
            xSemaphoreGive(stepperMutex);
        }
        taskYIELD();    // không dùng delay để không làm chậm bước motor
    }
}

// ============================================================
//  TASK: ĐỌC SERIAL → ĐIỀU KHIỂN MOTOR
// ============================================================
void TaskSerialControl(void* pvParameters) {
    while (1) {
        if (Serial.available()) {
            char c = Serial.read();

            if (xSemaphoreTake(stepperMutex, portMAX_DELAY) == pdTRUE) {
                if (c == '0') {
                    motorSpeed = -motorSpeed;
                    stepper.setSpeed(motorSpeed);
                    Serial.printf("Dao chieu -> %d\n", motorSpeed);
                }
                else if (c == '+') {
                    motorSpeed += 50;
                    stepper.setSpeed(motorSpeed);
                    Serial.printf("Tang toc -> %d\n", motorSpeed);
                }
                else if (c == '-') {
                    motorSpeed -= 50;
                    if (abs(motorSpeed) < 50) motorSpeed = 50 * (motorSpeed > 0 ? 1 : -1);
                    stepper.setSpeed(motorSpeed);
                    Serial.printf("Giam toc -> %d\n", motorSpeed);
                }
                else if (c == 's') {
                    motorSpeed = 0;
                    stepper.setSpeed(0);
                    Serial.println("Dung motor");
                }
                xSemaphoreGive(stepperMutex);
            }
        }
        vTaskDelay(pdMS_TO_TICKS(20));
    }
}

// ============================================================
//  SETUP & LOOP
// ============================================================
void setup() {
    Serial.begin(115200);
    delay(500);

    mySerial.begin(4800, SERIAL_8N1, RS485_RX, RS485_TX);

    stepperMutex = xSemaphoreCreateMutex();

    Serial.println("\n=== HE THONG KHOI DONG ===");

    // Tạo các FreeRTOS tasks
    xTaskCreatePinnedToCore(TaskSensorWiFi,    "SensorWiFi",  8192, NULL, 1, NULL, 0); // Core 0
    xTaskCreatePinnedToCore(TaskStepper,       "Stepper",     2048, NULL, 3, NULL, 1); // Core 1 – ưu tiên cao
    xTaskCreatePinnedToCore(TaskSerialControl, "SerialCtrl",  2048, NULL, 2, NULL, 1); // Core 1

    // LED tuỳ chọn – bỏ comment nếu muốn dùng
    // xTaskCreate(TaskLEDControl, "LED", 1024, NULL, 1, NULL);
}

void loop() {
    // Toàn bộ logic đã chuyển vào tasks — loop() để trống
    vTaskDelay(portMAX_DELAY);
}