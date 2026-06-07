import cv2
import threading
import queue
from ..core.utils import draw_detection
from ..core.logger import get_logger

logger = get_logger("LocalViewer")

class LocalViewer:
    def __init__(self, config, stop_callback=None):
        self.config = config
        self.running = False
        self.frame_queue = queue.Queue(maxsize=1)
        self.result_queue = queue.Queue(maxsize=1)
        self.thread = None
        self.colors = {}
        self.stop_callback = stop_callback  # Callback để tắt toàn bộ app khi bấm 'q'

    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._view_loop, daemon=True)
        self.thread.start()
        logger.info("Local Viewer started.")

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)
        logger.info("Local Viewer stopped.")

    def _view_loop(self):
        window_name = "YOLO Local Viewer"
        latest_dets = []
        
        while self.running:
            try:
                frame = self.frame_queue.get(timeout=1)
            except queue.Empty:
                continue

            # Copy phòng thủ — tránh race condition nếu camera hoặc module khác
            # cũng đang đọc/ghi trên cùng ndarray
            frame = frame.copy()

            try:
                latest_dets = self.result_queue.get_nowait()
            except queue.Empty:
                pass

            for det in latest_dets:
                draw_detection(frame, det[0], det[1], det[2], det[3], self.colors)

            cv2.imshow(window_name, frame)
            
            if cv2.waitKey(1) & 0xFF == ord('q'):
                logger.info("Quit key pressed on Local Viewer. Shutting down...")
                self.running = False
                if self.stop_callback:
                    self.stop_callback()
                break
                
        # Cleanup
        try:
            cv2.destroyWindow(window_name)
        except Exception:
            pass
