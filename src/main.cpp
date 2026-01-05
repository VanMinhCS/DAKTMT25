#include <Arduino.h>
#include <Wire.h>
#include <DHT20.h>
#include <WiFi.h>
#include <HTTPClient.h>

// Cấu hình chân
#define SDA_PIN 11
#define SCL_PIN 12
#define SOIL_MOISTURE_PIN 1

// Thông tin WiFi
const char *ssid = "MikaSoCute!!!";
const char *password = "12345671";

// API Endpoint
const char* serverName = "http://10.92.151.212:5000/api/sensor"; 

DHT20 dht;

void scanWiFi() {
  Serial.println("Scanning for WiFi networks...");
  int n = WiFi.scanNetworks();
  Serial.println("Scan done");
  if (n == 0) {
      Serial.println("no networks found");
  } else {
      Serial.print(n);
      Serial.println(" networks found");
      for (int i = 0; i < n; ++i) {
          Serial.print(i + 1);
          Serial.print(": ");
          Serial.print(WiFi.SSID(i));
          Serial.print(" (");
          Serial.print(WiFi.RSSI(i));
          Serial.print(")");
          Serial.println((WiFi.encryptionType(i) == WIFI_AUTH_OPEN)?" ":"*");
          delay(10);
      }
  }
  Serial.println("");
}

void setup() {
  Serial.begin(115200);
  
  // Khởi tạo I2C
  Wire.begin(SDA_PIN, SCL_PIN);
  
  // Khởi tạo DHT20
  dht.begin();

  // Quét WiFi trước khi kết nối
  scanWiFi();
  
  // Kết nối WiFi
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  // Đọc dữ liệu từ DHT20
  dht.read();
  float temp = dht.getTemperature();
  float hum = dht.getHumidity();
  
  // Đọc dữ liệu từ cảm biến độ ẩm đất
  int soilMoistureValue = analogRead(SOIL_MOISTURE_PIN);
  // Chuyển đổi sang phần trăm (cần hiệu chỉnh thực tế tùy cảm biến)
  // Giả sử 0 là khô (0%) và 4095 là ướt (100%) hoặc ngược lại
  // Bạn cần đo giá trị khi khô và khi ướt để thay vào hàm map()
  int soilMoisturePercent = map(soilMoistureValue, 0, 4095, 0, 100); 

  // Kiểm tra dữ liệu hợp lệ
  // Lưu ý: DHT20 trả về 0 khi lỗi hoặc chưa đọc được, cần kiểm tra status nếu thư viện hỗ trợ
  // Ở đây ta kiểm tra cơ bản
  
  Serial.printf("Temp: %.2f, Hum: %.2f, Soil: %d (Raw), %d (%%)\n", temp, hum, soilMoistureValue, soilMoisturePercent);
  
  // Gửi dữ liệu qua API
  if(WiFi.status() == WL_CONNECTED){
    HTTPClient http;
    
    http.begin(serverName);
    http.addHeader("Content-Type", "application/json");
    
    // Tạo payload JSON
    String httpRequestData = "[";
    httpRequestData += "{\"type\":\"temperature\",\"value\":" + String(temp) + ",\"unit\":\"C\"},";
    httpRequestData += "{\"type\":\"humidity\",\"value\":" + String(hum) + ",\"unit\":\"%\"},";
    httpRequestData += "{\"type\":\"soil_moisture\",\"value\":" + String(soilMoisturePercent) + ",\"unit\":\"%\"}";
    httpRequestData += "]";
    
    int httpResponseCode = http.POST(httpRequestData);
    
    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    }
    else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
    
    http.end();
  }
  else {
    Serial.println("WiFi Disconnected");
  }
  
  delay(5000); // Gửi mỗi 5 giây
}
