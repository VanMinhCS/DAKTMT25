import pytest
from src.alert_engine import AlertEngine

@pytest.fixture
def alert_engine():
    return AlertEngine()

def test_critical_alert(alert_engine):
    result = alert_engine.build("Warning", "High Stress")
    assert result["level"] == "CRITICAL"
    assert "stress cao" in result["message"].lower()

def test_warning_alert_from_yolo(alert_engine):
    result = alert_engine.build("Warning", "Healthy")
    assert result["level"] == "WARNING"

def test_warning_alert_from_lstm(alert_engine):
    result = alert_engine.build("Healthy", "Moderate Stress")
    assert result["level"] == "WARNING"

def test_normal_alert(alert_engine):
    result = alert_engine.build("Healthy", "Healthy")
    assert result["level"] == "NORMAL"

def test_missing_lstm_data(alert_engine):
    # Khi lstm = None, cảnh báo dựa trên YOLO
    result1 = alert_engine.build("Warning", None)
    assert result1["level"] == "WARNING"

    result2 = alert_engine.build("Healthy", None)
    assert result2["level"] == "NORMAL"
