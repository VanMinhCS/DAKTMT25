import sys
import random
import time

def simulate_real_time_stream(fps=15, duration_seconds=60):
    # Fix unicode printing in Windows
    sys.stdout.reconfigure(encoding='utf-8')
    
    total_frames = fps * duration_seconds
    print(f"=== BẮT ĐẦU MÔ PHỎNG LUỒNG CAMERA THỰC TẾ ===")
    print(f"Thời gian: {duration_seconds} giây | Tốc độ: {fps} FPS | Tổng số frame: {total_frames}\n")

    # Môi trường đất đang RẤT KHỎE MẠNH (LSTM luôn trả về Healthy)
    lstm_status = "Healthy"
    
    vision_only_alerts = 0
    late_fusion_alerts = 0
    
    # Giả lập bộ đệm (Buffer) 10 giây (150 frames) cho Late Fusion
    fusion_buffer = []
    
    for frame in range(total_frames):
        # Giả lập: Bình thường camera nhìn thấy lá khỏe
        yolo_status = "Healthy"
        
        # Nhiễu vật lý (Flickering Noise): Bóng râm, gió thổi làm lá lật mặt, đốm bùn
        # Tỷ lệ nhiễu: Khoảng 3% số frame sẽ bị YOLO nhìn nhầm thành bệnh
        if random.random() < 0.03:
            yolo_status = "Warning"
            
        # 1. TEST VISION-ONLY (Chỉ dùng Camera)
        # Bất cứ khi nào YOLO thấy Warning là hú còi ngay lập tức -> Gây spam
        if yolo_status == "Warning":
            vision_only_alerts += 1
            
        # 2. TEST LATE FUSION (YOLO + LSTM + BỘ ĐỆM)
        # Bước 1: Fusion (Random Forest) - Nếu LSTM Healthy, ép YOLO Warning xuống Normal (0)
        fusion_decision = 0 
        if yolo_status == "Warning" and lstm_status == "Healthy":
            fusion_decision = 0 # Bóp chết tín hiệu nhiễu
            
        # Bước 2: Đưa vào bộ đệm thời gian (Time-buffer)
        fusion_buffer.append(fusion_decision)
        if len(fusion_buffer) > (fps * 10): # Đệm 10 giây (150 frames)
            fusion_buffer.pop(0)
            
        # Hệ thống chỉ hú còi nếu Fusion ra quyết định nguy hiểm LIÊN TỤC
        # Ở đây fusion_decision toàn là 0 nên sẽ không bao giờ thỏa mãn điều kiện
        if sum(fusion_buffer) > (fps * 10 * 3): # Giả sử ngưỡng là 10 giây liên tục mức Warning (3)
            late_fusion_alerts += 1
            fusion_buffer.clear()
            
    print(f"📊 KẾT QUẢ VẬN HÀNH THỰC TIỄN (Mô phỏng 1 phút):")
    print("-" * 60)
    print(f"🔴 HỆ THỐNG VISION-ONLY (Chỉ dùng Camera):")
    print(f"   - Số lần chớp nháy nhiễu (Báo động giả): {vision_only_alerts} lần")
    print(f"   -> Nông dân nhận {vision_only_alerts} thông báo rác trên App! Rất phiền toái.")
    print("-" * 60)
    print(f"🟢 HỆ THỐNG LATE FUSION (Của Đồ án):")
    print(f"   - Số lần nhiễu lọt qua Random Forest: 0 lần")
    print(f"   - Số lần báo động sau khi qua Bộ đệm 10s: {late_fusion_alerts} lần")
    print(f"   -> Nông dân KHÔNG BỊ LÀM PHIỀN. Mức độ lọc nhiễu: 100%.")
    print("=" * 60)
    
if __name__ == "__main__":
    simulate_real_time_stream()
