import sys
import os
import random
import pickle
import numpy as np

# Đảm bảo đường dẫn import đúng
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def evaluate_false_alarms():
    sys.stdout.reconfigure(encoding='utf-8')
    model_path = os.path.join("models", "fusion", "rf_fusion_model.pkl")
    
    if not os.path.exists(model_path):
        print("Không tìm thấy model Random Forest. Hãy chạy tools/train_fusion_rf.py trước.")
        return

    with open(model_path, "rb") as f:
        data = pickle.load(f)
    
    rf_model = data["model"]
    YOLO_MAP = data["yolo_map"]
    LSTM_MAP = data["lstm_map"]

    num_samples = 10000
    X_test = []

    # Giả lập 10,000 ca "Báo động giả từ Camera": 
    # Tức là Camera nhìn thấy vết mờ, xước, bùn đất và YOLO dự đoán nhầm là "Warning" (bệnh)
    # Nhưng thực tế đất đang cực kỳ "Healthy" (LSTM nhận diện đúng).
    for _ in range(num_samples):
        yolo_val = YOLO_MAP["Warning"]
        # YOLO khá tự tin về vết bệnh giả (từ 0.6 đến 0.95)
        yolo_conf = random.uniform(0.6, 0.95) 
        
        lstm_val = LSTM_MAP["healthy"]
        # LSTM tự tin môi trường bình thường
        lstm_conf = random.uniform(0.7, 0.99)
        
        X_test.append([yolo_val, yolo_conf, lstm_val, lstm_conf])

    X_test = np.array(X_test)

    # 1. BASELINE (Chỉ dùng YOLO)
    # Nếu YOLO báo Warning với Confidence >= 0.6, hệ thống cũ sẽ hú còi (Báo động giả)
    yolo_alarms = np.sum(X_test[:, 1] >= 0.6)

    # 2. FUSION (Dùng Random Forest)
    # RF nhận cả 4 thông số (YOLO status, conf, LSTM status, conf)
    rf_preds = rf_model.predict(X_test)
    
    # Cảnh báo thực sự là khi RF ra quyết định >= 3 (WARNING hoặc CRITICAL)
    rf_alarms = np.sum(rf_preds >= 3)
    rf_verification = np.sum(rf_preds == 1) # Chỉ yêu cầu kiểm tra, không báo động
    rf_normal = np.sum(rf_preds == 0)       # Ép về Normal

    print("=== KẾT QUẢ ĐÁNH GIÁ TỶ LỆ GIẢM BÁO ĐỘNG GIẢ (FALSE POSITIVE REDUCTION) ===")
    print(f"Tập dữ liệu Test: {num_samples} trường hợp Camera nhìn nhầm (Nhiễu vật lý/Bóng râm).")
    print("-" * 60)
    print(f"❌ NẾU CHỈ DÙNG CAMERA (YOLO):")
    print(f"   - Số lần hú còi sai (False Alarms): {yolo_alarms} lần")
    print(f"   - Tỷ lệ báo động sai: {yolo_alarms / num_samples * 100:.1f}%")
    print("-" * 60)
    print(f"✅ KHI DÙNG RANDOM FOREST FUSION (YOLO + LSTM):")
    print(f"   - Số lần hú còi sai: {rf_alarms} lần")
    print(f"   - Số lần chỉ gửi tin nhắn 'Cần xác minh lại': {rf_verification} lần")
    print(f"   - Số lần tự động triệt tiêu cảnh báo (Normal): {rf_normal} lần")
    print(f"   - Tỷ lệ báo động sai (đã lọc): {rf_alarms / num_samples * 100:.1f}%")
    print("=" * 60)
    
    reduction_rate = (yolo_alarms - rf_alarms) / yolo_alarms * 100
    print(f"🔥 KẾT LUẬN: Random Forest giúp giảm {reduction_rate:.1f}% tỷ lệ báo động giả!")

if __name__ == "__main__":
    evaluate_false_alarms()
