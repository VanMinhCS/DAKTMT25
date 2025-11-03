import cv2
import time
import numpy as np
from ultralytics import YOLO
import os
from datetime import datetime
import json
import paho.mqtt.client as mqtt  

class PlantDiseaseDetector:
    def __init__(self, config_path="config.json"):
        # 1. Tải cấu hình từ file config.json
        self.config = self.load_config(config_path)
        
        # 2. Khởi tạo các thuộc tính từ config
        self.model = self.init_model()
        self.cap = self.init_camera()
        
        # Lấy thông số camera để lưu video
        self.frame_width = int(self.cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.frame_height = int(self.cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.camera_fps = int(self.cap.get(cv2.CAP_PROP_FPS))
        
        self.output_video = self.init_video_writer()
        self.colors = {}  # Lưu màu cho từng class
        
        # 3. Khởi tạo client ThingsBoard
        self.tb_client = self.init_thingsboard_client()
        self.last_send_time = 0  # Mốc thời gian để đếm 10s
        
        # 4. Các biến để tính FPS
        self.prev_time = 0
        self.fps_array = []

    def load_config(self, config_path):
        """Tải file JSON config"""
        print(f"Loading config from {config_path}...")
        try:
            with open(config_path, 'r') as f:
                return json.load(f)
        except Exception as e:
            print(f"Error loading config file: {e}")
            exit(1)

    def init_model(self):
        """Khởi tạo model YOLO"""
        print(f"Loading model from {self.config['model_path']}...")
        try:
            model = YOLO(self.config['model_path'])
            print("Model loaded successfully!")
            return model
        except Exception as e:
            print(f"Error loading model: {e}")
            exit(1)

    def init_camera(self):
        """Khởi tạo camera"""
        print(f"Connecting to camera {self.config['camera_id']}...")
        try:
            cap = cv2.VideoCapture(self.config['camera_id'])
            if not cap.isOpened():
                print("Error: Could not connect to camera.")
                exit(1)
            print("Connected to camera.")
            return cap
        except Exception as e:
            print(f"Error initializing camera: {e}")
            exit(1)
            
    def init_video_writer(self):
        """(Tùy chọn) Khởi tạo video writer nếu lưu video"""
        if self.config['save_video']:
            os.makedirs("detections", exist_ok=True)
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_path = f"detections/leaf_disease_{timestamp}.mp4"
            fourcc = cv2.VideoWriter_fourcc(*'mp4v')
            output_video = cv2.VideoWriter(output_path, fourcc, self.camera_fps, (self.frame_width, self.frame_height))
            print(f"Video will be saved to: {output_path}")
            return output_video
        return None

    def init_thingsboard_client(self):
        """Khởi tạo và kết nối tới ThingsBoard qua MQTT"""
        host = self.config['thingsboard_host']
        token = self.config['thingsboard_access_token']
        
        print(f"Connecting to ThingsBoard at {host}...")
        client = mqtt.Client()
        client.username_pw_set(token)  # Access token chính là username
        try:
            client.connect(host, 1883, 60)
            client.loop_start()  # Chạy client ở background
            print("Connected to ThingsBoard successfully!")
            return client
        except Exception as e:
            print(f"Error connecting to ThingsBoard: {e}")
            return None

    def process_frame(self, frame):
        """Xử lý từng khung hình: Nhận diện, vẽ khung và chuẩn bị dữ liệu gửi đi"""
        
        detections_to_send = [] # (MỚI) List chứa các bệnh tìm thấy
        
        # 1. Thực hiện nhận diện
        # Ta truyền conf threshold ngay tại đây
        # Model sẽ CHỈ trả về các kết quả > mức threshold này
        results = self.model(frame, conf=self.config['confidence_threshold'])
        result = results[0]
        boxes = result.boxes

        # 2. Xử lý FPS (nếu bật)
        if self.config['show_fps']:
            current_time = time.time()
            fps = 1.0 / (current_time - self.prev_time) if (current_time - self.prev_time) > 0 else 0
            self.fps_array.append(fps)
            if len(self.fps_array) > 30: self.fps_array.pop(0)
            avg_fps = sum(self.fps_array) / len(self.fps_array)
            self.prev_time = current_time
            cv2.putText(frame, f"FPS: {avg_fps:.1f}", (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

        # 3. Vẽ khung bao và thu thập thông tin
        for box in boxes:
            x1, y1, x2, y2 = box.xyxy[0].cpu().numpy().astype(int)
            cls_id = int(box.cls[0].item())
            class_name = result.names[cls_id]
            confidence = box.conf[0].item()
            
            # (MỚI) Thêm vào list để gửi đi
            detection_data = {
                "disease_name": class_name,
                "confidence": round(confidence, 2),
                "bounding_box": [int(x1), int(y1), int(x2), int(y2)]
            }
            detections_to_send.append(detection_data)
            
            # Vẽ lên frame
            if cls_id not in self.colors:
                self.colors[cls_id] = (np.random.randint(0, 255), np.random.randint(0, 255), np.random.randint(0, 255))
            color = self.colors[cls_id]
            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
            
            label = f"{class_name} ({confidence:.2f})"
            text_size = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 2)[0]
            cv2.rectangle(frame, (x1, y1 - text_size[1] - 10), (x1 + text_size[0], y1), color, -1)
            cv2.putText(frame, label, (x1, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2)
            
        # Hiển thị tổng số phát hiện
        num_detections = len(boxes)
        detection_text = f"Detections: {num_detections} leaf diseases"
        cv2.putText(frame, detection_text, (20, self.frame_height - 20), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2)
        
        return frame, detections_to_send

    def send_to_thingsboard(self, detections):
        """Gửi dữ liệu lên ThingsBoard nếu có phát hiện và đủ 10s"""
        current_time = time.time()
        
        # Chỉ gửi khi CÓ phát hiện VÀ đã qua 10s kể từ lần gửi trước
        if detections and (current_time - self.last_send_time) > self.config['send_interval_seconds']:
            if self.tb_client:
                # Gói dữ liệu telemetry
                # Gửi số lượng bệnh và danh sách bệnh (dưới dạng JSON string)
                payload_data = {
                    "disease_count": len(detections),
                    "detection_list": json.dumps(detections) 
                }
                
                # Convert sang JSON payload
                payload = json.dumps(payload_data)
                
                # Publish lên topic telemetry
                self.tb_client.publish('v1/devices/me/telemetry', payload)
                
                print(f"Sent {len(detections)} detection(s) to ThingsBoard.")
                
                # Cập nhật lại mốc thời gian
                self.last_send_time = current_time
            else:
                print("ThingsBoard client not connected. Skipping send.")

    def run(self):
        """Vòng lặp chính của chương trình"""
        print("Starting detection... Press 'q' to quit, 's' to take a snapshot")
        try:
            while True:
                ret, frame = self.cap.read()
                if not ret:
                    print("Could not read frame from camera.")
                    break
                
                # Xử lý frame và lấy kết quả
                processed_frame, detections = self.process_frame(frame)
                
                # (MỚI) Gửi dữ liệu lên server (nếu đủ điều kiện)
                self.send_to_thingsboard(detections)
                
                # Hiển thị frame
                cv2.imshow("Plant Disease Detection", processed_frame)
                
                # Lưu video (nếu bật)
                if self.output_video:
                    self.output_video.write(processed_frame)
                    
                # Xử lý phím bấm
                key = cv2.waitKey(1) & 0xFF
                if key == ord('q'):
                    print("Exiting...")
                    break
                elif key == ord('s'):
                    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                    os.makedirs("snapshots", exist_ok=True)
                    snapshot_path = f"snapshots/leaf_{timestamp}.jpg"
                    cv2.imwrite(snapshot_path, frame)
                    print(f"Snapshot saved to: {snapshot_path}")

        except KeyboardInterrupt:
            print("Program interrupted by user.")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
        finally:
            self.cleanup() # Đảm bảo dọn dẹp tài nguyên

    def cleanup(self):
        """Dọn dẹp tài nguyên khi kết thúc"""
        print("Cleaning up resources...")
        if self.cap:
            self.cap.release()
        if self.output_video:
            self.output_video.release()
        if self.tb_client:
            self.tb_client.loop_stop() # Dừng background loop
            self.tb_client.disconnect()
        cv2.destroyAllWindows()
        print("Camera closed and resources released.")

# (MỚI) Cách chạy
if __name__ == "__main__":
    detector = PlantDiseaseDetector(config_path="config.json")
    detector.init_thingsboard_client()