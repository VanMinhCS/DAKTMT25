class AlertEngine:
    """
    Kết hợp kết quả YOLO và LSTM để tạo cảnh báo tổng hợp.

    YOLO status : "Healthy" | "Warning" | "Checking"
    LSTM status : "Healthy" | "Moderate Stress" | "High Stress" | None
    """

    def build(self, yolo_status: str, lstm_status: str | None) -> dict:
        yolo_bad  = yolo_status == "Warning"
        lstm_bad  = lstm_status and ("stress" in lstm_status.lower() or "high" in lstm_status.lower())
        lstm_mild = lstm_status and "moderate" in lstm_status.lower()

        if yolo_bad and lstm_bad:
            level   = "CRITICAL"
            message = f"Phát hiện bệnh lá ({yolo_status}) + đất stress cao ({lstm_status})"
        elif yolo_bad and not lstm_bad:
            level   = "WARNING"
            message = f"Phát hiện bệnh lá ({yolo_status}) — đất vẫn ổn ({lstm_status or 'N/A'})"
        elif not yolo_bad and (lstm_bad or lstm_mild):
            level   = "WARNING"
            message = f"Lá bình thường — đất đang stress ({lstm_status}), rủi ro sắp phát bệnh"
        else:
            level   = "NORMAL"
            message = "Cây khỏe mạnh — lá và đất đều ổn"

        return {
            "level":   level,
            "source":  "YOLO+LSTM",
            "message": message,
        }
