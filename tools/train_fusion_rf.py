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

def generate_mock_data(num_samples=1000):
    """Sinh dữ liệu giả lập cho Random Forest học (Ưu tiên LSTM)."""
    X = []
    y = []
    
    for _ in range(num_samples):
        yolo_str = random.choice(list(YOLO_MAP.keys()))
        lstm_str = random.choice(list(LSTM_MAP.keys()))
        
        yolo_conf = round(random.uniform(0.3, 0.99), 2)
        lstm_conf = round(random.uniform(0.3, 0.99), 2)
        
        yolo_val = YOLO_MAP[yolo_str]
        lstm_val = LSTM_MAP[lstm_str]
        
        # ── LOGIC CHUYÊN GIA (THIÊN VỊ LSTM) ──
        level = 0 # NORMAL
        
        lstm_bad = lstm_str in ["disease_risk", "nutrient_deficient"]
        
        if lstm_bad and lstm_conf >= 0.7:
            # LSTM rất chắc chắn là môi trường có rủi ro cao
            if yolo_str == "Warning" and yolo_conf >= 0.6:
                level = 4 # CRITICAL
            else:
                level = 3 # WARNING (Bỏ qua YOLO, tin LSTM)
                
        elif lstm_bad and lstm_conf < 0.7:
            # LSTM nghi ngờ môi trường có vấn đề nhưng chưa chắc chắn
            if yolo_str == "Warning" and yolo_conf >= 0.7:
                level = 3 # WARNING (YOLO gánh)
            elif yolo_str in ["Checking", "Warning"]:
                level = 2 # PRE_WARNING
            else:
                level = 2 # PRE_WARNING (Vì LSTM cảnh báo)

        elif lstm_str == "healthy" and lstm_conf >= 0.7:
            # LSTM cực kỳ chắc chắn là môi trường rất tốt
            if yolo_str == "Warning":
                if yolo_conf >= 0.8:
                    level = 1 # VERIFICATION (YOLO quá tự tin, cần kiểm tra lại, nhưng TUYỆT ĐỐI không Critical)
                else:
                    level = 0 # NORMAL (Bỏ qua YOLO vì conf thấp)
            else:
                level = 0 # NORMAL

        else:
            # Các trường hợp LSTM healthy (nhưng conf thấp) hoặc unknown
            if yolo_str == "Warning":
                level = 3 if yolo_conf >= 0.6 else 1 # WARNING hoặc VERIFICATION
            elif yolo_str == "Checking":
                level = 2 if yolo_conf >= 0.7 else 0 # PRE_WARNING
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
