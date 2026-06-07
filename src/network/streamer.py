import subprocess
import threading
import queue
import time
from ..core.utils import draw_detection
from ..core.logger import get_logger

logger = get_logger("Streamer")


class RTSPStreamer:
    def __init__(self, config):
        self.config = config
        self.running = False
        self.frame_queue = queue.Queue(maxsize=1)
        self.result_queue = queue.Queue(maxsize=1)
        self.thread = None
        self.colors = {}  # Cache màu vẽ

    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._stream_loop, daemon=True)
        self.thread.start()
        logger.info("RTSP Streamer started.")

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)
        logger.info("RTSP Streamer stopped.")

    def _stream_loop(self):
        rtsp_url = f"rtsp://localhost:8554/{self.config.get('rtsp_stream_name', 'mystream')}"
        width  = 640
        height = 480
        fps    = self.config.get("camera_fps_limit", 15)   # đồng bộ với camera throttle

        # Đợi frame đầu tiên để lấy kích thước thực tế
        try:
            first_frame = self.frame_queue.get(timeout=5)
            height, width = first_frame.shape[:2]
        except Exception:
            logger.warning("No frame received within 5s. Using default resolution %dx%d.", width, height)

        command = [
            'ffmpeg', '-loglevel', 'error', '-y',
            '-f', 'rawvideo', '-vcodec', 'rawvideo',
            '-pix_fmt', 'bgr24', '-s', f"{width}x{height}",
            '-r', str(fps), '-i', '-',
            '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
            '-preset', 'ultrafast', '-tune', 'zerolatency',
            '-f', 'rtsp', '-rtsp_transport', 'tcp', rtsp_url,
        ]

        try:
            p = subprocess.Popen(command, stdin=subprocess.PIPE)
            logger.info("Streaming to %s", rtsp_url)
        except Exception as e:
            logger.error("FFmpeg launch failed: %s", e)
            return

        latest_dets = []

        while self.running:
            try:
                # Lấy frame mới nhất
                try:
                    frame = self.frame_queue.get(timeout=1)
                except queue.Empty:
                    continue

                # Cập nhật kết quả nhận diện mới nhất (nếu có)
                try:
                    latest_dets = self.result_queue.get_nowait()
                except queue.Empty:
                    pass

                # Vẽ detection lên frame
                for det in latest_dets:
                    draw_detection(frame, det[0], det[1], det[2], det[3], self.colors)

                p.stdin.write(frame.tobytes())

            except Exception as e:
                logger.debug("Stream write error: %s", e)
                continue

        if p:
            p.terminate()
