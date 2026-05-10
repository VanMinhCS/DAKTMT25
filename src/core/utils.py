import json
import os
import random
import cv2
import numpy as np
from dotenv import load_dotenv
import logging

# Dùng logging cơ bản ở đây để tránh circular import với logger.py
_log = logging.getLogger("Config")

def load_config(config_path="config.json") -> dict:
    """
    Load config từ file JSON, merge .env, validate toàn bộ bằng Pydantic.

    Thứ tự ưu tiên: .env > config.json > AppConfig defaults.

    Returns:
        dict tương thích với code hiện tại dùng config.get(...).
        Nếu config có lỗi → in ra thông báo rõ ràng và dùng giá trị default.
    """
    from .config import AppConfig
    from pydantic import ValidationError

    # 1. Load .env
    load_dotenv()

    # 2. Load config.json
    raw: dict = {}
    try:
        with open(config_path, 'r') as f:
            raw = json.load(f)
    except FileNotFoundError:
        _log.warning("Config file '%s' not found. Using defaults.", config_path)
    except Exception as e:
        _log.error("Failed to load config file '%s': %s", config_path, e)

    # 3. Merge secrets từ .env (ưu tiên cao hơn JSON)
    env_mapping = {
        "THINGSBOARD_HOST":         "thingsboard_host",
        "THINGSBOARD_ACCESS_TOKEN": "thingsboard_access_token",
        "DEVICE_ID":                "deviceId",
        "PLANT_ID":                 "plantId",
        "FIREBASE_API_KEY":         "firebase_api_key",
        "FIREBASE_PROJECT_ID":      "firebase_project_id",
        "FIREBASE_BUCKET":          "firebase_bucket",
    }
    for env_key, cfg_key in env_mapping.items():
        val = os.getenv(env_key)
        if val:
            raw[cfg_key] = val

    # 4. Validate qua Pydantic AppConfig
    try:
        app_cfg = AppConfig.from_dict(raw)
        _log.info("Config validated successfully.")
        _log.debug("\n%s", app_cfg.summary())
        return app_cfg.as_dict()
    except ValidationError as e:
        _log.error(
            "Config validation FAILED — dùng default cho key lỗi:\n%s", e
        )
        # Fallback: loại bỏ key lỗi, validate lại với phần còn hợp lệ
        valid_fields = AppConfig.model_fields.keys()
        filtered = {k: v for k, v in raw.items() if k in valid_fields}
        try:
            return AppConfig.from_dict(filtered).as_dict()
        except Exception:
            return AppConfig().as_dict()  # All defaults


def draw_detection(frame, name, conf, box, cls_id, colors):
    """Hàm vẽ khung nhận diện lên ảnh"""
    x1, y1, x2, y2 = box
    if cls_id not in colors:
        colors[cls_id] = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
    color = colors[cls_id]

    # Vẽ khung
    cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)

    # Vẽ nhãn
    label = f"{name} ({conf:.2f})"
    (text_w, text_h), baseline = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 1)
    
    box_x1 = x1
    box_y2 = y1
    box_y1 = y1 - text_h - 10
    text_y = y1 - 5

    if box_y1 < 0:
        box_y1 = y1
        box_y2 = y1 + text_h + 10
        text_y = y1 + text_h + 5
        
    if box_x1 + text_w > frame.shape[1]:
        box_x1 = frame.shape[1] - text_w

    cv2.rectangle(frame, (box_x1, box_y1), (box_x1 + text_w, box_y2), color, -1)
    cv2.putText(frame, label, (box_x1, text_y), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 1)
