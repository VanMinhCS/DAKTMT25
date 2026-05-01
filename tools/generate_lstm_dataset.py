"""
generate_lstm_dataset.py
═══════════════════════════════════════════════════════════════════════════════
Tạo dataset tổng hợp (synthetic) dựa trên kiến thức nông học chuẩn
để huấn luyện mô hình LSTM phát hiện nguy cơ bệnh cây trồng qua cảm biến đất.

Cây giám sát : Cà chua (Tomato) + Khoai tây (Potato)
Cảm biến     : Soil_Moisture, Soil_Temperature, EC, pH, N, P, K
Labels (9)   : Healthy
               N_Deficient | P_Deficient | K_Deficient | Fe_Deficient
               Late_Blight_Risk | Early_Blight_Risk
               Bacterial_Spot_Risk | Leaf_Mold_Risk

Thời gian    : Mô phỏng 2 năm liên tục (2023–2024), đọc mỗi giờ
Tổng output  : ~247,200 dòng (~10,300 sequence × 24 timestep)

Tài liệu tham khảo nông học (ngưỡng giá trị):
  - FAO Plant Nutrition Management (Solanaceae)
  - CABI Compendium: Phytophthora infestans, Alternaria solani
  - Agrios, G.N. (2005). Plant Pathology, 5th Ed.
  - USDA-ARS Crop Nutrient Tool (Tomato, Potato)
═══════════════════════════════════════════════════════════════════════════════
"""

import os
import random
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

# ── Cấu hình chung ────────────────────────────────────────────────────────────
WINDOW_SIZE    = 24          # timestep / sequence (24 giờ)
NOISE_STD_FRAC = 0.04        # độ nhiễu = 4% khoảng range của mỗi feature
RANDOM_SEED    = 42
START_DATE     = datetime(2023, 1, 1, 0, 0, 0)

# Số sequence mỗi (plant_type, label)
# Bệnh/nguy cơ ưu tiên hơn Healthy vì YOLO đã xử lý trường hợp Healthy
SEQ_COUNT = {
    "Healthy":             250,   # ít — YOLO đã cover
    "N_Deficient":         600,
    "P_Deficient":         600,
    "K_Deficient":         600,
    "Fe_Deficient":        600,
    "Late_Blight_Risk":    700,   # nguy hiểm nhất → ưu tiên cao nhất
    "Early_Blight_Risk":   700,
    "Bacterial_Spot_Risk": 550,
    "Leaf_Mold_Risk":      550,
}

PLANT_TYPES  = ["tomato", "potato"]
FEATURE_KEYS = ["Soil_Moisture", "Soil_Temperature", "EC", "pH",
                "Nitrogen", "Phosphorus", "Potassium"]

OUTPUT_DIR  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "data")
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "tomato_potato_health.csv")

# ── Ngưỡng nông học theo từng trạng thái ─────────────────────────────────────
# Đơn vị:
#   Soil_Moisture    : %            (0–100)
#   Soil_Temperature : °C
#   EC               : µS/cm       (độ dẫn điện — proxy cho dinh dưỡng tổng)
#   pH               : thang pH    (0–14)
#   Nitrogen         : mg/kg đất
#   Phosphorus       : mg/kg đất
#   Potassium        : mg/kg đất
# ─────────────────────────────────────────────────────────────────────────────
CONDITIONS = {

    # ══════════════════════════════════════════════════════════════════════════
    #  CÀ CHUA (TOMATO) — Lycopersicon esculentum
    #  pH tối ưu: 6.0–6.8 | Nhiệt độ tối ưu: 20–28°C
    # ══════════════════════════════════════════════════════════════════════════
    "tomato": {

        "Healthy": {
            # Nguồn: FAO Irrigation & Drainage Paper 56 (Tomato)
            "Soil_Moisture":    (65.0, 75.0),
            "Soil_Temperature": (20.0, 28.0),
            "EC":               (1800, 2500),
            "pH":               (6.0,  6.8),
            "Nitrogen":         (140,  200),
            "Phosphorus":       (50,    80),
            "Potassium":        (180,  250),
        },

        "N_Deficient": {
            # Triệu chứng: lá vàng từ dưới lên, cây còi cọc
            # Ngưỡng: N < 50 mg/kg, EC < 1300 µS/cm
            "Soil_Moisture":    (55.0, 70.0),
            "Soil_Temperature": (20.0, 30.0),
            "EC":               (600,  1300),
            "pH":               (5.8,  6.8),
            "Nitrogen":         (10,    50),
            "Phosphorus":       (35,    70),
            "Potassium":        (140,  220),
        },

        "P_Deficient": {
            # Triệu chứng: lá tím, rễ kém phát triển
            # Ngưỡng: P < 20 mg/kg; pH < 5.5 → P bị cố định (Fe/Al phosphate)
            "Soil_Moisture":    (55.0, 72.0),
            "Soil_Temperature": (18.0, 28.0),
            "EC":               (900,  1600),
            "pH":               (4.5,  5.4),
            "Nitrogen":         (90,   160),
            "Phosphorus":       (5,     18),
            "Potassium":        (140,  220),
        },

        "K_Deficient": {
            # Triệu chứng: mép lá cháy vàng, quả nhỏ, sức đề kháng kém
            # Ngưỡng: K < 90 mg/kg
            "Soil_Moisture":    (55.0, 72.0),
            "Soil_Temperature": (20.0, 30.0),
            "EC":               (1000, 1700),
            "pH":               (5.8,  6.8),
            "Nitrogen":         (100,  170),
            "Phosphorus":       (35,    65),
            "Potassium":        (20,    90),
        },

        "Fe_Deficient": {
            # Triệu chứng: lá non vàng (interveinal chlorosis)
            # Cơ chế: pH > 7.2 → Fe(OH)₃ kết tủa, cây không hấp thụ được
            "Soil_Moisture":    (55.0, 75.0),
            "Soil_Temperature": (18.0, 28.0),
            "EC":               (1400, 2500),
            "pH":               (7.2,  8.5),
            "Nitrogen":         (110,  180),
            "Phosphorus":       (40,    70),
            "Potassium":        (150,  220),
        },

        "Late_Blight_Risk": {
            # Phytophthora infestans — mốc sương
            # Điều kiện: ẩm > 85%, nhiệt độ mát 10–22°C (đêm lạnh + sương)
            # Ref: CABI Phytophthora infestans Datasheet
            "Soil_Moisture":    (85.0, 96.0),
            "Soil_Temperature": (10.0, 22.0),
            "EC":               (1300, 2200),
            "pH":               (5.8,  7.0),
            "Nitrogen":         (90,   180),
            "Phosphorus":       (35,    70),
            "Potassium":        (140,  220),
        },

        "Early_Blight_Risk": {
            # Alternaria solani — đốm lá sớm
            # Điều kiện: hạn + nóng + N thấp (cây suy yếu, dễ nhiễm)
            # Ref: Agrios (2005), Ch. 11
            "Soil_Moisture":    (20.0, 45.0),
            "Soil_Temperature": (25.0, 34.0),
            "EC":               (700,  1400),
            "pH":               (5.5,  6.8),
            "Nitrogen":         (25,    80),
            "Phosphorus":       (22,    55),
            "Potassium":        (90,   170),
        },

        "Bacterial_Spot_Risk": {
            # Xanthomonas vesicatoria
            # Điều kiện: ẩm cao + ấm + pH trung tính–kiềm nhẹ
            "Soil_Moisture":    (78.0, 92.0),
            "Soil_Temperature": (25.0, 33.0),
            "EC":               (1200, 2200),
            "pH":               (6.5,  7.5),
            "Nitrogen":         (90,   165),
            "Phosphorus":       (30,    65),
            "Potassium":        (140,  210),
        },

        "Leaf_Mold_Risk": {
            # Passalora fulva (Fulvia fulva)
            # Điều kiện: ẩm cao + khí mát + thông gió kém
            "Soil_Moisture":    (80.0, 93.0),
            "Soil_Temperature": (18.0, 26.0),
            "EC":               (1200, 2200),
            "pH":               (5.8,  7.0),
            "Nitrogen":         (90,   170),
            "Phosphorus":       (35,    70),
            "Potassium":        (140,  210),
        },
    },

    # ══════════════════════════════════════════════════════════════════════════
    #  KHOAI TÂY (POTATO) — Solanum tuberosum
    #  pH tối ưu: 5.5–6.5 | Nhiệt độ tối ưu: 15–22°C
    # ══════════════════════════════════════════════════════════════════════════
    "potato": {

        "Healthy": {
            # Nguồn: FAO Agronomy Series — Potato Production
            "Soil_Moisture":    (70.0, 80.0),
            "Soil_Temperature": (15.0, 22.0),
            "EC":               (1500, 2200),
            "pH":               (5.5,  6.5),
            "Nitrogen":         (120,  180),
            "Phosphorus":       (40,    70),
            "Potassium":        (200,  280),
        },

        "N_Deficient": {
            "Soil_Moisture":    (55.0, 72.0),
            "Soil_Temperature": (15.0, 25.0),
            "EC":               (500,  1200),
            "pH":               (5.3,  6.5),
            "Nitrogen":         (8,     45),
            "Phosphorus":       (25,    60),
            "Potassium":        (145,  220),
        },

        "P_Deficient": {
            "Soil_Moisture":    (55.0, 72.0),
            "Soil_Temperature": (13.0, 22.0),
            "EC":               (700,  1400),
            "pH":               (4.4,  5.2),
            "Nitrogen":         (78,   140),
            "Phosphorus":       (4,     15),
            "Potassium":        (145,  240),
        },

        "K_Deficient": {
            "Soil_Moisture":    (55.0, 72.0),
            "Soil_Temperature": (15.0, 24.0),
            "EC":               (850,  1700),
            "pH":               (5.3,  6.5),
            "Nitrogen":         (85,   155),
            "Phosphorus":       (26,    55),
            "Potassium":        (22,    95),
        },

        "Fe_Deficient": {
            "Soil_Moisture":    (58.0, 75.0),
            "Soil_Temperature": (13.0, 22.0),
            "EC":               (1100, 2200),
            "pH":               (7.2,  8.5),
            "Nitrogen":         (90,   160),
            "Phosphorus":       (30,    65),
            "Potassium":        (155,  240),
        },

        "Late_Blight_Risk": {
            # Đặc biệt nguy hiểm với khoai tây — gây thối củ nhanh
            # Nhiệt độ ngưỡng thấp hơn cà chua (khí hậu mát hơn)
            "Soil_Moisture":    (85.0, 96.0),
            "Soil_Temperature": (8.0,  20.0),
            "EC":               (1100, 2000),
            "pH":               (5.2,  7.0),
            "Nitrogen":         (75,   160),
            "Phosphorus":       (30,    65),
            "Potassium":        (150,  240),
        },

        "Early_Blight_Risk": {
            "Soil_Moisture":    (20.0, 45.0),
            "Soil_Temperature": (22.0, 30.0),
            "EC":               (600,  1300),
            "pH":               (5.0,  6.5),
            "Nitrogen":         (20,    70),
            "Phosphorus":       (18,    50),
            "Potassium":        (85,   155),
        },

        "Bacterial_Spot_Risk": {
            "Soil_Moisture":    (75.0, 90.0),
            "Soil_Temperature": (22.0, 30.0),
            "EC":               (1000, 2000),
            "pH":               (6.0,  7.5),
            "Nitrogen":         (75,   145),
            "Phosphorus":       (25,    58),
            "Potassium":        (138,  215),
        },

        "Leaf_Mold_Risk": {
            "Soil_Moisture":    (80.0, 93.0),
            "Soil_Temperature": (14.0, 22.0),
            "EC":               (1000, 2000),
            "pH":               (5.2,  7.0),
            "Nitrogen":         (78,   155),
            "Phosphorus":       (28,    65),
            "Potassium":        (138,  215),
        },
    },
}


# ── Seasonal modifier — điều chỉnh theo mùa (khí hậu nhiệt đới Việt Nam) ────
def seasonal_modifier(month: int) -> dict:
    """
    Trả về dict offset theo mùa.
    Mùa mưa (5–10): ẩm hơn, mát hơn
    Mùa khô (11–4): khô hơn, nóng hơn
    """
    if 5 <= month <= 10:   # Mùa mưa
        return {"Soil_Moisture": +8.0, "Soil_Temperature": -3.0}
    else:                  # Mùa khô
        return {"Soil_Moisture": -7.0, "Soil_Temperature": +3.0}


# ── Sinh chuỗi thời gian ──────────────────────────────────────────────────────
def generate_sequence(feature_ranges: dict, month: int) -> list:
    """
    Sinh 1 sequence gồm WINDOW_SIZE timestep cho 1 điều kiện.

    - Chọn ngẫu nhiên giá trị trung tâm trong khoảng nông học
    - Áp dụng seasonal offset
    - Thêm Gaussian noise trên mỗi timestep
    - Thêm drift nhỏ để sequence có xu hướng tự nhiên (không phẳng lặng)

    Returns:
        list of WINDOW_SIZE rows, mỗi row = list of 7 floats (theo FEATURE_KEYS)
    """
    season = seasonal_modifier(month)

    # Chọn center ngẫu nhiên cho sequence này (có seasonal offset)
    centers = {}
    for k in FEATURE_KEYS:
        lo, hi = feature_ranges[k]
        offset = season.get(k, 0.0)
        center = random.uniform(lo, hi) + offset
        # Clip center về bound hợp lý
        centers[k] = np.clip(center, lo * 0.85, hi * 1.15)

    rows = []
    for t in range(WINDOW_SIZE):
        row = []
        for k in FEATURE_KEYS:
            lo, hi = feature_ranges[k]
            range_size = hi - lo
            noise = np.random.normal(0, range_size * NOISE_STD_FRAC)
            # Drift: xu hướng nhỏ theo thời gian trong sequence
            drift = (t / WINDOW_SIZE) * range_size * random.uniform(-0.03, 0.03)
            val = centers[k] + noise + drift
            val = np.clip(val, lo * 0.82, hi * 1.18)
            row.append(round(float(val), 2))
        rows.append(row)

    return rows


# ── Sinh toàn bộ dataset ──────────────────────────────────────────────────────
def generate_dataset() -> pd.DataFrame:
    np.random.seed(RANDOM_SEED)
    random.seed(RANDOM_SEED)

    all_records = []
    current_ts  = START_DATE
    seq_global_id = 0

    labels     = list(SEQ_COUNT.keys())
    total_seqs = sum(SEQ_COUNT.values()) * len(PLANT_TYPES)

    print("=" * 65)
    print("  [*] LSTM DATASET GENERATOR - Tomato & Potato (7-in-1 Sensor)")
    print("=" * 65)
    print(f"  Window size       : {WINDOW_SIZE} timestep")
    print(f"  Tong sequence     : {total_seqs:,}")
    print(f"  Tong dong du kien : {total_seqs * WINDOW_SIZE:,}")
    print(f"  Thoi gian mo phong: 2023-2024 (2 nam)")
    print()

    done = 0
    for plant in PLANT_TYPES:
        plant_code = 0 if plant == "tomato" else 1

        for label in labels:
            n_seq  = SEQ_COUNT[label]
            ranges = CONDITIONS[plant][label]

            for seq_idx in range(n_seq):
                # Xác định tháng trong chu kỳ 24 tháng
                month = (seq_global_id % 24) % 12 + 1

                rows = generate_sequence(ranges, month)

                for t_step, row in enumerate(rows):
                    all_records.append({
                        "sequence_id":       seq_global_id,
                        "timestep":          t_step,
                        "timestamp":         current_ts.strftime("%Y-%m-%d %H:%M:%S"),
                        "plant_type":        plant,
                        "plant_type_code":   plant_code,
                        "Soil_Moisture":     row[0],
                        "Soil_Temperature":  row[1],
                        "EC":                row[2],
                        "pH":                row[3],
                        "Nitrogen":          row[4],
                        "Phosphorus":        row[5],
                        "Potassium":         row[6],
                        "label":             label,
                    })
                    current_ts += timedelta(hours=1)

                seq_global_id += 1
                done += 1

                if done % 1000 == 0 or done == total_seqs:
                    pct = done / total_seqs * 100
                    bar = "#" * int(pct // 5) + "." * (20 - int(pct // 5))
                    print(f"  [{bar}] {pct:5.1f}%  -  {done:,}/{total_seqs:,} sequences", end="\r")

    print()
    print(f"\n  [OK] Hoan tat. Tong {len(all_records):,} dong.")
    return pd.DataFrame(all_records)


# ── Thống kê ──────────────────────────────────────────────────────────────────
def print_stats(df: pd.DataFrame):
    print("\n" + "=" * 65)
    print("  [STATS] THONG KE DATASET")
    print("=" * 65)
    print(f"  Tong dong   : {len(df):,}")
    print(f"  Tong seq    : {df['sequence_id'].nunique():,}")
    print(f"  Thoi gian   : {df['timestamp'].iloc[0]}  ->  {df['timestamp'].iloc[-1]}")
    print()

    print("  Phan phoi sequence theo [plant_type x label]:")
    counts = (
        df.groupby(["plant_type", "label"])["sequence_id"]
        .nunique()
        .unstack(level=0)
        .fillna(0)
        .astype(int)
    )
    print(counts.to_string())
    print()

    print("  Thong ke features (toan bo dataset):")
    stat_cols = ["Soil_Moisture", "Soil_Temperature", "EC",
                 "pH", "Nitrogen", "Phosphorus", "Potassium"]
    print(df[stat_cols].describe().round(2).to_string())


# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    df = generate_dataset()
    print_stats(df)

    df.to_csv(OUTPUT_FILE, index=False)
    size_mb = os.path.getsize(OUTPUT_FILE) / 1024 / 1024

    print(f"\n  [SAVED] Da luu : {OUTPUT_FILE}")
    print(f"  Kich thuoc    : {size_mb:.1f} MB")
    print("=" * 65)


if __name__ == "__main__":
    main()
