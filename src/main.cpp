#include <Arduino.h>
#include <HardwareSerial.h>

// Định nghĩa chân RX, TX mới
#define RS485RX 6
#define RS485TX 7

HardwareSerial mySerial(2);

#define SENSOR_FRAME_SIZE 19  
#define SENSOR_TIMEOUT 1000   

byte requestFrame[8] = {0x01, 0x03, 0x00, 0x00, 0x00, 0x07, 0x04, 0x08};
byte responseFrame[19];

uint32_t lastRequestTime = 0;

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

void printDataToSerial() {
  // Ghép 2 byte thành 1 giá trị số nguyên (Sử dụng int16_t cho nhiệt độ để bù số âm)
  int16_t rawMoisture = (responseFrame[3] << 8)  | responseFrame[4];
  int16_t rawTemp     = (responseFrame[5] << 8)  | responseFrame[6];
  uint16_t rawEC      = (responseFrame[7] << 8)  | responseFrame[8];
  uint16_t rawPH      = (responseFrame[9] << 8)  | responseFrame[10];
  uint16_t rawN       = (responseFrame[11] << 8) | responseFrame[12];
  uint16_t rawP       = (responseFrame[13] << 8) | responseFrame[14];
  uint16_t rawK       = (responseFrame[15] << 8) | responseFrame[16];

  Serial.println("\n========== KET QUA DO ==========");
  Serial.printf("1. Do am (Moisture) : %.1f %%\n", (float)rawMoisture / 10.0);
  Serial.printf("2. Nhiet do (Temp)  : %.1f °C\n", (float)rawTemp / 10.0);
  Serial.printf("3. Do dan (EC)      : %d us/cm\n", rawEC);
  Serial.printf("4. Do pH            : %.1f\n", (float)rawPH / 10.0);
  Serial.printf("5. Nito (N)         : %d mg/kg\n", rawN);
  Serial.printf("6. Photpho (P)      : %d mg/kg\n", rawP);
  Serial.printf("7. Kali (K)         : %d mg/kg\n", rawK);
  Serial.println("================================\n");
}

void setup() {
  Serial.begin(115200);
  while (!Serial) {};
  
  mySerial.begin(4800, SERIAL_8N1, RS485RX, RS485TX);
  
  Serial.println("\n--- HE THONG DOC CAM BIEN QUA RS485 ---");
  delay(1000);
  lastRequestTime = millis();
}

void loop() {
  if (millis() - lastRequestTime > 3000) {
    Serial.print("<TX> Goi lenh: ");
    for (int i = 0; i < 8; i++) {
      Serial.printf("%02X ", requestFrame[i]);
    }
    Serial.println();
    
    while(mySerial.available()) mySerial.read(); 
    
    mySerial.write(requestFrame, 8);
    
    unsigned long resptime = millis();
    while ((mySerial.available() < SENSOR_FRAME_SIZE) && ((millis() - resptime) < SENSOR_TIMEOUT)) {
      delay(1);
    }

    if (mySerial.available() >= SENSOR_FRAME_SIZE) {
      
      Serial.print("<RX> Nhan ve:  ");
      for (int n = 0; n < SENSOR_FRAME_SIZE; n++) {
        responseFrame[n] = mySerial.read();
        Serial.printf("%02X ", responseFrame[n]);
      }
      Serial.println();

      if (responseFrame[0] == 0x01 && responseFrame[1] == 0x03 && responseFrame[2] == 0x0E) {
        
        uint16_t receivedCRC = (responseFrame[18] << 8) | responseFrame[17];
        if (receivedCRC == calculateCRC(responseFrame, 17)) {
          printDataToSerial();
        } else {
          Serial.println(">>> LOI: Sai ma CRC (Tin hieu bi nhieu)!");
        }
        
      } else {
         Serial.println(">>> LOI: Header ban tin khong hop le!");
      }
    } else {
      Serial.println(">>> LOI: Khong nhan duoc phan hoi tu cam bien (Timeout)!");
    }

    lastRequestTime = millis();
  }
}