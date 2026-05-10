import time
import json
import random
import requests
import argparse

# Cấu hình máy chủ nhận (tương ứng với cấu hình trong plant-disease-detect)
TARGET_URL = "http://localhost:5000/api/sensor"

# ── Kịch bản dữ liệu kiểm thử (Test Scenarios) ────────────────────────────

SCENARIOS = {
    "healthy": {
        "description": "Cây phát triển tối ưu, không stress.",
        "ranges": {
            "temperature":   (18.0, 24.0),
            "soil_moisture": (60.0, 80.0),
            "ec":            (1000, 1500),
            "ph":            (6.0, 6.5),
            "nitrogen":             (50, 70),
            "phosphorus":             (35, 50),
            "potassium":             (140, 180),
        }
    },
    "high_stress": {
        "description": "Thiếu nước nghiêm trọng, nhiệt độ cao, dinh dưỡng kém.",
        "ranges": {
            "temperature":   (35.0, 42.0),  # Rất nóng
            "soil_moisture": (15.0, 30.0),  # Đất rất khô
            "ec":            (200, 500),    # Thiếu khoáng
            "ph":            (4.0, 5.0),    # Đất chua
            "nitrogen":             (10, 20),
            "phosphorus":             (5, 15),
            "potassium":             (30, 60),
        }
    },
    "moderate_stress": {
        "description": "Cây hơi thiếu nước hoặc đất hơi phèn.",
        "ranges": {
            "temperature":   (28.0, 32.0),
            "soil_moisture": (40.0, 55.0),
            "ec":            (800, 1000),
            "ph":            (5.0, 5.8),
            "nitrogen":             (30, 45),
            "phosphorus":             (20, 30),
            "potassium":             (90, 120),
        }
    }
}

def generate_sensor_payload(scenario_name="healthy"):
    """Tạo payload JSON ngẫu nhiên dựa theo kịch bản được chọn."""
    scenario = SCENARIOS.get(scenario_name, SCENARIOS["healthy"])
    ranges = scenario["ranges"]
    
    payload = []
    # Gen data và làm tròn 1 chữ số thập phân
    for key, (min_val, max_val) in ranges.items():
        val = round(random.uniform(min_val, max_val), 1)
        # N, P, K thường là số nguyên (mg/kg)
        if key in ["n", "p", "k", "ec"]:
            val = int(val)
            
        # Xác định unit (đơn vị) cho 7 in 1 sensor
        unit = ""
        if key == "temperature": unit = "C"
        elif key == "soil_moisture": unit = "%"
        elif key == "ec": unit = "us/cm"
        elif key in ["n", "p", "k"]: unit = "mg/kg"

        payload.append({
            "type": key,
            "value": val,
            "unit": unit
        })
    return payload

def main():
    parser = argparse.ArgumentParser(description="IoT Sensor Simulator cho Plant Disease Detect")
    parser.add_argument("--scenario", type=str, choices=SCENARIOS.keys(), default="healthy",
                        help="Kịch bản dữ liệu mô phỏng (healthy, high_stress, moderate_stress)")
    parser.add_argument("--interval", type=float, default=2.0,
                        help="Thời gian chờ giữa các lần gửi (giây)")
    args = parser.parse_args()

    print("=" * 60)
    print(" 🌿 IOT SENSOR SIMULATOR CHUYÊN NGHIỆP")
    print("=" * 60)
    print(f"[*] Target URL   : {TARGET_URL}")
    print(f"[*] Scenario     : {args.scenario} -> {SCENARIOS[args.scenario]['description']}")
    print(f"[*] Send Interval: {args.interval} giây")
    print("Nhấn CTRL+C để dừng mô phỏng.\n")

    req_count = 0
    try:
        while True:
            req_count += 1
            payload = generate_sensor_payload(args.scenario)
            
            try:
                response = requests.post(TARGET_URL, json=payload, timeout=3)
                if response.status_code == 200:
                    print(f"[{req_count:04d}] [PASS] Gửi thành công {len(payload)} thông số. | Trạng thái: {response.json().get('status')}")
                else:
                    print(f"[{req_count:04d}] [FAIL] Server trả về mã lỗi: {response.status_code}")
            except requests.exceptions.ConnectionError:
                print(f"[{req_count:04d}] [ERROR] Không thể kết nối tới server. Có chắc main.py đang chạy không?")
            except Exception as e:
                print(f"[{req_count:04d}] [ERROR] Lỗi không xác định: {e}")
                
            time.sleep(args.interval)

    except KeyboardInterrupt:
        print("\n[!] Đã dừng giả lập.")

if __name__ == "__main__":
    main()
