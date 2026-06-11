"""
So sánh 3 phương pháp dự đoán tình trạng đất:
  M1: Rule-based (IF-ELSE ngưỡng cứng)
  M2: Random Forest (ML truyền thống, 1 điểm dữ liệu)
  M3: LSTM (mô hình của đồ án, chuỗi 24 timestep)

Chạy: venv\\Scripts\\python.exe tools\\test_lstm_baseline_comparison.py
"""
import sys, os, pickle, random
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler

sys.stdout.reconfigure(encoding="utf-8")

# ── LOAD SCALER + ENCODER ────────────────────────────────────────────────────
SCALER_PATH  = "models/lstm/tomato_potato_lstm_scaler.pkl"
ENCODER_PATH = "models/lstm/tomato_potato_lstm_encoder.pkl"

import warnings
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    scaler  = pickle.load(open(SCALER_PATH,  "rb"))
    encoder = pickle.load(open(ENCODER_PATH, "rb"))

CLASSES = list(encoder.classes_)
# Gộp về 3 nhóm lớn để đánh giá (tránh 9 class quá chi tiết với baseline đơn giản)
DISEASE_RISK   = {"Bacterial_Spot_Risk","Early_Blight_Risk","Late_Blight_Risk","Leaf_Mold_Risk"}
NUTRIENT_DEF   = {"Fe_Deficient","K_Deficient","N_Deficient","P_Deficient"}
HEALTHY_SET    = {"Healthy"}

def group(label):
    if label in DISEASE_RISK:   return "disease_risk"
    if label in NUTRIENT_DEF:   return "nutrient_deficient"
    return "healthy"

# ── SINH DỮ LIỆU TEST CÓ GROUND TRUTH ───────────────────────────────────────
# Nguồn: Ngưỡng nông học thực tế từ các nghiên cứu cây Cà chua và Khoai tây
# Features: Soil_Moisture, Soil_Temp, EC, pH, N, P, K
random.seed(42)
np.random.seed(42)

def make_healthy(n=24):
    """Đất khỏe: pH, EC, dinh dưỡng, ẩm độ đều trong ngưỡng lý tưởng."""
    return np.column_stack([
        np.random.uniform(60, 75, n),   # Moisture (%)
        np.random.uniform(20, 26, n),   # Temp (°C)
        np.random.uniform(1400,1800,n), # EC (µS/cm)
        np.random.uniform(6.0, 6.8, n), # pH
        np.random.uniform(120, 150, n), # N (mg/kg)
        np.random.uniform(45,  65,  n), # P (mg/kg)
        np.random.uniform(200, 250, n), # K (mg/kg)
    ])

def make_disease_risk(n=24):
    """
    Điều kiện nguy cơ bệnh: Ẩm độ cao liên tục + nhiệt độ ấm
    → môi trường lý tưởng cho nấm bệnh (Early/Late Blight, Leaf Mold).
    Dữ liệu chuỗi thời gian: ẩm độ tăng dần theo thời gian.
    """
    moisture = np.linspace(70, 90, n) + np.random.uniform(-3, 3, n)  # Tăng dần
    return np.column_stack([
        moisture,
        np.random.uniform(24, 30, n),   # Nhiệt độ ấm
        np.random.uniform(1800,2200,n), # EC cao (muối tích lũy)
        np.random.uniform(5.2, 5.8, n), # pH thấp (chua)
        np.random.uniform(90, 120, n),  # N hơi thấp
        np.random.uniform(35, 50, n),   # P hơi thấp
        np.random.uniform(150,200, n),  # K hơi thấp
    ])

def make_nutrient_deficient(n=24):
    """
    Thiếu dinh dưỡng: Giá trị N, P, K đều thấp hơn ngưỡng.
    Đặc trưng: Dữ liệu ổn định theo thời gian (không có xu hướng tăng).
    """
    return np.column_stack([
        np.random.uniform(45, 65, n),   # Moisture thấp (đất khô)
        np.random.uniform(18, 24, n),
        np.random.uniform(900,1200, n), # EC thấp (thiếu khoáng)
        np.random.uniform(5.5, 6.2, n),
        np.random.uniform(40, 80, n),   # N thấp (< 100 là thiếu)
        np.random.uniform(15, 35, n),   # P thấp (< 40 là thiếu)
        np.random.uniform(80, 140, n),  # K thấp (< 150 là thiếu)
    ])

# Sinh 300 mẫu test: 100 mỗi nhóm
N_EACH = 100
X_sequences, y_true_groups = [], []

for _ in range(N_EACH):
    X_sequences.append(make_healthy())
    y_true_groups.append("healthy")
for _ in range(N_EACH):
    X_sequences.append(make_disease_risk())
    y_true_groups.append("disease_risk")
for _ in range(N_EACH):
    X_sequences.append(make_nutrient_deficient())
    y_true_groups.append("nutrient_deficient")

X_sequences = np.array(X_sequences)  # (300, 24, 7)
y_true = np.array(y_true_groups)

print(f"Tập test: {len(y_true)} mẫu — {N_EACH} healthy, {N_EACH} disease_risk, {N_EACH} nutrient_deficient\n")

# ── M1: RULE-BASED (IF-ELSE NGƯỠNG CỨNG) ────────────────────────────────────
def rule_based_predict(seq):
    """Dùng giá trị TRUNG BÌNH của chuỗi, sau đó áp ngưỡng cứng."""
    m = seq.mean(axis=0)  # Trung bình 24 timestep
    moisture, temp, ec, ph, n, p, k = m

    if moisture > 78 and ph < 6.0:
        return "disease_risk"
    if n < 90 or p < 38 or k < 145:
        return "nutrient_deficient"
    return "healthy"

y_rule = np.array([rule_based_predict(seq) for seq in X_sequences])
acc_rule = np.mean(y_rule == y_true)

# ── M2: RANDOM FOREST (1 ĐIỂM DỮ LIỆU, KHÔNG CÓ TIME-WINDOW) ───────────────
# Lấy điểm CUỐI CÙNG của mỗi chuỗi làm đầu vào (giả sử sensor chỉ đọc 1 lần)
X_single = X_sequences[:, -1, :]  # (300, 7) — chỉ lấy timestep cuối
rf_clf = RandomForestClassifier(n_estimators=100, random_state=42)
rf_clf.fit(X_single, y_true)  # Train và test trên cùng tập → upper bound cho RF
from sklearn.model_selection import cross_val_score
rf_cv_scores = cross_val_score(rf_clf, X_single, y_true, cv=5, scoring="accuracy")
acc_rf = rf_cv_scores.mean()

# ── M3: LSTM TFLITE (CHUỖI 24 TIMESTEP) ─────────────────────────────────────
try:
    import tflite_runtime.interpreter as tflite
    Interpreter = tflite.Interpreter
except ImportError:
    import tensorflow as tf
    Interpreter = tf.lite.Interpreter

TFLITE_PATH = "models/lstm/tomato_potato_lstm.tflite"
interpreter = Interpreter(model_path=TFLITE_PATH)
interpreter.allocate_tensors()
inp_det  = interpreter.get_input_details()[0]
out_det  = interpreter.get_output_details()[0]

def lstm_predict(seq):
    """Chuẩn hóa rồi đưa vào LSTM TFLite."""
    seq_scaled = scaler.transform(seq)  # (24, 7)
    inp = seq_scaled.reshape(1, 24, 7).astype(np.float32)
    interpreter.set_tensor(inp_det["index"], inp)
    interpreter.invoke()
    logits = interpreter.get_tensor(out_det["index"])[0]
    pred_idx = np.argmax(logits)
    label = CLASSES[pred_idx]
    return group(label)

print("Đang chạy LSTM TFLite trên 300 mẫu...")
y_lstm = np.array([lstm_predict(seq) for seq in X_sequences])
acc_lstm = np.mean(y_lstm == y_true)

# ── KẾT QUẢ ─────────────────────────────────────────────────────────────────
print(f"\n{'='*55}")
print(f"  KẾT QUẢ SO SÁNH 3 PHƯƠNG PHÁP (300 mẫu test)")
print(f"{'='*55}")
print(f"  M1 Rule-based (IF-ELSE)          : {acc_rule*100:.1f}%")
print(f"  M2 Random Forest (1 điểm)        : {acc_rf*100:.1f}%  (5-fold CV)")
print(f"  M3 LSTM TFLite  (24 timesteps)   : {acc_lstm*100:.1f}%")
print(f"{'='*55}")

# ── VẼ BIỂU ĐỒ CỘT ──────────────────────────────────────────────────────────
labels  = ["M1\nRule-based\n(IF-ELSE)", "M2\nRandom Forest\n(1 điểm đo)", "M3\nLSTM TFLite\n(Chuỗi 24 giờ)"]
values  = [acc_rule*100, acc_rf*100, acc_lstm*100]
colors  = ["#aaaaaa", "#5b9bd5", "#2e7d32"]

fig, ax = plt.subplots(figsize=(9, 6), facecolor="white")
bars = ax.bar(labels, values, color=colors, width=0.5, zorder=3)

# Nhãn số trên cột
for bar, val in zip(bars, values):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.8,
            f"{val:.1f}%", ha="center", va="bottom", fontsize=13, fontweight="bold")

ax.set_ylim(0, 110)
ax.set_ylabel("Độ chính xác (%)", fontsize=12)
ax.set_title("So sánh độ chính xác phân loại tình trạng đất\nRule-based vs Random Forest vs LSTM",
             fontsize=13, fontweight="bold", pad=15)
ax.grid(axis="y", linestyle="--", alpha=0.5, zorder=0)
ax.set_axisbelow(True)
ax.spines[["top","right"]].set_visible(False)

# Chú thích mũi tên cải thiện
ax.annotate("", xy=(2, acc_lstm*100 - 1), xytext=(0, acc_rule*100 + 1),
            arrowprops=dict(arrowstyle="->", color="#c62828", lw=1.5))
ax.text(1.0, (acc_rule + acc_lstm)/2 * 100,
        f"+{(acc_lstm - acc_rule)*100:.1f}%", color="#c62828",
        fontsize=11, fontweight="bold", ha="center")

plt.tight_layout()
OUT_PATH = r"C:\Users\Admin\.gemini\antigravity\brain\353ba16c-0e6c-44f7-8191-47b1ffdcb7e1\lstm_baseline_comparison.png"
plt.savefig(OUT_PATH, dpi=200, bbox_inches="tight")
print(f"\nĐã lưu biểu đồ: {OUT_PATH}")
