import os
import random
import pickle
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# ── 1. MAP ĐỊNH DẠNG SANG SỐ (ENCODING) ──
# Mô hình Random Forest cần dữ liệu dạng số.
YOLO_MAP = {
    "No_Detection": 0,
    "Healthy": 1,
    "Checking": 2,
    "Warning": 3
}

LSTM_MAP = {
    "unknown": 0,
    "healthy": 1,
    "nutrient_deficient": 2,
    "disease_risk": 3
}

# Levels đầu ra
# 0: NORMAL, 1: VERIFICATION, 2: PRE_WARNING, 3: WARNING, 4: CRITICAL
LEVEL_NAMES = ["NORMAL", "VERIFICATION", "PRE_WARNING", "WARNING", "CRITICAL"]

def generate_mock_data(num_samples=10000):
    """Sinh dữ liệu giả lập cân bằng cho Random Forest học (5 cấp độ chuẩn)."""
    X = []
    y = []
    
    for _ in range(num_samples):
        # Ép tỷ lệ các trường hợp để cân bằng Class
        rand_case = random.random()
        
        if rand_case < 0.2:
            # Ép case VERIFICATION (Mâu thuẫn gắt)
            yolo_str = "Warning"
            lstm_str = "healthy"
            yolo_conf = random.uniform(0.85, 0.99)
            lstm_conf = random.uniform(0.85, 0.99)
        elif rand_case < 0.4:
            # Ép case CRITICAL
            yolo_str = "Warning"
            lstm_str = "disease_risk"
            yolo_conf = random.uniform(0.50, 0.99)
            lstm_conf = random.uniform(0.50, 0.99)
        elif rand_case < 0.6:
            # Ép case WARNING (đất bình thường nhưng lá bệnh)
            yolo_str = "Warning"
            lstm_str = random.choice(["healthy", "unknown", "nutrient_deficient"])
            yolo_conf = random.uniform(0.75, 0.99)
            lstm_conf = random.uniform(0.3, 0.84) # Đất không quá tốt
        else:
            # Các case ngẫu nhiên khác
            yolo_str = random.choice(list(YOLO_MAP.keys()))
            lstm_str = random.choice(list(LSTM_MAP.keys()))
            yolo_conf = round(random.uniform(0.3, 0.99), 2)
            lstm_conf = round(random.uniform(0.3, 0.99), 2)
        
        yolo_val = YOLO_MAP[yolo_str]
        lstm_val = LSTM_MAP[lstm_str]
        
        # ── LOGIC CHUẨN: 5 CẤP ĐỘ ──
        if lstm_str == "healthy" and lstm_conf >= 0.85 and yolo_str == "Warning" and yolo_conf >= 0.85:
            level = 1 # VERIFICATION
        elif lstm_str == "disease_risk" and lstm_conf >= 0.50 and yolo_str == "Warning" and yolo_conf >= 0.50:
            level = 4 # CRITICAL
        elif yolo_str == "Warning" and yolo_conf >= 0.75:
            level = 3 # WARNING
        elif (lstm_str in ["disease_risk", "nutrient_deficient"] and lstm_conf >= 0.50) or \
             (yolo_str == "Warning" and 0.50 <= yolo_conf < 0.75):
            level = 2 # PRE_WARNING
        else:
            level = 0 # NORMAL
                
        X.append([yolo_val, yolo_conf, lstm_val, lstm_conf])
        y.append(level)
        
    return np.array(X), np.array(y)

def main():
    print("=== Khởi tạo Dataset Giả lập (Ưu tiên LSTM) ===")
    X_train, y_train = generate_mock_data(2500)
    X_test, y_test = generate_mock_data(500)
    
    print(f"Train size: {len(X_train)} samples")
    print(f"Test size: {len(X_test)} samples")
    
    print("\n=== Huấn luyện Random Forest (Meta-Learner) ===")
    # Dùng 100 cây quyết định, max_depth giới hạn để tránh quá phức tạp, tốc độ cao.
    clf = RandomForestClassifier(n_estimators=100, max_depth=6, random_state=42)
    clf.fit(X_train, y_train)
    
    # Đánh giá
    preds = clf.predict(X_test)
    acc = accuracy_score(y_test, preds)
    print(f"Accuracy trên tập test: {acc * 100:.2f}%")
    
    # In mức độ quan trọng của các Features
    feature_names = ["YOLO_Status", "YOLO_Confidence", "LSTM_Status", "LSTM_Confidence"]
    print("\nFeature Importances:")
    for name, imp in zip(feature_names, clf.feature_importances_):
        print(f" - {name}: {imp*100:.1f}%")
        
    # Lưu model
    save_dir = "models/fusion"
    os.makedirs(save_dir, exist_ok=True)
    model_path = os.path.join(save_dir, "rf_fusion_model.pkl")
    
    with open(model_path, "wb") as f:
        pickle.dump({
            "model": clf,
            "yolo_map": YOLO_MAP,
            "lstm_map": LSTM_MAP,
            "level_names": LEVEL_NAMES
        }, f)
        
    print(f"\n✅ Đã lưu Meta-Learner Model tại: {model_path}")

if __name__ == "__main__":
    main()
