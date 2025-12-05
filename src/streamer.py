import subprocess
import threading
import queue
import time
from .utils import draw_detection

class RTSPStreamer:
    def __init__(self, config):
        self.config = config
        self.running = False
        self.frame_queue = queue.Queue(maxsize=1)
        self.result_queue = queue.Queue(maxsize=1)
        self.thread = None
        self.colors = {} # Cache màu vẽ

    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._stream_loop, daemon=True)
        self.thread.start()
        print("RTSP Streamer started.")

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)

    def _stream_loop(self):
        rtsp_url = f"rtsp://localhost:8554/{self.config.get('rtsp_stream_name', 'mystream')}"
        width = 640 # Default, should be updated from first frame if possible
        height = 480
        fps = 20
        
        # Đợi frame đầu tiên để lấy kích thước
        try:
            first_frame = self.frame_queue.get(timeout=5)
            height, width = first_frame.shape[:2]
        except:
            print("Streamer: No frame received, using defaults.")

        command = [
            'ffmpeg', '-loglevel', 'error', '-y', '-f', 'rawvideo', '-vcodec', 'rawvideo',
            '-pix_fmt', 'bgr24', '-s', f"{width}x{height}",
            '-r', str(fps), '-i', '-',
            '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
            '-preset', 'ultrafast', '-tune', 'zerolatency',
            '-f', 'rtsp', '-rtsp_transport', 'tcp', rtsp_url
        ]

        try:
            p = subprocess.Popen(command, stdin=subprocess.PIPE)
        except Exception as e:
            print(f"FFMPEG Error: {e}")
            return

        latest_dets = []
        
        while self.running:
            try:
                # Lấy frame mới nhất (nếu có)
                try:
                    frame = self.frame_queue.get(timeout=1)
                except queue.Empty:
                    continue

                # Cập nhật kết quả nhận diện mới nhất (nếu có)
                try:
                    latest_dets = self.result_queue.get_nowait()
                except queue.Empty:
                    pass

                # Vẽ lên frame
                for det in latest_dets:
                    # det format: (name, conf, box, cls_id)
                    draw_detection(frame, det[0], det[1], det[2], det[3], self.colors)

                # Đẩy vào ffmpeg
                p.stdin.write(frame.tobytes())
                
            except Exception as e:
                # print(f"Stream Error: {e}")
                continue
        
        if p:
            p.terminate()
