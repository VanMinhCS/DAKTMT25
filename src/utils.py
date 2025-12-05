import json
import random
import cv2
import numpy as np

def load_config(config_path="config.json"):
    try:
        with open(config_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Config Error: {e}")
        return {}

def get_sensor_data():
    """Giả lập dữ liệu cảm biến"""
    return [
        {"type": "temperature", "value": round(random.uniform(25, 32), 1), "unit": "C"},
        {"type": "humidity", "value": round(random.uniform(60, 85), 1), "unit": "%"},
        {"type": "soil_moisture", "value": round(random.uniform(40, 70), 1), "unit": "%"}
    ]

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
