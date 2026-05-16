# 🌿 Plant Disease Detection — IoT Edge System

Hệ thống giám sát và phát hiện bệnh cây trồng thời gian thực, kết hợp **Computer Vision (YOLOv11)** và **Time-Series AI (LSTM)** trên nền tảng IoT Edge (Raspberry Pi / Yocto Linux).

## Kiến trúc hệ thống

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│   Camera    │────▶│  AI Engine   │────▶│  RTSP Streamer   │
│  (OpenCV)   │     │ (YOLO ONNX)  │     │  (FFmpeg)        │
└─────────────┘     └──────┬───────┘     └─────────────────┘
                           │
┌─────────────┐     ┌──────▼───────┐     ┌─────────────────┐
│  ESP32      │────▶│  Report      │────▶│  IoT Client      │
│  Sensors    │     │  Builder     │     │  (MQTT/ThingsBoard)│
└─────────────┘     └──────┬───────┘     └─────────────────┘
       │                   │
       ▼            ┌──────▼───────┐     ┌─────────────────┐
┌─────────────┐     │  Alert       │     │  Cloud Uploader   │
│  LSTM       │────▶│  Engine      │────▶│  (Firebase REST)  │
│  Predictor  │     │  (Fusion)    │     └─────────────────┘
└─────────────┘     └──────────────┘
```

## Tính năng chính

- 🔍 **YOLO Detection**: Phát hiện 20 loại bệnh lá qua camera, sử dụng ONNX INT8 quantized
- 📊 **LSTM Prediction**: Dự đoán sức khỏe đất từ 7 thông số cảm biến (chuỗi 24h)
- ⚡ **Decision Fusion**: Kết hợp YOLO + LSTM tạo cảnh báo 5 cấp độ (NORMAL → CRITICAL)
- 📡 **IoT Integration**: Gửi telemetry qua MQTT đến ThingsBoard/CoreIoT
- ☁️ **Cloud Upload**: Upload dữ liệu bất thường lên Firebase (offline queue support)
- 📹 **RTSP Streaming**: Stream video realtime với overlay detection
- 🔄 **OTA Update**: Cập nhật firmware qua mạng từ ThingsBoard

## Cài đặt

### Trên máy phát triển (Windows/Linux)

```bash
# Clone repo
git clone https://github.com/<your-username>/plant-disease-detect.git
cd plant-disease-detect

# Tạo virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# hoặc: venv\Scripts\activate  # Windows

# Cài dependencies
pip install -r requirements.txt
```

### Trên Edge device (Raspberry Pi / Yocto)

```bash
pip install -r requirements-edge.txt
```

> **Lưu ý**: `requirements-edge.txt` dùng `tflite-runtime` thay vì `tensorflow` đầy đủ và `opencv-python-headless` thay vì `opencv-python`.

## Cấu hình

### 1. Config chung — `config.json`

Chứa các thông số kỹ thuật: model path, camera, inference size, LSTM window, feature flags...

### 2. Secrets — `.env`

Sao chép `.env.example` thành `.env` và điền giá trị thật:

```bash
cp .env.example .env
```

Bao gồm:
- `THINGSBOARD_HOST` / `THINGSBOARD_ACCESS_TOKEN` — kết nối MQTT
- `DEVICE_ID` / `PLANT_ID` — định danh thiết bị
- `FIREBASE_API_KEY` / `FIREBASE_PROJECT_ID` — upload cloud (tùy chọn)

## Chạy

```bash
python main.py
```

Feature flags trong `config.json` cho phép bật/tắt từng module:

```json
{
  "enable_camera": true,
  "enable_sensor": true,
  "enable_mqtt": true,
  "enable_streamer": true,
  "enable_lstm": true,
  "enable_cloud_upload": false
}
```

## Cấu trúc thư mục

```
plant-disease-detect/
├── main.py                      # Entry point — orchestrator
├── config.json                  # Cấu hình kỹ thuật
├── .env.example                 # Template secrets
├── requirements.txt             # Dependencies (dev)
├── requirements-edge.txt        # Dependencies (edge/Yocto)
├── src/
│   ├── ai/                      # AI Engine (YOLO ONNX + LSTM TFLite)
│   ├── core/                    # Config, Logger, Utils
│   ├── hardware/                # Camera, Sensor Server
│   ├── network/                 # MQTT IoT Client, RTSP Streamer
│   └── services/                # AlertEngine, ReportBuilder, CloudUploader, OTA
├── models/
│   ├── yolo/                    # YOLO ONNX model (INT8)
│   └── lstm/                    # LSTM TFLite model + scaler + encoder
├── tests/                       # Unit tests (pytest)
├── tools/                       # Scripts tiện ích (test, simulate, convert)
├── collab/                      # Colab notebooks (training)
└── data/                        # Dataset info (CSV không commit)
```

## Models

Xem chi tiết tại [models/README.md](models/README.md).

| Model | File | Size | Mục đích |
|---|---|---|---|
| YOLOv11n | `plant_disease_int8.onnx` | 2.9 MB | Phát hiện bệnh lá (20 class) |
| LSTM | `tomato_potato_lstm.tflite` | ~208 KB | Dự đoán sức khỏe đất (9 class) |

## Tests

```bash
python -m pytest tests/ -v
```

## License

*Thêm license phù hợp tại đây.*
