"""
Test toàn diện cho LSTMPredictor.
Chạy từ thư mục gốc dự án:
    .\\venv\\Scripts\\python.exe tools\\test_lstm_predictor.py
"""

import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import numpy as np
from src.ai.lstm_predictor import LSTMPredictor

PASS = "\033[92m[PASS]\033[0m"
FAIL = "\033[91m[FAIL]\033[0m"

results = []

def check(name, condition, detail=""):
    status = PASS if condition else FAIL
    print(f"  {status} {name}" + (f" — {detail}" if detail else ""))
    results.append((name, condition))

print("\n═══════════════════════════════════════════")
print("  TEST 1 · Khởi tạo và load model (Fallback/TFLite)")
print("═══════════════════════════════════════════")

config = {
    "lstm_model_path": "models/lstm/tomato_potato_lstm.tflite",
    "lstm_scaler_path": "models/lstm/tomato_potato_lstm_scaler.pkl",
    "lstm_encoder_path": "models/lstm/tomato_potato_lstm_encoder.pkl",
    "lstm_window_size": 24
}

predictor = LSTMPredictor(config)

check("Scaler loaded", predictor.scaler is not None)
check("Encoder loaded", predictor.encoder is not None)
check("Classes loaded", len(predictor.classes) > 0, f"Got {len(predictor.classes)} classes")
check("Backend is active (tflite or keras)", predictor.backend in ["tflite", "keras"], f"Backend: {predictor.backend}")
check("Model/Interpreter loaded", predictor.interpreter is not None or predictor.model is not None)

print("\n═══════════════════════════════════════════")
print("  TEST 2 · Cập nhật dữ liệu (Update Buffer)")
print("═══════════════════════════════════════════")

predictor.reset_buffer()
check("Buffer empty initially", len(predictor.buffer) == 0)

# Định dạng 1: List of dicts (giống MQTT)
mqtt_data = [
    {"type": "soil_moisture", "value": 65},
    {"type": "temp", "value": 22.5},
    {"type": "ec", "value": 1500}
]
predictor.update(mqtt_data)
check("Update list of dicts", len(predictor.buffer) == 1)

# Định dạng 2: Dict trực tiếp
direct_data = {
    "Soil_Moisture": 66,
    "Soil_Temperature": 23,
    "EC": 1510,
    "pH": 6.5,
    "Nitrogen": 120,
    "Phosphorus": 50,
    "Potassium": 200
}
predictor.update(direct_data)
check("Update direct dict", len(predictor.buffer) == 2)

print("\n═══════════════════════════════════════════")
print("  TEST 3 · Dự đoán khi chưa đủ dữ liệu (Window Size)")
print("═══════════════════════════════════════════")

label, conf = predictor.predict()
check("Dự đoán khi chưa đủ data trả về None", label is None and conf is None)
check("is_ready == False", predictor.is_ready is False)

print("\n═══════════════════════════════════════════")
print("  TEST 4 · Dự đoán khi đủ dữ liệu (Inference)")
print("═══════════════════════════════════════════")

# Bơm thêm dữ liệu giả cho đủ window_size (24)
for _ in range(22):
    predictor.update(direct_data)

check("Buffer full", len(predictor.buffer) == predictor.window_size)
check("is_ready == True", predictor.is_ready is True)

label, conf = predictor.predict()
check("Dự đoán thành công (không crash)", label is not None)
check("Label nằm trong classes", label in predictor.classes, f"Predicted: {label}")
check("Confidence hợp lệ (0.0 -> 1.0)", 0.0 <= conf <= 1.0, f"Conf: {conf:.4f}")

print("\n═══════════════════════════════════════════")
print("  TEST 5 · Reset Buffer")
print("═══════════════════════════════════════════")

predictor.reset_buffer()
check("Buffer trống sau khi reset", len(predictor.buffer) == 0)
check("is_ready == False sau khi reset", predictor.is_ready is False)

print("\n═══════════════════════════════════════════")
total = len(results)
passed = sum(1 for _, ok in results if ok)
failed = total - passed

print(f"  KẾT QUẢ: {passed}/{total} PASS  |  {failed} FAIL")
print("═══════════════════════════════════════════\n")

if failed:
    sys.exit(1)
