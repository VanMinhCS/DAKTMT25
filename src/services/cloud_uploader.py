"""
Cloud uploader sử dụng ONLY Python standard library.
Không cần pip install gì thêm — an toàn cho Yocto build.
"""
import urllib.request
import urllib.parse
import json
import os
import threading
import queue
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
        self.offline_queue_path = config.get("cloud_offline_queue_path", "logs/offline_queue.jsonl")

        if not self.api_key or not self.project_id:
            logger.warning("[Cloud] Missing firebase_api_key or firebase_project_id in config. Cloud upload will likely fail.")

        # Firebase REST endpoints
        self._firestore_url = (
            f"https://firestore.googleapis.com/v1/"
            f"projects/{self.project_id}/databases/(default)/documents"
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

    def enqueue_record(self, device_report: dict):
        if not self.enabled:
            return
            
        alert_level = device_report.get("alert", {}).get("level", "NORMAL")
        if not self._should_upload(alert_level):
            return
            
        record = device_report.copy()
        record["uploaded_at"] = datetime.now().isoformat()
        
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
        doc = self._build_firestore_doc(record)
        
        success = self._upload_firestore(doc)
        if not success:
            self._save_offline(record)

    def _to_firestore_value(self, val):
        if isinstance(val, dict):
            return {"mapValue": {"fields": {k: self._to_firestore_value(v) for k, v in val.items()}}}
        elif isinstance(val, list):
            return {"arrayValue": {"values": [self._to_firestore_value(v) for v in val]}}
        elif isinstance(val, bool):
            return {"booleanValue": val}
        elif isinstance(val, int):
            return {"integerValue": str(val)}
        elif isinstance(val, float):
            return {"doubleValue": val}
        elif val is None:
            return {"nullValue": None}
        else:
            return {"stringValue": str(val)}

    def _build_firestore_doc(self, record: dict) -> dict:
        return {"fields": {k: self._to_firestore_value(v) for k, v in record.items()}}

    def _upload_firestore(self, doc: dict) -> bool:
        try:
            url = f"{self._firestore_url}/device_reports?key={self.api_key}"

            req = urllib.request.Request(
                url,
                data=json.dumps(doc).encode("utf-8"),
                headers={"Content-Type": "application/json"},
                method="POST",
            )
            with urllib.request.urlopen(req, timeout=10) as resp:
                resp.read()

            alert_level = doc.get("fields", {}).get("alert", {}).get("mapValue", {}).get("fields", {}).get("level", {}).get("stringValue", "UNKNOWN")
            logger.info(f"[Cloud] Device report uploaded — level: {alert_level}")
            return True

        except Exception as e:
            logger.error(f"[Cloud] Firestore write failed: {e}")
            return False

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
