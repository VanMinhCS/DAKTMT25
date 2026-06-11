"""
Test ngẫu nhiên 10,000 trường hợp với mô hình RF thật.

Dữ liệu: Hoàn toàn ngẫu nhiên, KHÔNG dùng luật chuyên gia như lúc train.
Mục tiêu: Xem RF quyết định gì trên toàn bộ không gian đầu vào, và so sánh
          với hệ thống Vision-only (chỉ dùng YOLO conf >= 0.6 thì báo).

Chạy: venv\\Scripts\\python.exe tools\\test_rf_random_10k.py
"""
import sys
import random
import pickle
import os
import numpy as np
from collections import Counter

sys.stdout.reconfigure(encoding='utf-8')

# ─── TẢI MÔ HÌNH RF THẬT ────────────────────────────────────────────────────
MODEL_PATH = os.path.join("models", "fusion", "rf_fusion_model.pkl")
with open(MODEL_PATH, "rb") as f:
    data = pickle.load(f)

rf_model    = data["model"]
YOLO_MAP    = data["yolo_map"]
LSTM_MAP    = data["lstm_map"]
LEVEL_NAMES = data["level_names"]

# ─── SINH 10,000 TRƯỜNG HỢP NGẪU NHIÊN ─────────────────────────────────────
# Mỗi trường hợp: chọn ngẫu nhiên hoàn toàn cả 4 thông số đầu vào.
# KHÔNG có luật chuyên gia nào can thiệp vào quá trình sinh dữ liệu.
random.seed(None)  # Seed thời gian thực → Mỗi lần chạy ra số khác nhau

N = 10000
yolo_statuses = list(YOLO_MAP.keys())   # No_Detection, Healthy, Checking, Warning
lstm_statuses = list(LSTM_MAP.keys())   # unknown, healthy, nutrient_deficient, disease_risk

print(f"Đang sinh {N} trường hợp ngẫu nhiên...")
X = []
yolo_raw = []
for _ in range(N):
    ys = random.choice(yolo_statuses)
    ls = random.choice(lstm_statuses)
    yc = round(random.uniform(0.30, 0.99), 2)
    lc = round(random.uniform(0.30, 0.99), 2)
    X.append([YOLO_MAP[ys], yc, LSTM_MAP[ls], lc])
    yolo_raw.append((ys, yc))

X = np.array(X)

# ─── CHẠY QUA 2 HỆ THỐNG ────────────────────────────────────────────────────

# 1. Vision-only: YOLO Status = Warning VÀ conf >= 0.6 → báo động (level >= 3)
vision_alarms = sum(
    1 for (ys, yc) in yolo_raw
    if ys == "Warning" and yc >= 0.60
)

# 2. RF Fusion
rf_preds = rf_model.predict(X)
rf_counts = Counter(rf_preds)

rf_alarms       = sum(rf_counts.get(lvl, 0) for lvl in [3, 4])  # WARNING + CRITICAL
rf_pre_warning  = rf_counts.get(2, 0)   # PRE_WARNING: ghi nhận nhưng chưa hú còi
rf_verification = rf_counts.get(1, 0)   # VERIFICATION: chỉ nhắc kiểm tra
rf_normal       = rf_counts.get(0, 0)   # NORMAL

# ─── PHÂN TÍCH CHI TIẾT: RF quyết định gì với từng combo YOLO + LSTM ─────────
print("\nPhân tích quyết định RF theo từng tổ hợp YOLO + LSTM:")
print(f"{'YOLO Status':<18} {'LSTM Status':<22} {'RF NORMAL':>10} {'RF VERIF':>10} {'RF PRE_W':>10} {'RF WARN+':>10} {'Tổng':>7}")
print("-" * 90)

# 4 buckets: 0=Normal, 1=Verif, 2=PreWarn, 3+=Alarm
combo_stats2 = {}
for i, (ys, yc) in enumerate(yolo_raw):
    ls_idx = int(X[i][2])
    ls = [k for k, v in LSTM_MAP.items() if v == ls_idx][0]
    key = (ys, ls)
    if key not in combo_stats2:
        combo_stats2[key] = [0, 0, 0, 0]  # normal, verif, pre_warn, alarm
    pred = rf_preds[i]
    bucket = min(pred, 3)
    combo_stats2[key][bucket] += 1

for (ys, ls), counts in sorted(combo_stats2.items()):
    total = sum(counts)
    alarm_pct = counts[3] / total * 100
    alarm_marker = " ⚠️" if counts[3] > 0 else " ✅"
    print(f"{ys:<18} {ls:<22} {counts[0]:>10} {counts[1]:>10} {counts[2]:>10} {counts[3]:>10} {total:>7}{alarm_marker}")

# ─── KẾT QUẢ TỔNG HỢP ────────────────────────────────────────────────────────
yolo_alarm_pct  = vision_alarms / N * 100
rf_alarm_pct    = rf_alarms / N * 100
suppressed      = vision_alarms - rf_alarms
suppressed_pct  = suppressed / vision_alarms * 100 if vision_alarms > 0 else 0

print(f"\n{'=' * 70}")
print(f"  KẾT QUẢ TỔNG HỢP — {N} trường hợp ngẫu nhiên (seed thời gian thực)")
print(f"{'=' * 70}")
print(f"  VISION-ONLY (YOLO Warning + conf>=0.6):")
print(f"    → Phát tín hiệu báo động: {vision_alarms:>6} / {N} ca  ({yolo_alarm_pct:.1f}%)")
print(f"")
print(f"  RF LATE FUSION:")
print(f"    → NORMAL      (im lặng)   : {rf_normal:>6} / {N} ca  ({rf_normal/N*100:.1f}%)")
print(f"    → VERIFICATION (nhắc nhở) : {rf_verification:>6} / {N} ca  ({rf_verification/N*100:.1f}%)")
print(f"    → PRE_WARNING  (theo dõi) : {rf_pre_warning:>6} / {N} ca  ({rf_pre_warning/N*100:.1f}%)")
print(f"    → WARNING+CRIT (báo động) : {rf_alarms:>6} / {N} ca  ({rf_alarm_pct:.1f}%)")
print(f"")
print(f"  SO SÁNH:")
print(f"    → Số ca RF chặn lại (không hú còi): {suppressed:>6} ca")
print(f"    → Tỷ lệ giảm báo động: {suppressed_pct:.1f}%")
print(f"{'=' * 70}")
print(f"  Lưu ý: Kết quả thay đổi mỗi lần chạy vì dữ liệu hoàn toàn ngẫu nhiên.")
print(f"  Chạy lại nhiều lần để xem tính ổn định của mô hình RF.")
print(f"{'=' * 70}")
