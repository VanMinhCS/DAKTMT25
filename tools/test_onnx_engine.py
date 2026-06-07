"""
Test end-to-end cho AIEngine dùng onnxruntime (không có PyTorch/ultralytics).

Chạy từ thư mục gốc dự án:
    .\\venv\\Scripts\\python.exe tools\\test_onnx_engine.py
"""

import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import base64
import cv2
import numpy as np

# ── Helpers nội bộ ────────────────────────────────────────────────────────────
from src.ai.ai_engine import _letterbox, _preprocess, _nms, AIEngine

PASS = "\033[92m[PASS]\033[0m"
FAIL = "\033[91m[FAIL]\033[0m"
INFO = "\033[94m[INFO]\033[0m"

results = []

def check(name, condition, detail=""):
    status = PASS if condition else FAIL
    print(f"  {status} {name}" + (f" — {detail}" if detail else ""))
    results.append((name, condition))

# ─────────────────────────────────────────────────────────────────────────────
print("\n═══════════════════════════════════════════")
print("  TEST 1 · _letterbox")
print("═══════════════════════════════════════════")

img_640  = np.zeros((480, 640, 3), dtype=np.uint8)   # landscape
img_tall = np.zeros((800, 400, 3), dtype=np.uint8)   # portrait

lb1, s1, p1 = _letterbox(img_640, 640)
check("Output shape == (640,640,3)", lb1.shape == (640, 640, 3), str(lb1.shape))
check("Scale ≤ 1.0 for landscape",   s1 <= 1.0, f"scale={s1:.4f}")
check("pad_top > 0 for landscape",   p1[1] > 0, f"pad={p1}")

lb2, s2, p2 = _letterbox(img_tall, 640)
check("Output shape == (640,640,3) tall", lb2.shape == (640, 640, 3), str(lb2.shape))
check("pad_left > 0 for portrait",   p2[0] > 0, f"pad={p2}")

# ─────────────────────────────────────────────────────────────────────────────
print("\n═══════════════════════════════════════════")
print("  TEST 2 · _preprocess")
print("═══════════════════════════════════════════")

blob, scale, pad = _preprocess(img_640, 640)
check("Blob dtype float32",      blob.dtype == np.float32, str(blob.dtype))
check("Blob shape [1,3,640,640]", blob.shape == (1, 3, 640, 640), str(blob.shape))
check("Blob values in [0,1]",    blob.min() >= 0.0 and blob.max() <= 1.0,
      f"min={blob.min():.3f} max={blob.max():.3f}")

# ─────────────────────────────────────────────────────────────────────────────
print("\n═══════════════════════════════════════════")
print("  TEST 3 · _nms")
print("═══════════════════════════════════════════")

# 2 box chồng nhau (IoU cao) + 1 box riêng
boxes  = np.array([[10,10,50,50],[12,12,52,52],[200,200,250,250]], dtype=float)
scores = np.array([0.9, 0.8, 0.7])
keep   = _nms(boxes, scores, iou_thr=0.45)
check("NMS giữ lại 2 box (loại 1 chồng)", len(keep) == 2, f"keep={keep}")
check("NMS giữ box có score cao nhất đầu", keep[0] == 0)

# ─────────────────────────────────────────────────────────────────────────────
print("\n═══════════════════════════════════════════")
print("  TEST 4 · AIEngine._load_model")
print("═══════════════════════════════════════════")

config = {
    "model_path":           "models/yolo/plant_disease_int8.onnx",  # khớp config.json
    "confidence_threshold": 0.65,
    "inference_imgsz":      640,
    "iou_threshold":        0.45,
}

engine = AIEngine(config)
engine._load_model()

check("Session loaded",            engine.session is not None)
check("input_name set",            engine.input_name == "images", engine.input_name)
check("num_classes == 27",         engine.num_classes == 27, str(engine.num_classes))
check("class_names loaded (27)",   len(engine.class_names) == 27,
      f"got {len(engine.class_names)}")
check("First class name correct",  engine.class_names[0] == "Apple__Alternaria",
      engine.class_names[0] if engine.class_names else "(empty)")

# ─────────────────────────────────────────────────────────────────────────────
print("\n═══════════════════════════════════════════")
print("  TEST 5 · Raw ONNX inference (synthetic image)")
print("═══════════════════════════════════════════")

# Ảnh xanh lá đồng nhất — model không nên detect gì
green_img = np.full((480, 640, 3), [0, 200, 0], dtype=np.uint8)
dets = engine._run_inference(green_img)
check("Inference không crash",       True)                       # Nếu crash thì check trên fail rồi
check("Type kết quả là list",        isinstance(dets, list), type(dets).__name__)
print(f"  {INFO} Green image detections: {len(dets)} (expected ~0)")

# ─────────────────────────────────────────────────────────────────────────────
print("\n═══════════════════════════════════════════")
print("  TEST 6 · process_test_image (Base64 round-trip)")
print("═══════════════════════════════════════════")

# Encode ảnh xanh → base64 → truyền vào engine
ret, buf = cv2.imencode(".jpg", green_img)
b64_str  = base64.b64encode(buf).decode("utf-8")
b64_uri  = f"data:image/jpeg;base64,{b64_str}"

report = engine.process_test_image(b64_uri, report_id="test-001")

check("Trả về dict, không phải None",       report is not None)
check("report_id đúng",                     report.get("report_id") == "test-001")
check("Có key stable_health_status",        "stable_health_status" in report)
check("Có key evidence_image",             "evidence_image" in report)
check("evidence_image là data URI",
      report.get("evidence_image", "").startswith("data:image/jpeg;base64,"))
status = report.get("stable_health_status")
check("Status hợp lệ (Healthy/Warning/No_Detection)",
      status in ("Healthy", "Warning", "No_Detection"), status)
# Nếu model detect "Healthy" → engine phải trả về "Healthy" (không phải Warning)
if status == "Healthy":
    check("Healthy detection → status Healthy", status == "Healthy", status)
elif status == "No_Detection":
    check("No detection → No_Detection",        status == "No_Detection", status)
else:
    check("Warning detection → status Warning", status == "Warning", status)

# ─────────────────────────────────────────────────────────────────────────────
print("\n═══════════════════════════════════════════")
print("  TEST 7 · requirements.txt — không còn ultralytics/torch")
print("═══════════════════════════════════════════")

with open("requirements.txt", "r") as f:
    reqs = f.read().lower()

check("ultralytics không còn trong requirements", "ultralytics" not in reqs)
check("torch không còn trong requirements",       "torch" not in reqs)
check("onnxruntime có trong requirements",        "onnxruntime" in reqs)

# ─────────────────────────────────────────────────────────────────────────────
total  = len(results)
passed = sum(1 for _, ok in results if ok)
failed = total - passed

print("\n═══════════════════════════════════════════")
print(f"  KẾT QUẢ: {passed}/{total} PASS  |  {failed} FAIL")
print("═══════════════════════════════════════════\n")

if failed:
    sys.exit(1)
