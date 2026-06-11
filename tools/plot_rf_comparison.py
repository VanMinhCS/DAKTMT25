import sys
import os
import random
import pickle
import numpy as np
import matplotlib.pyplot as plt

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def evaluate_and_plot():
    sys.stdout.reconfigure(encoding='utf-8')
    model_path = os.path.join("models", "fusion", "rf_fusion_model.pkl")
    
    with open(model_path, "rb") as f:
        data = pickle.load(f)
    
    rf_model = data["model"]
    YOLO_MAP = data["yolo_map"]
    LSTM_MAP = data["lstm_map"]

    num_samples = 10000
    X_test = []

    for _ in range(num_samples):
        yolo_val = YOLO_MAP["Warning"]
        # Kịch bản nhiễu nặng: Camera dính bùn, YOLO tự tin ảo từ 80% đến 99%
        yolo_conf = random.uniform(0.80, 0.99) 
        lstm_val = LSTM_MAP["healthy"]
        # Nhưng đất thì cực kỳ sạch sẽ và tốt (85% đến 99%)
        lstm_conf = random.uniform(0.85, 0.99)
        X_test.append([yolo_val, yolo_conf, lstm_val, lstm_conf])

    X_test = np.array(X_test)

    # 1. Chỉ dùng YOLO (Hú còi vô tội vạ)
    yolo_alarms = num_samples

    # 2. YOLO + LSTM (Lệnh IF-ELSE cứng)
    # Lập trình viên hardcode: "Nếu YOLO tự tin >= 85% thì chắc chắn có bệnh, hú còi luôn!"
    ifelse_alarms = 0
    for x in X_test:
        yolo_conf = x[1]
        if yolo_conf >= 0.85:
            ifelse_alarms += 1

    # 3. RF Fusion
    rf_preds = rf_model.predict(X_test)
    # rf_preds >= 3 nghĩa là mức WARNING (3) hoặc CRITICAL (4). 
    # Mức 1 (VERIFICATION) không được tính là báo động giả.
    rf_alarms = np.sum(rf_preds >= 3)

    # Plotting
    labels = ['Chỉ dùng YOLO', 'YOLO + LSTM\n(Lệnh IF-ELSE cứng)', 'Random Forest\nFusion']
    values = [yolo_alarms, ifelse_alarms, rf_alarms]
    colors = ['#ff4d4d', '#ffcc00', '#33cc33']

    plt.figure(figsize=(10, 6), facecolor='white')
    bars = plt.bar(labels, values, color=colors, width=0.6)
    
    plt.title('So sánh Số lượng Báo động giả (False Alarms)\ntrên 10,000 ca nhiễu vật lý từ Camera', fontsize=16, fontweight='bold', pad=20)
    plt.ylabel('Số lần phát cảnh báo sai (lần)', fontsize=12)
    plt.ylim(0, 11000)
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    
    # Add value labels on top of bars
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2., height + 150,
                 f'{int(height)}', ha='center', va='bottom', fontsize=12, fontweight='bold')

    plt.tight_layout()
    
    # Save to charts directory
    artifact_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "charts", "false_alarm_chart.png")
    plt.savefig(artifact_path, dpi=300)
    print(f"Đã lưu biểu đồ tại: {artifact_path}")

if __name__ == "__main__":
    evaluate_and_plot()
