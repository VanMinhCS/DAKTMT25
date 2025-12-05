import cv2
import time
import threading
import queue

class Camera:
    def __init__(self, config):
        self.config = config
        self.cap = None
        self.running = False
        self.frame_width = 640
        self.frame_height = 480
        self.fps = 20
        self.thread = None
        
        # Queues để phân phối frame cho các module khác
        self.queues = [] 

    def start(self):
        self._init_camera()
        self.running = True
        self.thread = threading.Thread(target=self._capture_loop, daemon=True)
        self.thread.start()
        print("Camera started.")

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)
        if self.cap:
            self.cap.release()

    def add_queue(self, q):
        """Đăng ký một hàng đợi để nhận frame"""
        self.queues.append(q)

    def _init_camera(self):
        cam_id = self.config.get('camera_id', 0)
        try:
            cam_source = int(cam_id)
        except:
            cam_source = cam_id
            
        self.cap = cv2.VideoCapture(cam_source)
        if not self.cap.isOpened():
            print(f"Error: Could not open camera {cam_source}")
            return

        # Cấu hình độ phân giải camera
        width = self.config.get('camera_width', 640)
        height = self.config.get('camera_height', 480)
        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, width)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)

        self.frame_width = int(self.cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.frame_height = int(self.cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.fps = int(self.cap.get(cv2.CAP_PROP_FPS))
        if self.fps == 0: self.fps = 20

    def _capture_loop(self):
        while self.running:
            if not self.cap or not self.cap.isOpened():
                time.sleep(1)
                self._init_camera()
                continue

            ret, frame = self.cap.read()
            if not ret:
                print("Camera read failed. Retrying...")
                self.cap.release()
                time.sleep(1)
                continue

            # Phân phối frame cho tất cả các hàng đợi đã đăng ký
            for q in self.queues:
                try:
                    q.put_nowait(frame)
                except queue.Full:
                    pass
            
            time.sleep(1/self.fps)
