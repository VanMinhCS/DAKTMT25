# Models Directory

Thư mục chứa các file model AI của hệ thống.

## Cấu trúc

```
models/
├── yolo/
│   └── plant_disease_int8.onnx        # YOLOv11 INT8 quantized (2.9 MB)
└── lstm/
    ├── tomato_potato_lstm.tflite       # LSTM TFLite (Dynamic Range Quantization, ~208 KB)
    ├── tomato_potato_lstm_scaler.pkl   # StandardScaler cho 7 features đầu vào
    ├── tomato_potato_lstm_encoder.pkl  # LabelEncoder cho 9 class đầu ra
    └── tomato_potato_lstm_metadata.json # Metadata: accuracy, classes, window_size
```

## YOLO — Phát hiện bệnh lá (Image Detection)

| Thông số | Giá trị |
|---|---|
| Model | YOLOv11n (Nano) |
| Format | ONNX INT8 Quantized |
| Size | 2.9 MB |
| Input | 640×640 RGB |
| Classes | 20 (xem metadata trong ONNX hoặc `config.json`) |
| Inference | `onnxruntime` CPUExecutionProvider |

## LSTM — Dự đoán sức khỏe đất (Time-Series Classification)

| Thông số | Giá trị |
|---|---|
| Architecture | LSTM 128→64 + Dense 128→64→9 |
| Format | TFLite (Dynamic Range Quantization) |
| Size | ~208 KB |
| Input | Sliding window 24 steps × 7 features |
| Features | Soil_Moisture, Soil_Temperature, EC, pH, N, P, K |
| Classes (9) | Healthy, N/P/K/Fe_Deficient, Late/Early_Blight_Risk, Bacterial_Spot_Risk, Leaf_Mold_Risk |
| Inference | `tflite-runtime` (edge) hoặc `tensorflow.lite` (dev) |

## Ghi chú

- File `.pt` và `.keras` **không được commit lên Git** (đã thêm vào `.gitignore`).
- Lưu các version model source trên Google Drive hoặc dùng **Git LFS** nếu cần versioning.
- Để thêm model version mới: đặt vào thư mục tương ứng, cập nhật `model_path` trong `config.json`.

## Versions lịch sử (lưu trên Drive)

| File | Size | Ghi chú |
|---|---|---|
| plant_disease_v1.pt | 22 MB | Version đầu, YOLOv11-large |
| plant_disease_v2.pt | 5 MB | Optimize nhỏ hơn |
| plant_disease_v3.pt | 5 MB | Tinh chỉnh threshold |
| plant_disease_v4.pt | 5 MB | Accuracy tốt nhất |
| plant_disease_v4.onnx | 10.1 MB | ONNX FP32 export từ v4 |
| **plant_disease_int8.onnx** | **2.9 MB** | **Đang dùng — INT8 quantized** |
