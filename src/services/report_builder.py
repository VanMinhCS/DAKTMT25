import uuid
import base64
import cv2
from datetime import datetime

# Số lần xuất hiện tối thiểu để xác nhận một bệnh (tránh false positive nhất thời)
DETECTION_CONF_THRESH = 5
# Số lần xuất hiện tối thiểu để xác nhận cây KHỎE (tránh 1 frame healthy phủ nhận bệnh)
HEALTHY_CONF_THRESH   = 3

# Giá trị sensor mặc định khi không có dữ liệu từ ESP32
DEFAULT_SENSORS = [
    {"type": "temperature",   "value": 0, "unit": "C"},
    {"type": "humidity",      "value": 0, "unit": "%"},
    {"type": "soil_moisture", "value": 0, "unit": "%"},
]


class ReportBuilder:
    """
    Xây dựng các payload báo cáo từ nhiều nguồn dữ liệu khác nhau.

    Lý do tách ra: logic build report là pure function (input → output),
    không cần trạng thái của app → dễ unit test, dễ thay đổi format.
    """

    @staticmethod
    def build_plant_report(ai_engine) -> dict:
        """
        Tạo plant_report từ bộ đếm YOLO aggregator.
        Nếu ai_engine là None hoặc chưa có detection → trả về report rỗng (Checking).
        """
        report = {
            "report_id":            str(uuid.uuid4()),
            "plant_name":           "Unknown",
            "plant_disease":        "None",
            "stable_health_status": "No_Detection",   # Mặc định: chưa thấy gì
            "detectedAt":           datetime.now().isoformat(),
        }

        if ai_engine is None:
            return report

        detection_counts = ai_engine.get_aggregated_data()
        if not detection_counts:
            return report  # status = "No_Detection" (camera trống/bị che)

        # ── Phân tách disease vs healthy ─────────────────────────────────
        disease_detections  = {k: v for k, v in detection_counts.items()
                               if "healthy" not in k.lower()}
        healthy_detections  = {k: v for k, v in detection_counts.items()
                               if "healthy" in k.lower()}
        confirmed_diseases  = {k: v for k, v in disease_detections.items()
                               if v["count"] >= DETECTION_CONF_THRESH}

        # ── Thứ tự ưu tiên: Warning > Healthy > Checking > No_Detection ──
        if confirmed_diseases:
            # Có ít nhất 1 bệnh được xác nhận → Warning (kể cả khi healthy nhiều hơn)
            best_class    = max(confirmed_diseases, key=lambda k: confirmed_diseases[k]["count"])
            health_status = "Warning"
        elif healthy_detections and max(v["count"] for v in healthy_detections.values()) >= HEALTHY_CONF_THRESH:
            # Không có bệnh xác nhận, healthy đủ ngưỡng → Healthy
            best_class    = max(healthy_detections, key=lambda k: healthy_detections[k]["count"])
            health_status = "Healthy"
        elif disease_detections:
            # Bệnh được thấy nhưng chưa đủ ngưỡng → Checking (đang xác nhận)
            best_class    = max(disease_detections, key=lambda k: disease_detections[k]["count"])
            health_status = "Checking"
        else:
            # Chỉ thấy healthy nhưng < HEALTHY_CONF_THRESH → chưa đủ căn cứ
            best_class    = max(healthy_detections, key=lambda k: healthy_detections[k]["count"]) if healthy_detections else None
            health_status = "No_Detection"

        report["stable_health_status"] = health_status
        report["yolo_confidence"] = 0.0

        if best_class:
            parts  = best_class.split('_', 1)
            p_name = parts[0].lower()           if len(parts) == 2 else "Unknown"
            d_name = parts[1].replace('_', ' ') if len(parts) == 2 else best_class
            
            best_data = detection_counts[best_class]
            yolo_conf = best_data["conf_sum"] / best_data["count"] if best_data["count"] > 0 else 0.0

            report.update({
                "plant_name":            p_name,
                "plant_disease":         d_name,
                "debug_detection_count": best_data["count"],
                "yolo_confidence":       round(yolo_conf, 3)
            })

        return report

    @staticmethod
    def build_sensor_health(lstm) -> dict | None:
        """
        Tạo sensor_health dict từ kết quả LSTM predict.
        Trả về None nếu lstm là None (tính năng tắt).
        """
        if lstm is None:
            return None

        lstm_label, lstm_conf = lstm.predict()

        if lstm_label is not None:
            return {
                "lstm_status":     lstm_label,
                "lstm_confidence": round(lstm_conf * 100, 1),
                "lstm_ready":      True,
            }
        else:
            return {
                "lstm_status":      "Collecting data...",
                "lstm_confidence":  None,
                "lstm_ready":       False,
                "lstm_buffer_len":  len(lstm.buffer),
                "lstm_window_size": lstm.window_size,
            }

    @staticmethod
    def build_device_report(config: dict, plant_report: dict,
                            sensors: list, alert: dict,
                            sensor_health: dict | None,
                            frame=None) -> dict:
        """
        Ghép tất cả thành device_report cuối cùng để gửi lên ThingsBoard.
        Có nén và đính kèm ảnh base64 nếu trạng thái không bình thường.
        """
        # Nếu có cảnh báo bất thường và có ảnh gốc
        if frame is not None and alert.get("level") != "NORMAL":
            max_w = config.get("cloud_image_max_width", 320)
            quality = config.get("cloud_image_quality", 60)
            
            # Tính toán kích thước resize giữ đúng tỉ lệ
            h, w = frame.shape[:2]
            if w > max_w:
                ratio = max_w / float(w)
                new_h = int(h * ratio)
                frame = cv2.resize(frame, (max_w, new_h))
            
            # Encode to JPEG
            ret, buf = cv2.imencode(".jpg", frame, [int(cv2.IMWRITE_JPEG_QUALITY), quality])
            if ret:
                plant_report["image_base64"] = base64.b64encode(buf).decode('utf-8')

        report = {
            "deviceId": config.get("deviceId"),
            "plantId":  config.get("plantId"),
            "plant":    plant_report,
            "sensors":  sensors,
            "alert":    alert,
        }

        if sensor_health:
            report["sensor_health"] = sensor_health

        return report
