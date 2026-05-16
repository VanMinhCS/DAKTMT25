import pytest
from src.services.alert_engine import AlertEngine

@pytest.fixture
def alert_engine():
    return AlertEngine()

def test_critical_alert(alert_engine):
    """YOLO Warning + LSTM disease_risk → CRITICAL"""
    result = alert_engine.build("Warning", "Late_Blight_Risk")
    assert result["level"] == "CRITICAL"

def test_warning_yolo_nutrient_deficient(alert_engine):
    """YOLO Warning + LSTM nutrient_deficient → WARNING"""
    result = alert_engine.build("Warning", "N_Deficient")
    assert result["level"] == "WARNING"

def test_verification_alert(alert_engine):
    """YOLO Warning + LSTM healthy → VERIFICATION (có thể nhận diện nhầm)"""
    result = alert_engine.build("Warning", "Healthy")
    assert result["level"] == "VERIFICATION"

def test_warning_yolo_lstm_unknown(alert_engine):
    """YOLO Warning + LSTM unknown → WARNING (bệnh confirmed, thiếu data môi trường)"""
    result = alert_engine.build("Warning", None)
    assert result["level"] == "WARNING"

def test_checking_with_disease_risk(alert_engine):
    """YOLO Checking + LSTM disease_risk → PRE_WARNING"""
    result = alert_engine.build("Checking", "Early_Blight_Risk")
    assert result["level"] == "PRE_WARNING"

def test_checking_normal(alert_engine):
    """YOLO Checking + LSTM healthy → NORMAL"""
    result = alert_engine.build("Checking", "Healthy")
    assert result["level"] == "NORMAL"

def test_healthy_with_nutrient_deficient(alert_engine):
    """YOLO Healthy + LSTM nutrient_deficient → PRE_WARNING"""
    result = alert_engine.build("Healthy", "N_Deficient")
    assert result["level"] == "PRE_WARNING"

def test_normal_alert(alert_engine):
    """YOLO Healthy + LSTM Healthy → NORMAL"""
    result = alert_engine.build("Healthy", "Healthy")
    assert result["level"] == "NORMAL"

def test_no_detection_with_lstm_risk(alert_engine):
    """YOLO No_Detection + LSTM disease_risk → PRE_WARNING"""
    result = alert_engine.build("No_Detection", "Bacterial_Spot_Risk")
    assert result["level"] == "PRE_WARNING"

def test_no_detection_normal(alert_engine):
    """YOLO No_Detection + LSTM healthy → NORMAL"""
    result = alert_engine.build("No_Detection", "Healthy")
    assert result["level"] == "NORMAL"

def test_missing_lstm_data(alert_engine):
    """Khi lstm = None, cảnh báo dựa trên YOLO"""
    result1 = alert_engine.build("Warning", None)
    assert result1["level"] == "WARNING"

    result2 = alert_engine.build("Healthy", None)
    assert result2["level"] == "NORMAL"

def test_alert_payload_structure(alert_engine):
    """Kiểm tra cấu trúc payload trả về"""
    result = alert_engine.build("Warning", "Late_Blight_Risk")
    assert "level" in result
    assert "status" in result
    assert "source" in result
    assert "message" in result
    assert result["source"] == "Decision_Fusion_YOLO_LSTM"
