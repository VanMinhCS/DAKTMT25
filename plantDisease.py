import cv2
import time
import numpy as np
from ultralytics import YOLO
import os
from datetime import datetime
import json
import paho.mqtt.client as mqtt
import sys
import requests
import zipfile
import threading
import queue
import subprocess
import base64
import re
import random
import uuid

# --- KHỞI TẠO BIẾN TOÀN CỤC ---
detector = None

class PlantDiseaseDetector:
    def __init__(self, config_path="config.json"):
        self.config = self.load_config(config_path)
        self.model = self.init_model()
        self.cap = self.init_camera()
        
        self.frame_width = int(self.cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.frame_height = int(self.cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.camera_fps = int(self.cap.get(cv2.CAP_PROP_FPS))
        if self.camera_fps == 0: self.camera_fps = 20
        
        self.colors = {}
        self.prev_time = 0
        self.fps_array = []
        
        self.frame_queue_ai = queue.Queue(maxsize=1)
        self.frame_queue_stream = queue.Queue(maxsize=1)
        self.results_queue = queue.Queue(maxsize=1)
        self.running = True
        
        self.ai_lock = threading.Lock() 
        self.tb_client = self.init_thingsboard_client()
        self.current_version = self.config.get('current_version', 'v1.0')
        
        self.detection_aggregator = {} 
        self.aggregator_lock = threading.Lock()
        
        # (ĐÃ XÓA) Các biến lưu ảnh bằng chứng cho luồng Camera
        self.real_sensor_data = []
        
        self.camera_thread = threading.Thread(target=self._camera_loop, daemon=True)
        self.ai_thread = threading.Thread(target=self._ai_worker_loop, daemon=True)
        self.network_thread = threading.Thread(target=self._network_loop, daemon=True)
        self.rtsp_thread = threading.Thread(target=self._rtsp_loop, daemon=True)
        
        print("Starting background threads...")
        self.camera_thread.start()
        self.ai_thread.start()
        self.network_thread.start()
        self.rtsp_thread.start()

    # --- INIT FUNCTIONS ---
    def load_config(self, config_path):
        try:
            with open(config_path, 'r') as f: return json.load(f)
        except Exception as e: print(f"Config Error: {e}"); exit(1)

    def init_model(self):
        try: return YOLO(self.config['model_path'])
        except Exception as e: print(f"Model Error: {e}"); exit(1)

    def init_camera(self):
        cam_id = self.config['camera_id']
        try: cam_source = int(cam_id)
        except: cam_source = cam_id
        cap = cv2.VideoCapture(cam_source)
        if not cap.isOpened(): print("Cam Error"); exit(1)
        return cap
            
    def init_thingsboard_client(self):
        host = self.config['thingsboard_host']
        token = self.config['thingsboard_access_token']
        client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2)
        client.on_connect = self.on_tb_connect
        client.on_message = self.on_tb_message 
        client.username_pw_set(token)
        try:
            client.connect(host, 1883, 60)
            client.loop_start()
            print("Connected to ThingsBoard!")
            return client
        except: return None

    # --- TASK 1: CAMERA ---
    def _camera_loop(self):
        while self.running:
            ret, frame = self.cap.read()
            if not ret: self.running = False; break
            try: self.frame_queue_ai.put_nowait(frame)
            except queue.Full: pass 
            try: self.frame_queue_stream.put_nowait(frame)
            except queue.Full: pass
            time.sleep(1/self.camera_fps)

    # --- TASK 2: AI (Chỉ đếm số liệu) ---
    def _ai_worker_loop(self):
        while self.running:
            try:
                frame = self.frame_queue_ai.get(timeout=1)
                detections_drawing = []
                detections_sending = [] 

                if self.ai_lock.acquire(blocking=False):
                    try:
                        results = self.model(frame, conf=self.config['confidence_threshold'], verbose=False)
                        result = results[0]
                        for box in result.boxes:
                            x1, y1, x2, y2 = box.xyxy[0].cpu().numpy().astype(int)
                            cls_id = int(box.cls[0].item())
                            name = result.names[cls_id]
                            conf = float(box.conf[0].item())
                            
                            detections_drawing.append((name, conf, (x1, y1, x2, y2), cls_id))
                            detections_sending.append(name)
                    finally:
                        self.ai_lock.release()
                
                try: self.results_queue.put_nowait(detections_drawing)
                except queue.Full: pass 
                
                # Chỉ cập nhật bộ đếm, KHÔNG lưu ảnh nữa
                if detections_sending:
                    with self.aggregator_lock:
                        for name in detections_sending:
                            self.detection_aggregator[name] = self.detection_aggregator.get(name, 0) + 1

            except queue.Empty: continue 
            except Exception as e: print(f"AI Error: {e}")

    # --- TASK 3: NETWORK ---
    def _network_loop(self):
        while self.running:
            for _ in range(self.config.get('send_interval_seconds', 10)):
                if not self.running: break
                time.sleep(1)
            if not self.running: break
            try:
                self._send_stable_detections()
                self._check_ota_periodically()
            except Exception as e: print(f"Net Error: {e}")

    # --- TASK 4: RTSP ---
    def _rtsp_loop(self):
        rtsp_url = f"rtsp://localhost:8554/{self.config.get('rtsp_stream_name', 'mystream')}"
        command = [
            'ffmpeg', '-loglevel', 'error', '-y', '-f', 'rawvideo', '-vcodec', 'rawvideo',
            '-pix_fmt', 'bgr24', '-s', f"{self.frame_width}x{self.frame_height}",
            '-r', str(self.camera_fps), '-i', '-',
            '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
            '-preset', 'ultrafast', '-tune', 'zerolatency',
            '-f', 'rtsp', '-rtsp_transport', 'tcp', rtsp_url
        ]
        try: p = subprocess.Popen(command, stdin=subprocess.PIPE)
        except: print("FFMPEG Error"); self.running = False; return
            
        latest_dets = []
        while self.running:
            try:
                frame = self.frame_queue_stream.get(timeout=2)
                try: latest_dets = self.results_queue.get_nowait()
                except queue.Empty: pass 
                processed = self.draw_detections(frame, latest_dets)
                p.stdin.write(processed.tobytes())
            except: continue
        if p: p.terminate()

    # --- SEND REPORT (DATA ONLY) ---
    def _send_stable_detections(self):
        """Gửi báo cáo định kỳ (KHÔNG ẢNH)"""
        plant_report = {
            "report_id": str(uuid.uuid4()),
            "plant_name": "Unknown",
            "plant_disease": "None",
            "stable_health_status": "Checking",
            "detectedAt": datetime.now().isoformat()
        }
        
        with self.aggregator_lock:
            if not self.detection_aggregator:
                plant_report["stable_health_status"] = "Checking"
            else:
                best_class = max(self.detection_aggregator, key=self.detection_aggregator.get)
                count = self.detection_aggregator[best_class]
                CONF_THRESH = 5
                
                parts = best_class.split('_', 1)
                p_name = parts[0].lower() if len(parts)==2 else "Unknown"
                d_name = parts[1].replace('_', ' ') if len(parts)==2 else best_class
                
                plant_report.update({
                    "plant_name": p_name,
                    "plant_disease": d_name,
                    "debug_detection_count": count
                })

                if "healthy" in best_class.lower():
                    plant_report["stable_health_status"] = "Healthy"
                elif count >= CONF_THRESH:
                    plant_report["stable_health_status"] = "Warning"
                else:
                    plant_report["stable_health_status"] = "Checking"

            self.detection_aggregator.clear()
            # (ĐÃ XÓA) Logic xử lý ảnh

        # Gói Payload
        full_payload = {
            "device_report": {
                "deviceId": self.config.get("deviceId"),
                "plantId": self.config.get("plantId"),
                "plant": plant_report,
                "sensors": self._get_sensor_data()
            }
        }
        
        if self.tb_client:
            self.tb_client.publish('v1/devices/me/telemetry', json.dumps(full_payload))
            print(f"Sent Data Report: {plant_report['stable_health_status']}")

    def _get_sensor_data(self):
        if self.real_sensor_data: return self.real_sensor_data
        return [
            {"type": "temperature", "value": round(random.uniform(25, 32), 1), "unit": "C"},
            {"type": "humidity", "value": round(random.uniform(60, 85), 1), "unit": "%"},
            {"type": "soil_moisture", "value": round(random.uniform(40, 70), 1), "unit": "%"}
        ]

    # --- XỬ LÝ ẢNH TEST TỪ ATTRIBUTE (CÓ ẢNH) ---
    def _handle_attribute_message(self, msg):
        try:
            data = json.loads(msg.payload.decode())
            data = data.get('shared', data)
            if data.get('target_version'):
                self.check_for_updates(data.get('target_version'), data.get('firmware_url'))
            
            # Xử lý Test Ảnh (Upload từ Widget)
            if data.get('Image'):
                threading.Thread(target=self._process_b64, args=(data['Image'],), daemon=True).start()
        except: pass

    def _process_b64(self, b64_str):
        """Xử lý ảnh test từ Shared Attribute và trả về kết quả theo format Camera"""
        try:
            if ',' in b64_str: b64_str = b64_str.split(',', 1)[1]
            image_bytes = base64.b64decode(b64_str)
            image_np = np.frombuffer(image_bytes, np.uint8)
            frame = cv2.imdecode(image_np, cv2.IMREAD_COLOR)
            
            # Chạy AI
            result_data = self._run_test_ai_and_get_report(frame)
            
            # Gửi kết quả lên Telemetry (Format giống hệt Camera nhưng có thêm ảnh)
            self.tb_client.publish('v1/devices/me/telemetry', json.dumps(result_data))
            print("Sent Test Image Report to ThingsBoard.")
            
        except Exception as e:
            print(f"Test Error: {e}")

    def _run_test_ai_and_get_report(self, frame):
        """Chạy AI 1 lần và tạo báo cáo full (kèm ảnh)"""
        plant_report = {
            "report_id": str(uuid.uuid4()),
            "plant_name": "Unknown",
            "plant_disease": "None",
            "stable_health_status": "Checking",
            "detectedAt": datetime.now().isoformat()
        }
        
        best_conf = 0
        best_name = None
        
        with self.ai_lock:
            results = self.model(frame, conf=self.config['confidence_threshold'], verbose=False)[0]
            # Vẽ lên frame luôn
            for box in results.boxes:
                x1,y1,x2,y2 = box.xyxy[0].cpu().numpy().astype(int)
                cls = int(box.cls[0])
                conf = float(box.conf[0])
                name = results.names[cls]
                
                # Tìm box có confidence cao nhất
                if conf > best_conf:
                    best_conf = conf
                    best_name = name
                
                self.draw_detections_for_test(frame, (name, conf, (x1,y1,x2,y2), cls))
        
        # Xử lý kết quả
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
        
        # Encode ảnh kết quả
        try:
            ret, buf = cv2.imencode('.jpg', frame)
            if ret:
                b64 = base64.b64encode(buf).decode('utf-8')
                plant_report["evidence_image"] = f"data:image/jpeg;base64,{b64}"
        except: pass
        
        # Tạo payload device_report chuẩn
        return {
            "image_report": {
                "deviceId": self.config.get("deviceId"),
                "plantId": self.config.get("plantId"),
                "plant": plant_report,
                "sensors": self._get_sensor_data()
            }
        }

    # --- MQTT HANDLERS ---
    def on_tb_connect(self, client, userdata, flags, rc, properties=None):
        if rc == 0:
            client.subscribe('v1/devices/me/attributes')
            client.publish('v1/devices/me/attributes/request/1', '{"sharedKeys":"target_version,firmware_url"}')

    def on_tb_message(self, client, userdata, msg):
        if msg.topic.startswith('v1/devices/me/attributes'):
            self._handle_attribute_message(msg)

    def check_for_updates(self, ver, url):
        # (Logic OTA giữ nguyên)
        if ver != self.current_version:
            try:
                r = requests.get(url, timeout=60); r.raise_for_status()
                with open("update.zip", "wb") as f: f.write(r.content)
                with zipfile.ZipFile("update.zip", 'r') as z: z.extractall(".")
                os.remove("update.zip")
                self.cleanup(restarting=True)
                os.execv(sys.executable, ['python'] + sys.argv)
            except: pass

    # --- DRAWING ---
    def draw_detections_for_test(self, frame, detection_data):
        (name, conf, (x1,y1,x2,y2), cls) = detection_data
        if cls not in self.colors:
            self.colors[cls] = (random.randint(0,255), random.randint(0,255), random.randint(0,255))
        color = self.colors[cls]
        
        # 1. Vẽ khung
        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        
        # 2. Chuẩn bị chữ
        label = f"{name} ({conf:.2f})"
        (text_w, text_h), baseline = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 1)
        
        # 3. Tính tọa độ (Fix lỗi lệch)
        box_x1 = x1
        box_y2 = y1
        box_y1 = y1 - text_h - 10
        text_y = y1 - 5
        
        # Nếu tràn mép trên -> Đẩy vào trong
        if box_y1 < 0:
            box_y1 = y1
            box_y2 = y1 + text_h + 10
            text_y = y1 + text_h + 5
            
        # Nếu tràn mép phải -> Đẩy sang trái
        if box_x1 + text_w > frame.shape[1]:
            box_x1 = frame.shape[1] - text_w
        
        # 4. Vẽ
        cv2.rectangle(frame, (box_x1, box_y1), (box_x1 + text_w, box_y2), color, -1)
        cv2.putText(frame, label, (box_x1, text_y), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,255,255), 1)
        
        return frame

    def draw_detections(self, frame, detections):
        if self.config['show_fps']:
            t = time.time()
            fps = 1.0 / (t - self.prev_time) if (t - self.prev_time) > 0 else 0
            self.prev_time = t
            cv2.putText(frame, f"FPS: {fps:.1f}", (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0,255,0), 2)
        for d in detections: self.draw_detections_for_test(frame, d)
        return frame

    def cleanup(self, restarting=False):
        self.running = False
        if self.camera_thread.is_alive(): self.camera_thread.join(timeout=1)
        if self.ai_thread.is_alive(): self.ai_thread.join(timeout=1)
        if self.network_thread.is_alive(): self.network_thread.join(timeout=1)
        if hasattr(self, 'rtsp_thread') and self.rtsp_thread.is_alive(): self.rtsp_thread.join(timeout=1)
        if self.cap: self.cap.release()
        if self.tb_client: self.tb_client.disconnect()
        cv2.destroyAllWindows()
        if not restarting: print("Exited.")

if __name__ == "__main__":
    print("Initializing...")
    detector = PlantDiseaseDetector(config_path="config.json")
    print("Running... Press Ctrl+C to stop.")
    try:
        while detector.running: time.sleep(1)
    except KeyboardInterrupt:
        detector.cleanup()