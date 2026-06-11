import os
import pickle
import numpy as np
from ..core.logger import get_logger

logger = get_logger("AlertEngine")

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
    Kết hợp kết quả YOLO và LSTM để tạo cảnh báo tổng hợp (Decision Fusion)
    sử dụng mô hình Random Forest (Meta-Learner).
    """

    def __init__(self):
        from ..core import metrics as _metrics
        self._metrics = _metrics
        self._last_level: str | None = None
        
        self.model = None
        self.yolo_map = {}
        self.lstm_map = {}
        self.level_names = []
        
        # Load Random Forest model
        model_path = "models/fusion/rf_fusion_model.pkl"
        if os.path.exists(model_path):
            try:
                with open(model_path, "rb") as f:
                    data = pickle.load(f)
                    self.model = data["model"]
                    self.yolo_map = data["yolo_map"]
                    self.lstm_map = data["lstm_map"]
                    self.level_names = data["level_names"]
                logger.info(f"Loaded Meta-Learner from {model_path}")
            except Exception as e:
                logger.error(f"Failed to load Meta-Learner: {e}")
        else:
            logger.warning(f"Meta-Learner not found at {model_path}. Using fallback logic.")

    def build(self, yolo_status: str, yolo_conf: float = 0.0, lstm_status: str | None = None,
              lstm_conf: float = 0.0, stream_url: str = "") -> dict:

        lstm_group = _classify_lstm(lstm_status)
        
        # Tiền xử lý thông báo tự động (tùy theo level)
        lstm_str_display = lstm_status if lstm_status and lstm_status != "Collecting data..." else "Chưa đủ dữ liệu"
        
        level = "NORMAL"
        status = "normal"
        message = "Hệ thống hoạt động bình thường."

        # Nếu mô hình RF được nạp thành công -> Sử dụng Random Forest
        if self.model is not None:
            try:
                # Map inputs
                x_yolo = self.yolo_map.get(yolo_status, 0)
                x_lstm = self.lstm_map.get(lstm_group, 0)
                
                # Predict
                X_input = np.array([[x_yolo, yolo_conf, x_lstm, lstm_conf]])
                pred_idx = int(self.model.predict(X_input)[0])
                level = self.level_names[pred_idx]
                
                # Tạo trạng thái string cho frontend
                status = level.lower().replace("_", "-")
                if level == "VERIFICATION": status = "verify"
                
                # Gán message tùy theo Level
                if level == "CRITICAL":
                    message = f"[AI Tầng 2] Mức độ NGUY HIỂM: Lá có bệnh + Môi trường rủi ro ({lstm_str_display})."
                elif level == "WARNING":
                    message = f"[AI Tầng 2] CẢNH BÁO: Phát hiện bất thường cần xử lý sớm ({lstm_str_display})."
                elif level == "PRE_WARNING":
                    message = f"[AI Tầng 2] Cảnh báo sớm: Có rủi ro tiềm ẩn từ môi trường hoặc lá ({lstm_str_display})."
                elif level == "VERIFICATION":
                    message = f"[AI Tầng 2] Cần xác minh: Phát hiện bệnh nhưng môi trường rất tốt ({lstm_str_display})."
                else:
                    message = f"[AI Tầng 2] Bình thường: Không phát hiện bất thường nghiêm trọng."
                    
            except Exception as e:
                logger.error(f"Random Forest Predict Error: {e}")
                level = "NORMAL"
        
        else:
            # Fallback (IF-ELSE) dựa theo 5 cấp độ chuẩn nếu file pkl bị xóa hoặc lỗi
            if lstm_group == "healthy" and lstm_conf >= 0.85 and yolo_status == "Warning" and yolo_conf >= 0.85:
                level = "VERIFICATION"
                status = "verify"
            elif lstm_group == "disease_risk" and lstm_conf >= 0.50 and yolo_status == "Warning" and yolo_conf >= 0.50:
                level = "CRITICAL"
                status = "critical"
            elif yolo_status == "Warning" and yolo_conf >= 0.75:
                level = "WARNING"
                status = "warning"
            elif (lstm_group in ["disease_risk", "nutrient_deficient"] and lstm_conf >= 0.50) or \
                 (yolo_status == "Warning" and 0.50 <= yolo_conf < 0.75):
                level = "PRE_WARNING"
                status = "pre-warning"
            else:
                level = "NORMAL"
                status = "normal"
            message = "[Fallback] Cảnh báo bằng cơ chế IF-ELSE chuẩn do không tìm thấy Model."

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
            "source":  "Decision_Fusion_RF_MetaLearner",
            "message": message,
        }

        if level == "VERIFICATION" and stream_url:
            payload["url"] = stream_url

        return payload
