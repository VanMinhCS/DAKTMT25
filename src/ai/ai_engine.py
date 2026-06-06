"""
AIEngine — Inference YOLO bằng onnxruntime (không cần PyTorch / ultralytics).

Pipeline:
  1. Letterbox resize ảnh → (inference_imgsz × inference_imgsz)
  2. Chuẩn hóa pixel [0, 255] → [0.0, 1.0]
  3. Chuyển HWC → CHW, thêm batch dim → float32
  4. Chạy ONNX session
  5. Lọc confidence + NMS (NumPy thuần)
  6. Giải mã toạ độ về ảnh gốc
"""

import cv2
import numpy as np
import onnxruntime as ort
import threading
import queue
import time
import base64
import uuid
import json
import os
from datetime import datetime
from ..core.utils import draw_detection
from ..core.logger import get_logger
from ..core import metrics

logger = get_logger("AIEngine")


# ── Helpers ──────────────────────────────────────────────────────────────────

def _letterbox(img: np.ndarray, target: int = 640):
    """
    Resize ảnh giữ nguyên tỉ lệ, pad phần còn lại bằng màu xám (114).
    Trả về: (ảnh đã pad, tỉ lệ scale, (pad_left, pad_top))
    """
    h, w = img.shape[:2]
    scale = min(target / h, target / w)
    new_w, new_h = int(round(w * scale)), int(round(h * scale))
    img_resized = cv2.resize(img, (new_w, new_h), interpolation=cv2.INTER_LINEAR)

    canvas = np.full((target, target, 3), 114, dtype=np.uint8)
    pad_left = (target - new_w) // 2
    pad_top  = (target - new_h) // 2
    canvas[pad_top:pad_top + new_h, pad_left:pad_left + new_w] = img_resized
    return canvas, scale, (pad_left, pad_top)


def _preprocess(img: np.ndarray, target: int = 640):
    """Letterbox + chuẩn hóa → float32 tensor [1, 3, H, W]."""
    lb, scale, pad = _letterbox(img, target)
    blob = lb[:, :, ::-1].astype(np.float32) / 255.0   # BGR→RGB, /255
    blob = np.transpose(blob, (2, 0, 1))                # HWC→CHW
    blob = np.expand_dims(blob, axis=0)                 # [1,3,H,W]
    return blob, scale, pad


def _nms(boxes: np.ndarray, scores: np.ndarray, iou_thr: float = 0.45):
    """Non-Maximum Suppression thuần NumPy, trả về list index giữ lại."""
    x1, y1, x2, y2 = boxes[:, 0], boxes[:, 1], boxes[:, 2], boxes[:, 3]
    areas = (x2 - x1 + 1) * (y2 - y1 + 1)
    order = scores.argsort()[::-1]
    keep = []
    while order.size > 0:
        i = order[0]
        keep.append(i)
        xx1 = np.maximum(x1[i], x1[order[1:]])
        yy1 = np.maximum(y1[i], y1[order[1:]])
        xx2 = np.minimum(x2[i], x2[order[1:]])
        yy2 = np.minimum(y2[i], y2[order[1:]])
        w = np.maximum(0.0, xx2 - xx1 + 1)
        h = np.maximum(0.0, yy2 - yy1 + 1)
        inter = w * h
        iou   = inter / (areas[i] + areas[order[1:]] - inter)
        order = order[np.where(iou <= iou_thr)[0] + 1]
    return keep


def _postprocess(output: np.ndarray, conf_thr: float, iou_thr: float,
                 scale: float, pad: tuple, orig_shape: tuple, num_classes: int):
    """
    Giải mã output tensor YOLOv8/v11 dạng [1, 4+num_classes, num_anchors].
    Trả về list (cls_id, conf, (x1, y1, x2, y2)) trên toạ độ ảnh gốc.
    """
    pred = output[0]                        # [4+C, N]
    pred = pred.T                           # [N, 4+C]

    cx, cy, bw, bh = pred[:, 0], pred[:, 1], pred[:, 2], pred[:, 3]
    cls_scores = pred[:, 4:4 + num_classes]

    cls_ids   = cls_scores.argmax(axis=1)
    cls_confs = cls_scores[np.arange(len(cls_ids)), cls_ids]

    mask = cls_confs >= conf_thr
    if not mask.any():
        return []

    cx, cy, bw, bh = cx[mask], cy[mask], bw[mask], bh[mask]
    cls_ids   = cls_ids[mask]
    cls_confs = cls_confs[mask]

    # xywh → xyxy (toạ độ trong không gian letterbox)
    x1 = cx - bw / 2
    y1 = cy - bh / 2
    x2 = cx + bw / 2
    y2 = cy + bh / 2

    keep = _nms(np.stack([x1, y1, x2, y2], axis=1), cls_confs, iou_thr)

    pad_left, pad_top = pad
    orig_h, orig_w = orig_shape[:2]
    results = []
    for i in keep:
        # Bỏ padding, giải mã về ảnh gốc
        rx1 = int((x1[i] - pad_left) / scale)
        ry1 = int((y1[i] - pad_top)  / scale)
        rx2 = int((x2[i] - pad_left) / scale)
        ry2 = int((y2[i] - pad_top)  / scale)

        # Clamp trong giới hạn ảnh gốc
        rx1 = max(0, min(rx1, orig_w - 1))
        ry1 = max(0, min(ry1, orig_h - 1))
        rx2 = max(0, min(rx2, orig_w - 1))
        ry2 = max(0, min(ry2, orig_h - 1))

        results.append((int(cls_ids[i]), float(cls_confs[i]), (rx1, ry1, rx2, ry2)))

    return results


def _load_class_names(model_path: str, session: ort.InferenceSession = None) -> list[str]:
    """
    Tải tên class theo thứ tự ưu tiên:
      0. ONNX metadata (key 'names') — ultralytics tự nhúng khi export
      1. File <model>.json cạnh file ONNX  (key "names" hoặc "class_names")
      2. File classes.txt cùng thư mục
    Trả về list rỗng nếu không tìm thấy → sẽ dùng class id làm fallback.
    """
    import ast

    base      = os.path.splitext(model_path)[0]
    model_dir = os.path.dirname(model_path)

    # 0. ONNX session metadata (nhúng sẵn bởi ultralytics khi export)
    if session is not None:
        try:
            raw = session.get_modelmeta().custom_metadata_map.get("names", "")
            if raw:
                d = ast.literal_eval(raw)          # "{0: 'Apple__Alternaria', ...}"
                if isinstance(d, dict):
                    names = [d[i] for i in range(len(d))]
                    logger.info("Loaded %d class names from ONNX metadata", len(names))
                    return names
        except Exception as e:
            logger.warning("Could not parse ONNX metadata names: %s", e)

    # 1. JSON cạnh ONNX
    json_path = base + ".json"
    if os.path.isfile(json_path):
        try:
            with open(json_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            names = data.get("names") or data.get("class_names")
            if isinstance(names, dict):
                names = [names[str(i)] for i in range(len(names))]
            if names:
                logger.info("Loaded %d class names from %s", len(names), json_path)
                return names
        except Exception as e:
            logger.warning("Could not read class file %s: %s", json_path, e)

    # 2. classes.txt
    txt_path = os.path.join(model_dir, "classes.txt")
    if os.path.isfile(txt_path):
        try:
            with open(txt_path, "r", encoding="utf-8") as f:
                names = [line.strip() for line in f if line.strip()]
            logger.info("Loaded %d class names from %s", len(names), txt_path)
            return names
        except Exception as e:
            logger.warning("Could not read class file %s: %s", txt_path, e)

    return []


# ── Main Class ────────────────────────────────────────────────────────────────

class AIEngine:
    def __init__(self, config, sensor_manager=None):
        self.config         = config
        self.sensor_manager = sensor_manager
        self.session        = None   # ort.InferenceSession
        self.class_names    = []
        self.input_name     = None
        self.num_classes    = 0

        self.running             = False
        self.input_queue         = queue.Queue(maxsize=1)
        self.output_queue        = queue.Queue(maxsize=1)
        self.detection_aggregator = {}
        self.aggregator_lock     = threading.Lock()
        self.colors              = {}
        self.thread              = None
        self.lock                = threading.Lock()

    # ── Lifecycle ─────────────────────────────────────────────────────────────

    def start(self):
        self._load_model()
        self.running = True
        self.thread = threading.Thread(target=self._worker_loop, daemon=True)
        self.thread.start()
        logger.info("AI Engine started.")

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)

    # ── Model Loading ─────────────────────────────────────────────────────────

    def _load_model(self):
        try:
            model_path = self.config.get("model_path", "models/yolo/plant_disease_v4.onnx")

            # Ưu tiên CPUExecutionProvider để nhẹ, không cần CUDA
            providers = ["CPUExecutionProvider"]
            self.session    = ort.InferenceSession(model_path, providers=providers)
            self.input_name = self.session.get_inputs()[0].name

            # Số class = output shape[-2] - 4 (4 cho bbox)
            out_shape = self.session.get_outputs()[0].shape
            # output thường là [1, 4+C, N] hoặc [1, N, 4+C]
            # YOLOv8/v11 xuất [1, 4+C, N] → dim 1 là 4+C
            self.num_classes = int(out_shape[1]) - 4

            self.class_names = _load_class_names(model_path, self.session)
            if not self.class_names:
                logger.warning(
                    "Class names not found — sẽ dùng class id. "
                    "Hãy đặt file %s.json hoặc classes.txt cạnh ONNX.",
                    os.path.splitext(model_path)[0]
                )

            logger.info(
                "ONNX model loaded: %s | classes=%d | provider=%s",
                model_path, self.num_classes, providers[0]
            )
        except Exception as e:
            logger.error("Model load error: %s", e)

    # ── Inference ─────────────────────────────────────────────────────────────

    def _run_inference(self, frame: np.ndarray):
        """
        Chạy một lần inference và trả về list (name, conf, box, cls_id).
        Thread-safe thông qua self.lock.
        """
        imgsz    = self.config.get("inference_imgsz", 640)
        conf_thr = self.config.get("confidence_threshold", 0.65)
        iou_thr  = 0.45

        blob, scale, pad = _preprocess(frame, imgsz)

        with self.lock:
            if self.session is None:
                return []
            _t0 = time.perf_counter()
            output = self.session.run(None, {self.input_name: blob})[0]
            _yolo_ms = (time.perf_counter() - _t0) * 1000.0

        detections = _postprocess(
            output, conf_thr, iou_thr,
            scale, pad, frame.shape, self.num_classes
        )

        results = []
        for cls_id, conf, box in detections:
            name = (
                self.class_names[cls_id]
                if cls_id < len(self.class_names)
                else str(cls_id)
            )
            results.append((name, conf, box, cls_id))

        # ── Ghi metrics (chỉ vào file, không ra terminal) ─────────────────
        num_boxes = len(results)
        avg_conf  = (sum(c for _, c, _, _ in results) / num_boxes) if num_boxes else 0.0
        metrics.log_ai_performance(
            yolo_ms=_yolo_ms,
            num_boxes=num_boxes,
            avg_conf=avg_conf,
        )

        return results

    # ── Worker Loop (camera stream) ───────────────────────────────────────────

    def _worker_loop(self):
        while self.running:
            try:
                frame = self.input_queue.get(timeout=1)
                detections = self._run_inference(frame)

                detections_drawing  = [(n, c, b, i) for n, c, b, i in detections]
                detections_sending  = [(n, c) for n, c, b, i in detections]

                # Đẩy kết quả vẽ ra queue (cho Streamer)
                try:
                    self.output_queue.put_nowait(detections_drawing)
                except queue.Full:
                    pass

                # Cập nhật bộ đếm (cho Network gửi báo cáo định kỳ)
                if detections_sending:
                    with self.aggregator_lock:
                        for name, conf in detections_sending:
                            if name not in self.detection_aggregator:
                                self.detection_aggregator[name] = {"count": 0, "conf_sum": 0.0}
                            self.detection_aggregator[name]["count"] += 1
                            self.detection_aggregator[name]["conf_sum"] += conf

            except queue.Empty:
                continue
            except Exception as e:
                logger.error("AI Worker error: %s", e)

    # ── Public API ────────────────────────────────────────────────────────────

    def get_aggregated_data(self):
        """Lấy dữ liệu đã tổng hợp và reset bộ đếm."""
        with self.aggregator_lock:
            data = self.detection_aggregator.copy()
            self.detection_aggregator.clear()
            return data

    def process_test_image(self, b64_str: str, report_id: str = None):
        """Xử lý ảnh test từ Base64, trả về plant_report dict."""
        try:
            if "," in b64_str:
                b64_str = b64_str.split(",", 1)[1]
            image_bytes = base64.b64decode(b64_str)
            image_np    = np.frombuffer(image_bytes, np.uint8)
            frame       = cv2.imdecode(image_np, cv2.IMREAD_COLOR)

            if frame is None:
                return None

            plant_report = {
                "report_id":           report_id if report_id else str(uuid.uuid4()),
                "plant_name":          "Unknown",
                "plant_disease":       "None",
                "stable_health_status": "No_Detection",
                "detectedAt":          datetime.now().isoformat(),
            }

            detections = self._run_inference(frame)

            best_conf = 0.0
            best_name = None
            for name, conf, box, cls_id in detections:
                draw_detection(frame, name, conf, box, cls_id, self.colors)
                if conf > best_conf:
                    best_conf = conf
                    best_name = name

            if best_name:
                parts  = best_name.split("_", 1)
                p_name = parts[0].lower() if len(parts) == 2 else "Unknown"
                d_name = parts[1].replace("_", " ") if len(parts) == 2 else best_name

                plant_report.update({
                    "plant_name":    p_name,
                    "plant_disease": d_name,
                })
                plant_report["stable_health_status"] = (
                    "Healthy" if "healthy" in best_name.lower() else "Warning"
                )
            # else: giữ nguyên "No_Detection"

            # Encode ảnh kết quả
            ret, buf = cv2.imencode(".jpg", frame)
            if ret:
                b64_res = base64.b64encode(buf).decode("utf-8")
                plant_report["evidence_image"] = f"data:image/jpeg;base64,{b64_res}"

            # Gắn dữ liệu sensor nếu có
            if self.sensor_manager:
                plant_report["sensors"] = self.sensor_manager.get_data()

            return plant_report

        except Exception as e:
            logger.error("Test image processing error: %s", e)
            return None
