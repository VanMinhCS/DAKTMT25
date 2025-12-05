import cv2
import numpy as np
from ultralytics import YOLO
import threading
import queue
import base64
import uuid
from datetime import datetime
from .utils import draw_detection

class AIEngine:
    def __init__(self, config, sensor_manager=None):
        self.config = config
        self.sensor_manager = sensor_manager
        self.model = None
        self.running = False
        self.input_queue = queue.Queue(maxsize=1)
        self.output_queue = queue.Queue(maxsize=1) # Để gửi kết quả vẽ ra ngoài (cho streamer)
        self.detection_aggregator = {} # Để đếm số lượng phát hiện (cho báo cáo định kỳ)
        self.aggregator_lock = threading.Lock()
        self.colors = {}
        self.thread = None
        self.lock = threading.Lock() # Lock cho model

    def start(self):
        self._load_model()
        self.running = True
        self.thread = threading.Thread(target=self._worker_loop, daemon=True)
        self.thread.start()
        print("AI Engine started.")

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)

    def _load_model(self):
        try:
            model_path = self.config.get('model_path', 'plant_disease.pt')
            self.model = YOLO(model_path)
            print(f"Model loaded: {model_path}")
        except Exception as e:
            print(f"Model Load Error: {e}")

    def _worker_loop(self):
        while self.running:
            try:
                frame = self.input_queue.get(timeout=1)
                detections_drawing = []
                detections_sending = []

                with self.lock:
                    if self.model:
                        # Sử dụng imgsz từ config
                        imgsz = self.config.get('inference_imgsz', 480)
                        results = self.model(frame, conf=self.config.get('confidence_threshold', 0.5), imgsz=imgsz, verbose=False)
                        result = results[0]
                        for box in result.boxes:
                            x1, y1, x2, y2 = box.xyxy[0].cpu().numpy().astype(int)
                            cls_id = int(box.cls[0].item())
                            name = result.names[cls_id]
                            conf = float(box.conf[0].item())
                            
                            detections_drawing.append((name, conf, (x1, y1, x2, y2), cls_id))
                            detections_sending.append(name)

                # Đẩy kết quả vẽ ra queue (cho Streamer vẽ)
                try:
                    self.output_queue.put_nowait(detections_drawing)
                except queue.Full:
                    pass

                # Cập nhật bộ đếm (cho Network gửi báo cáo)
                if detections_sending:
                    with self.aggregator_lock:
                        for name in detections_sending:
                            self.detection_aggregator[name] = self.detection_aggregator.get(name, 0) + 1

            except queue.Empty:
                continue
            except Exception as e:
                print(f"AI Worker Error: {e}")

    def get_aggregated_data(self):
        """Lấy dữ liệu đã tổng hợp và reset bộ đếm"""
        with self.aggregator_lock:
            data = self.detection_aggregator.copy()
            self.detection_aggregator.clear()
            return data

    def process_test_image(self, b64_str):
        """Xử lý ảnh test từ Base64"""
        try:
            if ',' in b64_str:
                b64_str = b64_str.split(',', 1)[1]
            image_bytes = base64.b64decode(b64_str)
            image_np = np.frombuffer(image_bytes, np.uint8)
            frame = cv2.imdecode(image_np, cv2.IMREAD_COLOR)
            
            if frame is None:
                return None

            plant_report = {
                "report_id": str(uuid.uuid4()),
                "plant_name": "Unknown",
                "plant_disease": "None",
                "stable_health_status": "Checking",
                "detectedAt": datetime.now().isoformat()
            }

            best_conf = 0
            best_name = None

            with self.lock:
                if self.model:
                    imgsz = self.config.get('inference_imgsz', 480)
                    results = self.model(frame, conf=self.config.get('confidence_threshold', 0.5), imgsz=imgsz, verbose=False)[0]
                    for box in results.boxes:
                        x1, y1, x2, y2 = box.xyxy[0].cpu().numpy().astype(int)
                        cls = int(box.cls[0])
                        conf = float(box.conf[0])
                        name = results.names[cls]
                        
                        if conf > best_conf:
                            best_conf = conf
                            best_name = name
                        
                        draw_detection(frame, name, conf, (x1, y1, x2, y2), cls, self.colors)

            if best_name:
                parts = best_name.split('_', 1)
                p_name = parts[0].lower() if len(parts)==2 else "Unknown"
                d_name = parts[1].replace('_', ' ') if len(parts)==2 else best_name
                
                plant_report.update({
                    "plant_name": p_name,
                    "plant_disease": d_name,
                })
                
                if "healthy" in best_name.lower():
                    plant_report["stable_health_status"] = "Healthy"
                else:
                    plant_report["stable_health_status"] = "Warning"

            # Encode lại ảnh kết quả
            ret, buf = cv2.imencode('.jpg', frame)
            if ret:
                b64_res = base64.b64encode(buf).decode('utf-8')
                plant_report["evidence_image"] = f"data:image/jpeg;base64,{b64_res}"

            return {
                "image_report": {
                    "deviceId": self.config.get("deviceId"),
                    "plantId": self.config.get("plantId"),
                    "plant": plant_report,
                    "sensors": self.sensor_manager.get_data() if self.sensor_manager else []
                }
            }
        except Exception as e:
            print(f"Test Image Processing Error: {e}")
            return None
