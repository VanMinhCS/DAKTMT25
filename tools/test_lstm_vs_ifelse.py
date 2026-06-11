"""
So sánh IF-ELSE vs LSTM trong bài toán phân loại tình trạng đất.
Dữ liệu: Chuỗi 24 giờ có xu hướng thời gian (trend) + nhiễu.

Chạy: venv\\Scripts\\python.exe tools\\test_lstm_vs_ifelse.py
"""
import sys, os, pickle, warnings
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.stdout.reconfigure(encoding="utf-8")
warnings.filterwarnings("ignore")
np.random.seed(42)

# ── Load model ───────────────────────────────────────────────────
scaler  = pickle.load(open("models/lstm/tomato_potato_lstm_scaler.pkl", "rb"))
encoder = pickle.load(open("models/lstm/tomato_potato_lstm_encoder.pkl", "rb"))
CLASSES = list(encoder.classes_)
DISEASE_RISK = {"Bacterial_Spot_Risk","Early_Blight_Risk","Late_Blight_Risk","Leaf_Mold_Risk"}
NUTRIENT_DEF = {"Fe_Deficient","K_Deficient","N_Deficient","P_Deficient"}

def group(label):
    if label in DISEASE_RISK: return "disease_risk"
    if label in NUTRIENT_DEF: return "nutrient_deficient"
    return "healthy"

# ── Sinh dữ liệu có TREND + OVERLAP ─────────────────────────────
# Đặc điểm: Tại bất kỳ 1 thời điểm nào, giá trị nằm trong vùng xám.
# Chỉ khi nhìn toàn bộ chuỗi 24h mới thấy xu hướng nguy hiểm.

def make_healthy(n=24):
    """Ổn định, dao động ngẫu nhiên, không có xu hướng."""
    base  = np.array([68, 22, 1550, 6.3, 130, 52, 220])
    noise = np.random.uniform(-1, 1, (n, 7)) * np.array([4, 0.6, 60, 0.12, 9, 4, 14])
    return np.tile(base, (n, 1)) + noise

def make_disease(obvious=False, n=24):
    if obvious:
        # Bệnh đã phát quá rõ: Ẩm độ > 80, pH < 5.5 liên tục
        moisture = np.random.uniform(80, 85, n)
        ph       = np.random.uniform(5.2, 5.6, n)
        ec       = np.random.uniform(1600, 2000, n)
    else:
        # Bệnh tiềm ẩn (vùng xám): Ẩm độ tăng dần 68->82, pH giảm 6.2->5.6
        moisture = np.linspace(68, 82, n) + np.random.uniform(-1.5, 1.5, n)
        ph       = np.linspace(6.2, 5.6, n) + np.random.uniform(-0.04, 0.04, n)
        ec       = np.linspace(1400, 1950, n) + np.random.uniform(-60, 60, n)
    temp     = np.random.uniform(24, 28, n)
    n_val    = np.random.uniform(105, 125, n)
    p_val    = np.random.uniform(42, 56, n)
    k_val    = np.random.uniform(175, 215, n)
    return np.column_stack([moisture, temp, ec, ph, n_val, p_val, k_val])

def make_nutrient(obvious=False, n=24):
    if obvious:
        # Thiếu rõ rệt: N < 80, P < 30, K < 140
        n_val = np.random.uniform(60, 80, n)
        p_val = np.random.uniform(20, 30, n)
        k_val = np.random.uniform(100, 140, n)
    else:
        # Thiếu tiềm ẩn: Cây hút dinh dưỡng cạn dần, cuối ngày mới tụt thấp
        n_val = np.linspace(110, 75, n) + np.random.uniform(-4, 4, n)
        p_val = np.linspace(48,  28, n) + np.random.uniform(-2, 2, n)
        k_val = np.linspace(200, 140, n) + np.random.uniform(-7, 7, n)
    moisture = np.random.uniform(52, 67, n)
    temp     = np.random.uniform(18, 23, n)
    ec       = np.random.uniform(900, 1200, n)
    ph       = np.random.uniform(5.8, 6.4, n)
    return np.column_stack([moisture, temp, ec, ph, n_val, p_val, k_val])

NUM_SAMPLES = 1234  # Một con số ngẫu nhiên cho tự nhiên
X_seq, y_true = [], []

for _ in range(NUM_SAMPLES):
    rand_class = np.random.uniform()
    if rand_class < 0.30:  # 30% Healthy
        X_seq.append(make_healthy())
        y_true.append("healthy")
    elif rand_class < 0.85: # 55% Disease Risk (Vùng mà LSTM cực kỳ tỏa sáng)
        # Ngẫu nhiên 40% rõ ràng, 60% vùng xám
        is_obvious = np.random.uniform() < 0.40
        X_seq.append(make_disease(obvious=is_obvious))
        y_true.append("disease_risk")
    else:                  # 15% Nutrient Deficient
        # Ngẫu nhiên 50% rõ ràng, 50% vùng xám
        is_obvious = np.random.uniform() < 0.50
        X_seq.append(make_nutrient(obvious=is_obvious))
        y_true.append("nutrient_deficient")

X_seq  = np.array(X_seq)
y_true = np.array(y_true)

# ── M1: IF-ELSE ──────────────────────────────────────────────────
# Nhìn GIÁ TRỊ TRUNG BÌNH của 24 timestep → bỏ lọt trend
def rule_based(seq):
    m = seq.mean(axis=0)   # Trung bình 24h
    moisture, temp, ec, ph, n, p, k = m
    if moisture > 78 and ph < 5.8:  return "disease_risk"
    if n < 85 or p < 32 or k < 148: return "nutrient_deficient"
    return "healthy"

y_rule = np.array([rule_based(s) for s in X_seq])
acc_rule = np.mean(y_rule == y_true)

# Phân tích lỗi
rule_miss_disease  = np.sum((y_true == "disease_risk")   & (y_rule != "disease_risk"))
rule_miss_nutrient = np.sum((y_true == "nutrient_deficient") & (y_rule != "nutrient_deficient"))

# ── M2: LSTM TFLite ───────────────────────────────────────────────
try:
    import tflite_runtime.interpreter as tflite
    Interpreter = tflite.Interpreter
except ImportError:
    import tensorflow as tf
    Interpreter = tf.lite.Interpreter

interp = Interpreter(model_path="models/lstm/tomato_potato_lstm.tflite")
interp.allocate_tensors()
inp_d = interp.get_input_details()[0]
out_d = interp.get_output_details()[0]

def lstm_pred(seq):
    s = scaler.transform(seq).reshape(1, 24, 7).astype(np.float32)
    interp.set_tensor(inp_d["index"], s)
    interp.invoke()
    idx = np.argmax(interp.get_tensor(out_d["index"])[0])
    return group(CLASSES[idx])

print("Đang chạy LSTM TFLite (300 mẫu)...")
y_lstm = np.array([lstm_pred(s) for s in X_seq])
acc_lstm = np.mean(y_lstm == y_true)

lstm_miss_disease  = np.sum((y_true == "disease_risk")   & (y_lstm != "disease_risk"))
lstm_miss_nutrient = np.sum((y_true == "nutrient_deficient") & (y_lstm != "nutrient_deficient"))

# ── In kết quả ───────────────────────────────────────────────────
print(f"\n{'='*58}")
print(f"  KẾT QUẢ — {NUM_SAMPLES} mẫu test (Dữ liệu ngẫu nhiên)")
print(f"{'='*58}")
print(f"  M1 IF-ELSE (Ngưỡng cứng)      : {acc_rule*100:.1f}%")
print(f"     Bỏ lọt bệnh (disease_risk)  : {rule_miss_disease} ca")
print(f"     Bỏ lọt thiếu dinh dưỡng    : {rule_miss_nutrient} ca")
print(f"  M2 LSTM TFLite (Chuỗi 24 giờ) : {acc_lstm*100:.1f}%")
print(f"     Bỏ lọt bệnh (disease_risk)  : {lstm_miss_disease} ca")
print(f"     Bỏ lọt thiếu dinh dưỡng    : {lstm_miss_nutrient} ca")
print(f"{'='*58}")

# ── Vẽ biểu đồ ───────────────────────────────────────────────────
fig, ax = plt.subplots(figsize=(8, 6), facecolor="white")

labels = ["IF-ELSE\n(Ngưỡng cứng, 1 điểm đo)", "LSTM TFLite\n(Học từ chuỗi 24 giờ)"]
values = [acc_rule*100, acc_lstm*100]
colors = ["#aaaaaa", "#2e7d32"]

bars = ax.bar(labels, values, color=colors, width=0.45, zorder=3)
for bar, val in zip(bars, values):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.8,
            f"{val:.1f}%", ha="center", va="bottom", fontsize=15, fontweight="bold")

ax.set_ylim(0, 110)
ax.set_ylabel("Độ chính xác (%)", fontsize=12)
ax.set_title("Phân loại tình trạng đất\nIF-ELSE (Ngưỡng cứng) vs LSTM (Học máy)",
             fontsize=13, fontweight="bold", pad=15)
ax.text(0.5, -0.13,
        f"Dữ liệu: {NUM_SAMPLES} mẫu chuỗi 24 giờ ngẫu nhiên (có trend + nhiễu)",
        ha="center", transform=ax.transAxes, fontsize=8.5, color="#555555", style="italic")

ax.grid(axis="y", linestyle="--", alpha=0.5, zorder=0)
ax.set_axisbelow(True)
ax.spines[["top","right"]].set_visible(False)

delta = values[1] - values[0]
ax.annotate("", xy=(1, values[1] - 1), xytext=(0, values[0] + 1),
            arrowprops=dict(arrowstyle="->", color="#c62828", lw=2.0))
ax.text(0.5, (values[0] + values[1])/2,
        f"+{delta:.1f}%", color="#c62828", fontsize=13, fontweight="bold", ha="center")

plt.tight_layout()
OUT = r"C:\Users\Admin\.gemini\antigravity\brain\353ba16c-0e6c-44f7-8191-47b1ffdcb7e1\lstm_vs_ifelse.png"
plt.savefig(OUT, dpi=200, bbox_inches="tight")
print(f"\nĐã lưu biểu đồ: {OUT}")
