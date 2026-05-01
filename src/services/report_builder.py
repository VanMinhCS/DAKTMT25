import uuid
from datetime import datetime

# Số lần xuất hiện tối thiểu để xác nhận một bệnh (tránh false positive nhất thời)
DETECTION_CONF_THRESH = 5

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
            "stable_health_status": "Checking",
            "detectedAt":           datetime.now().isoformat(),
        }

        if ai_engine is None:
            return report

        detection_counts = ai_engine.get_aggregated_data()
        if not detection_counts:
            return report

        best_class = max(detection_counts, key=detection_counts.get)
        count      = detection_counts[best_class]

        parts  = best_class.split('_', 1)
        p_name = parts[0].lower()          if len(parts) == 2 else "Unknown"
        d_name = parts[1].replace('_', ' ') if len(parts) == 2 else best_class

        report.update({
            "plant_name":            p_name,
            "plant_disease":         d_name,
            "debug_detection_count": count,
        })

        if "healthy" in best_class.lower():
            report["stable_health_status"] = "Healthy"
        elif count >= DETECTION_CONF_THRESH:
            report["stable_health_status"] = "Warning"
        else:
            report["stable_health_status"] = "Checking"

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
                            sensor_health: dict | None) -> dict:
        """
        Ghép tất cả thành device_report cuối cùng để gửi lên ThingsBoard.
        """
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
