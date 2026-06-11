"""
2 bài test trong 1 file:
  [A] LSTM vs IF-ELSE: Dữ liệu có xu hướng thời gian (trend), overlap.
  [B] RF Fusion vs IF-ELSE Fusion: Dữ liệu sensor vùng xám (borderline confidence).

Chạy: venv\\Scripts\\python.exe tools\\test_comparison_charts.py
"""
import sys, os, pickle, warnings
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from sklearn.ensemble import RandomForestClassifier

sys.stdout.reconfigure(encoding="utf-8")
warnings.filterwarnings("ignore")

np.random.seed(42)

# ═══════════════════════════════════════════════════════════════════
# PHẦN A — LSTM vs IF-ELSE (Phân loại tình trạng đất)
# ═══════════════════════════════════════════════════════════════════

SCALER_PATH  = "models/lstm/tomato_potato_lstm_scaler.pkl"
ENCODER_PATH = "models/lstm/tomato_potato_lstm_encoder.pkl"
TFLITE_PATH  = "models/lstm/tomato_potato_lstm.tflite"

scaler  = pickle.load(open(SCALER_PATH,  "rb"))
encoder = pickle.load(open(ENCODER_PATH, "rb"))
CLASSES = list(encoder.classes_)

DISEASE_RISK = {"Bacterial_Spot_Risk","Early_Blight_Risk","Late_Blight_Risk","Leaf_Mold_Risk"}
NUTRIENT_DEF = {"Fe_Deficient","K_Deficient","N_Deficient","P_Deficient"}

def group(label):
    if label in DISEASE_RISK: return "disease_risk"
    if label in NUTRIENT_DEF: return "nutrient_deficient"
    return "healthy"

# ── Sinh dữ liệu có OVERLAP & TREND ──────────────────────────────
# Kịch bản: Sensor đọc mỗi giờ trong 24 giờ.
# Healthy: Giá trị dao động ngẫu nhiên quanh ngưỡng an toàn (không có trend).
# Disease risk: Ẩm độ TĂNG DẦN, pH GIẢM DẦN theo thời gian.
#   → Tại bất kỳ 1 điểm nào giá trị vẫn trong vùng xám,
#     nhưng chuỗi 24h lộ rõ xu hướng nguy hiểm.

def make_healthy_trend(n=24):
    """Ổn định, dao động ngẫu nhiên, không có xu hướng."""
    base = np.array([68, 22, 1550, 6.3, 130, 52, 220])  # Giá trị tốt
    noise = np.random.uniform(-5, 5, (n, 7)) * np.array([3, 0.5, 50, 0.1, 8, 4, 12])
    return np.tile(base, (n, 1)) + noise

def make_disease_trend(n=24):
    """
    Xu hướng nguy hiểm dần theo giờ:
    - Ẩm độ tăng từ 68% → 82% (do mưa/tưới quá nhiều)
    - pH giảm từ 6.2 → 5.6 (đất đang bị chua hóa)
    Tại bất kỳ 1 điểm đo nào, giá trị vẫn nằm TRONG VÙNG XÁM
    (không vượt ngưỡng cứng). Chỉ nhìn TREND mới thấy nguy hiểm.
    """
    moisture = np.linspace(68, 82, n) + np.random.uniform(-2, 2, n)
    ph       = np.linspace(6.2, 5.6, n) + np.random.uniform(-0.05, 0.05, n)
    temp     = np.random.uniform(24, 28, n)
    ec       = np.linspace(1400, 1900, n) + np.random.uniform(-80, 80, n)
    n_val    = np.random.uniform(100, 120, n)
    p_val    = np.random.uniform(40,  55,  n)
    k_val    = np.random.uniform(170, 210, n)
    return np.column_stack([moisture, temp, ec, ph, n_val, p_val, k_val])

def make_nutrient_trend(n=24):
    """Dinh dưỡng giảm dần theo ngày (cây hút dần mà không bón bù)."""
    n_val = np.linspace(120, 70, n) + np.random.uniform(-5, 5, n)
    p_val = np.linspace(50,  25, n) + np.random.uniform(-3, 3, n)
    k_val = np.linspace(210, 130, n) + np.random.uniform(-8, 8, n)
    moisture = np.random.uniform(55, 68, n)
    temp     = np.random.uniform(19, 24, n)
    ec       = np.linspace(1300, 900, n) + np.random.uniform(-60, 60, n)
    ph       = np.random.uniform(5.8, 6.4, n)
    return np.column_stack([moisture, temp, ec, ph, n_val, p_val, k_val])

N_EACH = 100
X_seq, y_true_a = [], []
for _ in range(N_EACH):
    X_seq.append(make_healthy_trend());  y_true_a.append("healthy")
for _ in range(N_EACH):
    X_seq.append(make_disease_trend());  y_true_a.append("disease_risk")
for _ in range(N_EACH):
    X_seq.append(make_nutrient_trend()); y_true_a.append("nutrient_deficient")
X_seq  = np.array(X_seq)
y_true_a = np.array(y_true_a)

# M1: IF-ELSE — nhìn GIÁ TRỊ TRUNG BÌNH của chuỗi (không thấy trend)
def rule_based(seq):
    m = seq.mean(axis=0)
    moisture, temp, ec, ph, n, p, k = m
    if moisture > 78 and ph < 5.8:           return "disease_risk"
    if n < 85 or p < 32 or k < 148:          return "nutrient_deficient"
    return "healthy"

y_rule_a = np.array([rule_based(s) for s in X_seq])
acc_rule_a = np.mean(y_rule_a == y_true_a)

# M2: LSTM — nhìn toàn bộ chuỗi 24 timestep
try:
    import tflite_runtime.interpreter as tflite
    Interpreter = tflite.Interpreter
except ImportError:
    import tensorflow as tf
    Interpreter = tf.lite.Interpreter

interp = Interpreter(model_path=TFLITE_PATH)
interp.allocate_tensors()
inp_d = interp.get_input_details()[0]
out_d = interp.get_output_details()[0]

def lstm_pred(seq):
    s = scaler.transform(seq).reshape(1, 24, 7).astype(np.float32)
    interp.set_tensor(inp_d["index"], s)
    interp.invoke()
    idx = np.argmax(interp.get_tensor(out_d["index"])[0])
    return group(CLASSES[idx])

print("Đang chạy LSTM (300 mẫu)...")
y_lstm_a = np.array([lstm_pred(s) for s in X_seq])
acc_lstm_a = np.mean(y_lstm_a == y_true_a)

print(f"[A] IF-ELSE: {acc_rule_a*100:.1f}%  |  LSTM: {acc_lstm_a*100:.1f}%")

# ═══════════════════════════════════════════════════════════════════
# PHẦN B — RF Fusion vs IF-ELSE Fusion (Dung hợp YOLO + LSTM)
# ═══════════════════════════════════════════════════════════════════

RF_PATH = "models/fusion/rf_fusion_model.pkl"
rf_data    = pickle.load(open(RF_PATH, "rb"))
rf_model   = rf_data["model"]
YOLO_MAP   = rf_data["yolo_map"]
LSTM_MAP   = rf_data["lstm_map"]
LEVEL_NAMES = rf_data["level_names"]

# Sinh 500 ca VÙNG XÁM: confidence nằm 0.55-0.80 — vùng IF-ELSE dễ sai
# Ground truth: expert logic đầy đủ từ train_fusion_rf.py
def expert_label(ys, yc, ls, lc):
    """Nhãn 'chuyên gia lý tưởng' — dùng làm ground truth."""
    lstm_bad = ls in ["disease_risk", "nutrient_deficient"]
    if lstm_bad and lc >= 0.70:
        if ys == "Warning" and yc >= 0.60: return 4  # CRITICAL
        return 3                                       # WARNING
    if lstm_bad and lc < 0.70:
        if ys == "Warning" and yc >= 0.70: return 3  # WARNING
        return 2                                       # PRE_WARNING
    if ls == "healthy" and lc >= 0.70:
        if ys == "Warning" and yc >= 0.80: return 1  # VERIFICATION
        return 0                                       # NORMAL
    if ys == "Warning":
        return 3 if yc >= 0.60 else 1
    if ys == "Checking":
        return 2 if yc >= 0.70 else 0
    return 0

def simple_ifelse_fusion(ys, yc, ls, lc):
    """
    IF-ELSE đơn giản hóa (như lập trình viên thường viết):
    Ngưỡng cứng 0.7 cho tất cả, không phân biệt từng trường hợp.
    """
    lstm_bad = ls in ["disease_risk", "nutrient_deficient"]
    if ys == "Warning" and yc >= 0.70 and lstm_bad and lc >= 0.70:
        return 4  # CRITICAL
    if ys == "Warning" and yc >= 0.70:
        return 3  # WARNING (bất kể LSTM nói gì)
    if lstm_bad and lc >= 0.70:
        return 3  # WARNING
    if lstm_bad:
        return 2  # PRE_WARNING
    return 0      # NORMAL

N_B = 500
yolo_statuses = list(YOLO_MAP.keys())
lstm_statuses = list(LSTM_MAP.keys())

cases_b = []
y_true_b = []
for _ in range(N_B):
    ys = np.random.choice(yolo_statuses)
    ls = np.random.choice(list(LSTM_MAP.keys()))
    # Confidence vùng xám: 0.55 - 0.82 (IF-ELSE dùng ngưỡng 0.7 sẽ hay sai)
    yc = np.random.uniform(0.55, 0.82)
    lc = np.random.uniform(0.55, 0.82)
    cases_b.append((ys, yc, ls, lc))
    y_true_b.append(expert_label(ys, yc, ls, lc))

y_true_b = np.array(y_true_b)

# M1: IF-ELSE Fusion
y_ifelse_b = np.array([simple_ifelse_fusion(ys, yc, ls, lc)
                        for (ys, yc, ls, lc) in cases_b])
acc_ifelse_b = np.mean(y_ifelse_b == y_true_b)

# M2: RF Fusion
X_b = np.array([[YOLO_MAP[ys], yc, LSTM_MAP[ls], lc]
                 for (ys, yc, ls, lc) in cases_b])
y_rf_b = rf_model.predict(X_b)
acc_rf_b = np.mean(y_rf_b == y_true_b)

print(f"[B] IF-ELSE Fusion: {acc_ifelse_b*100:.1f}%  |  RF Fusion: {acc_rf_b*100:.1f}%")

# ═══════════════════════════════════════════════════════════════════
# VẼ 2 BIỂU ĐỒ CẠNH NHAU
# ═══════════════════════════════════════════════════════════════════
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(13, 6), facecolor="white")

def draw_bar(ax, labels, values, colors, title, subtitle):
    bars = ax.bar(labels, values, color=colors, width=0.45, zorder=3)
    for bar, val in zip(bars, values):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.8,
                f"{val:.1f}%", ha="center", va="bottom",
                fontsize=14, fontweight="bold")
    ax.set_ylim(0, 115)
    ax.set_ylabel("Độ chính xác (%)", fontsize=11)
    ax.set_title(title, fontsize=12, fontweight="bold", pad=10)
    ax.text(0.5, -0.16, subtitle, ha="center", transform=ax.transAxes,
            fontsize=9, color="#555555", style="italic")
    ax.grid(axis="y", linestyle="--", alpha=0.5, zorder=0)
    ax.set_axisbelow(True)
    ax.spines[["top", "right"]].set_visible(False)
    # Mũi tên cải thiện
    delta = values[1] - values[0]
    ax.annotate("", xy=(1, values[1] - 1), xytext=(0, values[0] + 1),
                arrowprops=dict(arrowstyle="->", color="#c62828", lw=1.8))
    ax.text(0.5, (values[0] + values[1])/2,
            f"{'+' if delta>=0 else ''}{delta:.1f}%",
            color="#c62828", fontsize=12, fontweight="bold", ha="center")

draw_bar(ax1,
    ["IF-ELSE\n(Ngưỡng cứng)", "LSTM TFLite\n(Chuỗi 24 giờ)"],
    [acc_rule_a*100, acc_lstm_a*100],
    ["#aaaaaa", "#2e7d32"],
    "A. Phân loại tình trạng đất",
    "Dữ liệu có xu hướng thời gian (trend) + nhiễu\n300 mẫu test"
)

draw_bar(ax2,
    ["IF-ELSE Fusion\n(Ngưỡng cứng)", "Random Forest\nFusion"],
    [acc_ifelse_b*100, acc_rf_b*100],
    ["#aaaaaa", "#1565c0"],
    "B. Dung hợp quyết định (YOLO + LSTM)",
    "Dữ liệu confidence vùng xám (0.55–0.82)\n500 mẫu test"
)

plt.suptitle("So sánh IF-ELSE vs Học máy — 2 bài toán trong hệ thống",
             fontsize=14, fontweight="bold", y=1.02)
plt.tight_layout()

OUT = r"C:\Users\Admin\.gemini\antigravity\brain\353ba16c-0e6c-44f7-8191-47b1ffdcb7e1\comparison_charts_final.png"
plt.savefig(OUT, dpi=200, bbox_inches="tight")
print(f"\nĐã lưu: {OUT}")
