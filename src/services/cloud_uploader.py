"""
Cloud uploader sử dụng ONLY Python standard library.
Không cần pip install gì thêm — an toàn cho Yocto build.
"""
import urllib.request
import urllib.parse
import json
import base64
import os
import threading
import queue
import cv2
import time
from datetime import datetime
from src.core.logger import get_logger

logger = get_logger(__name__)

class CloudUploader:
    def __init__(self, config: dict):
        self.config = config
        self.enabled = config.get("enable_cloud_upload", False)
        if not self.enabled:
            return
            
        self.api_key      = config.get("firebase_api_key")
        self.project_id   = config.get("firebase_project_id")
        self.bucket_name  = config.get("firebase_bucket", f"{self.project_id}.appspot.com")
        self.device_id    = config.get("cloud_device_id", config.get("deviceId", "rpi-edge-01"))
        self.offline_queue_path = config.get("cloud_offline_queue_path", "logs/offline_queue.jsonl")
        self.upload_image_enabled = config.get("cloud_upload_image", True)

        if not self.api_key or not self.project_id:
            logger.warning("[Cloud] Missing firebase_api_key or firebase_project_id in config. Cloud upload will likely fail.")

        # Firebase REST endpoints
        self._firestore_url = (
            f"https://firestore.googleapis.com/v1/"
            f"projects/{self.project_id}/databases/(default)/documents"
        )
        self._storage_url = (
            f"https://firebasestorage.googleapis.com/v0/b/"
            f"{self.bucket_name}/o"
        )
        
        self.HEALTHY_ALERT_LEVELS = {"NORMAL"}
        
        self.running = False
        self.queue = queue.Queue()
        self.thread = None

    def _should_upload(self, alert_level: str) -> bool:
        """Gate function — quyết định có upload không"""
        return alert_level not in self.HEALTHY_ALERT_LEVELS

    def start(self):
        if not self.enabled:
            return
        self.running = True
        # Try to flush offline queue on startup
        self._flush_offline_queue()
        self.thread = threading.Thread(target=self._worker, daemon=True)
        self.thread.start()
        logger.info("[Cloud] Uploader started.")

    def stop(self):
        if not self.enabled:
            return
        self.running = False
        if self.thread:
            self.thread.join(timeout=2)
        logger.info("[Cloud] Uploader stopped.")

    def enqueue_record(self, frame, plant_report, sensors, lstm_status, alert_level):
        if not self.enabled:
            return
            
        if not self._should_upload(alert_level):
            return
            
        record = {
            "timestamp": datetime.now().isoformat(),
            "plant_report": plant_report,
            "sensors": sensors,
            "lstm_status": lstm_status,
            "alert_level": alert_level
        }
        
        # Add frame to record if needed. But frame is not serializable.
        # We need to encode it to jpg bytes here so we can queue it safely.
        if self.upload_image_enabled and frame is not None:
            ret, buf = cv2.imencode(".jpg", frame)
            if ret:
                record["frame_bytes"] = buf.tobytes()
            else:
                record["frame_bytes"] = None
        else:
            record["frame_bytes"] = None
            
        self.queue.put(record)

    def _worker(self):
        while self.running:
            try:
                record = self.queue.get(timeout=1)
                self._process_record(record)
                self.queue.task_done()
            except queue.Empty:
                continue
            except Exception as e:
                logger.error(f"[Cloud] Worker error: {e}")

    def _process_record(self, record):
        frame_bytes = record.pop("frame_bytes", None)
        alert_level = record["alert_level"]
        yolo_label = record["plant_report"].get("plant_disease", "None")
        if record["plant_report"].get("plant_name") != "Unknown":
            yolo_label = f"{record['plant_report'].get('plant_name')}__{yolo_label}"
            
        image_url = ""
        if frame_bytes:
            url = self._upload_image(frame_bytes, alert_level, yolo_label)
            if url:
                image_url = url
            else:
                pass
                
        # Build document
        doc = self._build_firestore_doc(
            timestamp=record["timestamp"],
            yolo_label=yolo_label,
            yolo_status=record["plant_report"].get("stable_health_status", "No_Detection"),
            confidence=record["plant_report"].get("confidence", 0.0), # Assuming this might exist or just 0
            lstm_status=record["lstm_status"] or "unknown",
            alert_level=alert_level,
            image_url=image_url,
            sensor_data=record["sensors"]
        )
        
        success = self._upload_firestore(doc)
        if not success:
            # Ghi vào offline queue
            # Reconstruct offline record. Include image in base64 if it wasn't uploaded.
            offline_rec = record.copy()
            if not image_url and frame_bytes:
                offline_rec["frame_base64"] = base64.b64encode(frame_bytes).decode('utf-8')
            self._save_offline(offline_rec)

    def _upload_image(self, image_bytes: bytes, alert_level: str, yolo_label: str):
        try:
            timestamp  = datetime.now().strftime("%Y%m%d_%H%M%S")
            remote_path = f"images/{self.device_id}/{alert_level}/{yolo_label}/{timestamp}.jpg"
            encoded     = urllib.parse.quote(remote_path, safe="")

            url = f"{self._storage_url}?uploadType=media&name={encoded}&key={self.api_key}"

            req = urllib.request.Request(
                url,
                data=image_bytes,
                headers={"Content-Type": "image/jpeg"},
                method="POST",
            )
            with urllib.request.urlopen(req, timeout=15) as resp:
                result = json.loads(resp.read())

            download_url = (
                f"https://firebasestorage.googleapis.com/v0/b/{self.bucket_name}"
                f"/o/{encoded}?alt=media"
            )
            logger.info(f"[Cloud] Image uploaded: {remote_path}")
            return download_url

        except Exception as e:
            logger.error(f"[Cloud] Image upload failed: {e}")
            return None

    def _upload_firestore(self, doc: dict) -> bool:
        try:
            url = f"{self._firestore_url}/sensor_records?key={self.api_key}"

            req = urllib.request.Request(
                url,
                data=json.dumps(doc).encode("utf-8"),
                headers={"Content-Type": "application/json"},
                method="POST",
            )
            with urllib.request.urlopen(req, timeout=10) as resp:
                resp.read()

            logger.info(f"[Cloud] Sensor record uploaded — level: {doc['fields']['alert_level']['stringValue']}")
            return True

        except Exception as e:
            logger.error(f"[Cloud] Firestore write failed: {e}")
            return False

    def _build_firestore_doc(self, timestamp: str, yolo_label: str, yolo_status: str,
                              confidence: float, lstm_status: str, alert_level: str, image_url: str, sensor_data: list) -> dict:
        fields = {
            "device_id":    {"stringValue": self.device_id},
            "timestamp":    {"stringValue": timestamp},
            "yolo_label":   {"stringValue": yolo_label},
            "yolo_status":  {"stringValue": yolo_status},
            "confidence":   {"doubleValue": float(confidence)},
            "lstm_status":  {"stringValue": lstm_status},
            "alert_level":  {"stringValue": alert_level},
            "image_url":    {"stringValue": image_url or ""},
        }

        # Format sensors: [{'type': 'temp', 'value': 28.5}, ...] -> dict
        sensor_dict = {}
        for s in sensor_data:
            sensor_dict[s["type"]] = s["value"]

        sensor_map = {}
        for k, v in sensor_dict.items():
            if isinstance(v, float):
                sensor_map[k] = {"doubleValue": v}
            elif isinstance(v, int):
                sensor_map[k] = {"integerValue": str(v)}
            else:
                sensor_map[k] = {"stringValue": str(v)}

        fields["sensor_data"] = {"mapValue": {"fields": sensor_map}}
        return {"fields": fields}

    def _save_offline(self, record):
        try:
            os.makedirs(os.path.dirname(self.offline_queue_path), exist_ok=True)
            with open(self.offline_queue_path, "a") as f:
                f.write(json.dumps(record) + "\n")
            logger.info(f"[Cloud] Saved to offline queue.")
        except Exception as e:
            logger.error(f"[Cloud] Could not save offline record: {e}")

    def _flush_offline_queue(self):
        if not os.path.exists(self.offline_queue_path):
            return
            
        logger.info("[Cloud] Flushing offline queue...")
        try:
            with open(self.offline_queue_path, "r") as f:
                lines = f.readlines()
                
            if not lines:
                return
                
            remaining = []
            for line in lines:
                line = line.strip()
                if not line: continue
                
                try:
                    record = json.loads(line)
                    # Re-enqueue the record to be processed by worker thread
                    # Convert base64 image back to bytes if present
                    if "frame_base64" in record:
                        record["frame_bytes"] = base64.b64decode(record["frame_base64"])
                        del record["frame_base64"]
                    else:
                        record["frame_bytes"] = None
                        
                    self.queue.put(record)
                except Exception as e:
                    logger.error(f"[Cloud] Failed to parse offline record: {e}")
                    remaining.append(line)
            
            # Write back unparseable lines
            with open(self.offline_queue_path, "w") as f:
                for line in remaining:
                    f.write(line + "\n")
                    
        except Exception as e:
            logger.error(f"[Cloud] Failed to flush offline queue: {e}")
