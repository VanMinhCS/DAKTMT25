import cv2
import time
import threading
import queue
from ..core.logger import get_logger

logger = get_logger("Camera")


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
        logger.info("Camera started (source=%s, %dx%d @ %dfps)",
                    self.config.get('camera_id', 0),
                    self.frame_width, self.frame_height, self.fps)

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)
        if self.cap:
            self.cap.release()
        logger.info("Camera stopped.")

    def add_queue(self, q):
        """Đăng ký một hàng đợi để nhận frame."""
        self.queues.append(q)

    def _init_camera(self):
        cam_id = self.config.get('camera_id', 0)
        try:
            cam_source = int(cam_id)
        except Exception:
            cam_source = cam_id

        # Thử DSHOW trước trên Windows để tránh lỗi MSMF
        import sys
        if sys.platform == "win32":
            self.cap = cv2.VideoCapture(cam_source, cv2.CAP_DSHOW)
            if not self.cap.isOpened():
                logger.warning("DSHOW failed, falling back to default backend...")
                self.cap = cv2.VideoCapture(cam_source)
        else:
            self.cap = cv2.VideoCapture(cam_source)

        if not self.cap.isOpened():
            logger.error("Could not open camera: %s", cam_source)
            return

        # Cấu hình độ phân giải camera
        width  = self.config.get('camera_width',  640)
        height = self.config.get('camera_height', 480)
        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH,  width)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)

        self.frame_width  = int(self.cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.frame_height = int(self.cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.fps          = int(self.cap.get(cv2.CAP_PROP_FPS))
        if self.fps == 0:
            self.fps = 20

    def _capture_loop(self):
        """
        Vòng lặp capture với frame throttle thông minh.

        Thay vì sleep cứng 1/fps (không chính xác, lãng phí CPU),
        ta đo thời gian thực của mỗi vòng lặp và sleep phần còn thiếu.
        Điều này giúp camera không oversaturate queue của AI engine.

        Mỗi frame được .copy() trước khi push để tránh race condition:
        AI engine có thể resize/annotate frame trong khi camera capture frame tiếp theo.
        """
        fps_limit  = self.config.get("camera_fps_limit", 15)
        frame_time = 1.0 / max(1, fps_limit)   # giây/frame theo giới hạn config

        while self.running:
            t_start = time.perf_counter()

            if not self.cap or not self.cap.isOpened():
                time.sleep(1)
                continue

            ret, frame = self.cap.read()
            if not ret:
                logger.warning("Camera read failed. Retrying in 1s...")
                self.cap.release()
                time.sleep(1)
                self._init_camera()
                continue

            # Copy frame trước khi push để tránh race condition với các module
            # có thể annotate/resize trên cùng ndarray (vd: AIEngine, LocalViewer)
            frame_copy = frame.copy()

            # Phân phối frame cho tất cả các hàng đợi đã đăng ký
            for q in self.queues:
                try:
                    q.put_nowait(frame_copy)
                except queue.Full:
                    pass

            # Throttle thông minh: sleep chỉ phần thời gian còn lại
            # Nếu cap.read() đã tốn nhiều thời gian hơn frame_time → không sleep
            elapsed = time.perf_counter() - t_start
            sleep_t = frame_time - elapsed
            if sleep_t > 0:
                time.sleep(sleep_t)
