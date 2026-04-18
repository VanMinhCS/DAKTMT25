# Models Directory

Thư mục chứa các file model AI của hệ thống.

## Cấu trúc

```
models/
├── yolo/
│   └── plant_disease_v4.pt     # YOLO model phát hiện bệnh lá (đang dùng)
└── lstm/
    ├── potato_health_lstm.h5   # LSTM model dự đoán sức khoẻ đất
    ├── potato_scaler.pkl       # MinMaxScaler cho LSTM input
    └── potato_encoder.pkl      # LabelEncoder cho LSTM output classes
```

## Ghi chú

- File `.pt` và `.h5` **không được commit lên Git** (đã thêm vào `.gitignore`).
- Lưu các version model trên Google Drive hoặc dùng **Git LFS** nếu cần versioning.
- Để thêm model version mới: đặt vào `yolo/`, cập nhật `model_path` trong `config.json`.

## Versions lịch sử (đã xóa khỏi repo, lưu trên Drive)

| File | Size | Ghi chú |
|------|------|---------|
| best.pt | 16MB | Checkpoint tốt nhất khi training |
| plant_disease_v1.pt | 22MB | Version đầu, YOLOv11-large |
| plant_disease_v2.pt | 5MB | Optimize nhỏ hơn |
| plant_disease_v3.pt | 5MB | Tinh chỉnh threshold |
| **plant_disease_v4.pt** | **5MB** | **Đang dùng — accuracy tốt nhất** |
