import csv
import math
import random
import os
from datetime import datetime, timedelta

# ══════════════════════════════════════════════════════════════════════════════
# Cấu hình Sinh Dữ Liệu
# ══════════════════════════════════════════════════════════════════════════════

YEARS_TO_SIMULATE = 3
TOTAL_HOURS = YEARS_TO_SIMULATE * 365 * 24
START_DATE = datetime(2023, 1, 1, 0, 0, 0)
OUTPUT_FILE = "data/synthetic_crop_data.csv"

# Các Nhãn (Labels) - Phải khớp với 9 classes của LSTM trong alert_engine
LABELS = [
    "Healthy",
    "Bacterial_Spot_Risk", "Early_Blight_Risk", "Late_Blight_Risk", "Leaf_Mold_Risk",
    "N_Deficient", "P_Deficient", "K_Deficient", "Fe_Deficient"
]

# ══════════════════════════════════════════════════════════════════════════════
# Các Ngưỡng Nông học Lý tưởng (Baseline cho Healthy) - Cà chua/Khoai tây
# ══════════════════════════════════════════════════════════════════════════════

def get_healthy_baseline(hour_of_day):
    """
    Sinh giá trị lý tưởng theo chu kỳ ngày/đêm (sử dụng hàm lượng giác).
    """
    # Nhiệt độ: Thấp nhất lúc 4h sáng (18°C), cao nhất lúc 14h chiều (28°C)
    # Hàm sin chu kỳ 24h, lệch pha cho đúng thời điểm
    temp_base = 23.0 + 5.0 * math.sin((hour_of_day - 8) * math.pi / 12)
    
    # Độ ẩm: Dao động nhẹ theo nhiệt độ (nóng thì khô hơn, lạnh thì ẩm hơn)
    moisture_base = 75.0 - 10.0 * math.sin((hour_of_day - 8) * math.pi / 12)
    
    # NPK, pH, EC: Dao động rất nhẹ, không phụ thuộc nhiều vào giờ trong ngày
    ec_base = 1500.0
    ph_base = 6.2
    n_base = 130.0
    p_base = 55.0
    k_base = 210.0
    
    return {
        "Soil_Temperature": temp_base,
        "Soil_Moisture": moisture_base,
        "EC": ec_base,
        "pH": ph_base,
        "Nitrogen": n_base,
        "Phosphorus": p_base,
        "Potassium": k_base
    }

def add_noise(value, noise_percent=0.03):
    """Thêm nhiễu trắng (Gaussian-like) vào dữ liệu."""
    noise = value * noise_percent
    return value + random.uniform(-noise, noise)

# ══════════════════════════════════════════════════════════════════════════════
# Engine Giả lập
# ══════════════════════════════════════════════════════════════════════════════

def generate_dataset():
    os.makedirs("data", exist_ok=True)
    
    print(f"Bat dau sinh du lieu mo phong trong {YEARS_TO_SIMULATE} nam...")
    
    with open(OUTPUT_FILE, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow([
            "timestamp", "Soil_Moisture", "Soil_Temperature", 
            "EC", "pH", "Nitrogen", "Phosphorus", "Potassium", "Label"
        ])
        
        current_time = START_DATE
        
        # State để theo dõi các chuỗi sự kiện dài ngày
        current_event = "Healthy"
        event_hours_left = 0
        
        # Biến tích lũy cho sự kiện (để tạo sự suy giảm từ từ)
        stress_factor = 0.0
        
        label_counts = {lbl: 0 for lbl in LABELS}
        
        for step in range(TOTAL_HOURS):
            hour_of_day = current_time.hour
            
            # 1. Nếu đang không có sự kiện gì (Healthy), thỉnh thoảng kích hoạt sự kiện
            if event_hours_left <= 0:
                # 90% thời gian là Healthy, 10% bắt đầu sự kiện
                if random.random() < 0.05:  # Tỉ lệ có sự kiện
                    current_event = random.choice(LABELS[1:]) # Chọn 1 trong 8 nhãn bất thường
                    event_hours_left = random.randint(48, 120) # Kéo dài 2 đến 5 ngày
                    stress_factor = 0.0
                else:
                    current_event = "Healthy"
                    event_hours_left = 1
            
            # 2. Lấy baseline
            base = get_healthy_baseline(hour_of_day)
            
            # 3. Ép kiểu dữ liệu theo sự kiện (Inject Anomalies)
            if current_event != "Healthy":
                # Stress factor tăng dần từ 0 đến 1, rồi giữ ở 1 để thể hiện bệnh nặng dần
                stress_factor = min(1.0, stress_factor + 0.02)
                
                if current_event == "N_Deficient":
                    base["Nitrogen"] -= 60 * stress_factor
                elif current_event == "P_Deficient":
                    base["Phosphorus"] -= 30 * stress_factor
                elif current_event == "K_Deficient":
                    base["Potassium"] -= 100 * stress_factor
                elif current_event == "Fe_Deficient":
                    # Sắt khó hấp thụ khi pH quá cao (>7.5)
                    base["pH"] += 1.5 * stress_factor
                    base["EC"] -= 300 * stress_factor
                    
                elif current_event in ["Bacterial_Spot_Risk", "Early_Blight_Risk", "Late_Blight_Risk", "Leaf_Mold_Risk"]:
                    # Đặc trưng chung của bệnh nấm/vi khuẩn: Độ ẩm siêu cao, nhiệt độ phù hợp
                    # Ép độ ẩm lên mức 85-95%
                    base["Soil_Moisture"] = 80 + 15 * stress_factor
                    
                    if current_event == "Late_Blight_Risk":
                        # Mốc sương muộn thích lạnh (15-20 độ)
                        base["Soil_Temperature"] = 18 + random.uniform(-2, 2)
                    elif current_event == "Early_Blight_Risk":
                        # Mốc sương sớm thích ấm (24-29 độ)
                        base["Soil_Temperature"] = 26 + random.uniform(-2, 2)
                    # (Các bệnh khác tạm dùng đặc điểm độ ẩm cao)

            # 4. Thêm nhiễu ngẫu nhiên cho tất cả
            row = [
                current_time.strftime("%Y-%m-%d %H:%M:%S"),
                round(add_noise(base["Soil_Moisture"], 0.05), 2),
                round(add_noise(base["Soil_Temperature"], 0.05), 2),
                round(add_noise(base["EC"], 0.03), 1),
                round(add_noise(base["pH"], 0.02), 2),
                round(add_noise(base["Nitrogen"], 0.04), 1),
                round(add_noise(base["Phosphorus"], 0.04), 1),
                round(add_noise(base["Potassium"], 0.04), 1),
                current_event
            ]
            
            # Ghi vào file
            writer.writerow(row)
            
            # Thống kê & Chuyển bước
            label_counts[current_event] += 1
            event_hours_left -= 1
            current_time += timedelta(hours=1)
            
            if (step + 1) % 5000 == 0:
                print(f"Da sinh {step + 1}/{TOTAL_HOURS} dong...")

    print("\n[HOAN TAT] Dataset da duoc luu tai:", OUTPUT_FILE)
    print("\nThong ke phan bo nhan (Label Distribution):")
    for lbl, count in label_counts.items():
        pct = (count / TOTAL_HOURS) * 100
        print(f"  - {lbl.ljust(20)}: {count} mau ({pct:.1f}%)")

if __name__ == "__main__":
    generate_dataset()
