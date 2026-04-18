import pytest
from src.report_builder import ReportBuilder

@pytest.fixture
def report_builder():
    return ReportBuilder()

class MockAIEngine:
    def __init__(self, data):
        self.data = data
    def get_aggregated_data(self):
        return self.data

class MockLSTM:
    def __init__(self, label, conf, buffer_len=12, window_size=12):
        self.label = label
        self.conf = conf
        self.buffer = [0] * buffer_len
        self.window_size = window_size
        
    def predict(self):
        return self.label, self.conf

def test_build_plant_report_no_data(report_builder):
    report = report_builder.build_plant_report(None)
    assert report["stable_health_status"] == "Checking"
    assert report["plant_disease"] == "None"

def test_build_plant_report_with_data(report_builder):
    # Dữ liệu mô phỏng detection từ camera
    mock_ai = MockAIEngine({"potato_Early_blight": 6, "potato_Healthy": 2})
    report = report_builder.build_plant_report(mock_ai)
    
    # 6 > THRESH (5) => Warning
    assert report["stable_health_status"] == "Warning"
    assert report["plant_name"] == "potato"
    assert report["plant_disease"] == "Early blight"
    assert report["debug_detection_count"] == 6

def test_build_sensor_health_no_data(report_builder):
    health = report_builder.build_sensor_health(None)
    assert health is None

def test_build_sensor_health_with_data(report_builder):
    mock_lstm = MockLSTM("High Stress", 0.95)
    health = report_builder.build_sensor_health(mock_lstm)
    
    assert health is not None
    assert health["lstm_status"] == "High Stress"
    assert health["lstm_confidence"] == 95.0
    assert health["lstm_ready"] is True

def test_build_device_report(report_builder):
    configs = {"deviceId": "test-dev", "plantId": "test-plant"}
    plant_report = {"stable_health_status": "Healthy", "plant_disease": "None"}
    sensor_data = [{"type": "temperature", "value": 25.0}]
    alert = {"level": "NORMAL", "message": "All good"}
    sensor_health = {"lstm_status": "Healthy", "lstm_confidence": 99.0}

    report = report_builder.build_device_report(
        configs, plant_report, sensor_data, alert, sensor_health
    )
    
    assert report["deviceId"] == "test-dev"
    assert report["plantId"] == "test-plant"
    assert report["plant"]["stable_health_status"] == "Healthy"
    assert report["sensors"] == sensor_data
    assert report["alert"]["level"] == "NORMAL"
    assert report["sensor_health"]["lstm_status"] == "Healthy"
