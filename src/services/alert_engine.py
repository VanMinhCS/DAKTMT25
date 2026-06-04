# ── LSTM class groups (dùng set membership, không dùng keyword matching) ──
_DISEASE_RISK_CLASSES = {
    "Bacterial_Spot_Risk", "Early_Blight_Risk",
    "Late_Blight_Risk",    "Leaf_Mold_Risk",
}
_NUTRIENT_DEFICIENT_CLASSES = {
    "N_Deficient", "P_Deficient",
    "K_Deficient", "Fe_Deficient",
}


def _classify_lstm(lstm_status: str | None) -> str:
    """
    Phân loại LSTM output thành 4 nhóm rõ ràng.
    Trả về: 'healthy' | 'disease_risk' | 'nutrient_deficient' | 'unknown'
    """
    if not lstm_status or lstm_status == "Collecting data...":
        return "unknown"
    if lstm_status == "Healthy":
        return "healthy"
    if lstm_status in _DISEASE_RISK_CLASSES:
        return "disease_risk"
    if lstm_status in _NUTRIENT_DEFICIENT_CLASSES:
        return "nutrient_deficient"
    return "unknown"


class AlertEngine:
    """
    Kết hợp kết quả YOLO và LSTM để tạo cảnh báo tổng hợp (Decision Fusion).

    YOLO status : "Healthy" | "Warning" | "Checking" | "No_Detection"
    LSTM group  : "healthy" | "disease_risk" | "nutrient_deficient" | "unknown"
                  (map từ 9 class: Healthy / *_Risk / *_Deficient / chưa đủ data)

    Ma trận quyết định (5 cấp độ):
    ┌──────────────┬─────────────────────┬───────────────┐
    │ YOLO         │ LSTM group          │ Alert Level   │
    ├──────────────┼─────────────────────┼───────────────┤
    │ Warning      │ disease_risk        │ CRITICAL      │
    │ Warning      │ nutrient_deficient  │ WARNING       │
    │ Warning      │ healthy             │ VERIFICATION  │ ← môi trường tốt → nghi nhầm
    │ Warning      │ unknown             │ WARNING       │ ← bệnh confirmed, thiếu data môi trường
    ├──────────────┼─────────────────────┼───────────────┤
    │ Checking     │ disease_risk/nutri  │ PRE_WARNING   │ ← LSTM là tín hiệu chủ đạo
    │ Checking     │ healthy/unknown     │ NORMAL        │ ← tín hiệu yếu, chờ xác nhận
    ├──────────────┼─────────────────────┼───────────────┤
    │ Healthy      │ disease_risk/nutri  │ PRE_WARNING   │ ← phòng ngừa / bổ sung dinh dưỡng
    │ Healthy      │ healthy/unknown     │ NORMAL        │
    ├──────────────┼─────────────────────┼───────────────┤
    │ No_Detection │ disease_risk/nutri  │ PRE_WARNING   │ ← chỉ dựa vào LSTM
    │ No_Detection │ healthy/unknown     │ NORMAL        │
    └──────────────┴─────────────────────┴───────────────┘
    """

    def __init__(self):
        from ..core import metrics as _metrics
        self._metrics = _metrics
        # State theo dõi mức cảnh báo trước để phát hiện thay đổi
        self._last_level: str | None = None

    def build(self, yolo_status: str, lstm_status: str | None,
              stream_url: str = "") -> dict:

        lstm_group = _classify_lstm(lstm_status)
        lstm_bad   = lstm_group in ("disease_risk", "nutrient_deficient")

        # ── YOLO xác nhận bệnh ────────────────────────────────────────────
        if yolo_status == "Warning":
            if lstm_group == "disease_risk":
                level, status = "CRITICAL", "critical"
                message = (f"Phát hiện bệnh trên lá + môi trường đang có nguy cơ cao "
                           f"({lstm_status}). Kích hoạt báo động khẩn!")
            elif lstm_group == "nutrient_deficient":
                level, status = "WARNING", "warning"
                message = (f"Phát hiện bệnh trên lá + cây thiếu dinh dưỡng "
                           f"({lstm_status}). Cần điều trị và bổ sung dinh dưỡng.")
            elif lstm_group == "healthy":
                # Bệnh lá nhưng môi trường ổn → có thể nhận diện nhầm
                level, status = "VERIFICATION", "verify"
                message = ("Có dấu hiệu bệnh trên lá nhưng môi trường đang an toàn "
                           f"({lstm_status}). Cần xác minh lại qua camera.")
            else:
                # unknown = LSTM chưa đủ data (≠ môi trường tốt)
                # YOLO đã confirm ≥5 frame → bệnh có thật, chỉ là chưa rõ mức độ môi trường
                level, status = "WARNING", "warning"
                message = ("Xác nhận bệnh trên lá. Chưa có đủ dữ liệu môi trường từ LSTM "
                           "để đánh giá nguy cơ lan rộng — cần kiểm tra và xử lý sớm.")

        # ── YOLO đang xác nhận (thấy bệnh nhưng chưa đủ ngưỡng frame) ────
        elif yolo_status == "Checking":
            if lstm_bad:
                level, status = "PRE_WARNING", "pre-warning"
                message = (f"Camera đang ghi nhận dấu hiệu bệnh + môi trường "
                           f"có rủi ro ({lstm_status}). Theo dõi chặt.")
            else:
                level, status = "NORMAL", "normal"
                message = "Camera đang thu thập thêm dữ liệu — chưa phát hiện bất thường."

        # ── YOLO thấy cây khỏe ────────────────────────────────────────────
        elif yolo_status == "Healthy":
            if lstm_bad:
                level, status = "PRE_WARNING", "pre-warning"
                message = (f"Lá đang khỏe mạnh nhưng môi trường có dấu hiệu bất ổn "
                           f"({lstm_status}). Cần phòng ngừa.")
            else:
                level, status = "NORMAL", "normal"
                message = "Cây khỏe mạnh — lá và đất đều ổn định."

        # ── YOLO không thấy gì (camera trống / bị che) ───────────────────
        else:  # No_Detection hoặc giá trị không xác định
            if lstm_bad:
                level, status = "PRE_WARNING", "pre-warning"
                message = (f"Camera không phát hiện cây — nhưng LSTM cảnh báo "
                           f"môi trường có vấn đề ({lstm_status}).")
            else:
                level, status = "NORMAL", "normal"
                message = "Không phát hiện cây trong khung hình. Hệ thống đang chờ."

        # ── Ghi metrics khi mức cảnh báo thay đổi ────────────────────────
        if level != self._last_level:
            self._metrics.log_alert_transition(
                old_level=self._last_level,
                new_level=level,
                yolo_status=yolo_status,
                lstm_status=lstm_status,
            )
            self._last_level = level

        payload = {
            "level":   level,
            "status":  status,
            "source":  "Decision_Fusion_YOLO_LSTM",
            "message": message,
        }

        if level == "VERIFICATION" and stream_url:
            payload["url"] = stream_url

        return payload
