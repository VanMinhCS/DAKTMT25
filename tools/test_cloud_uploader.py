import time
import sys
import os

# Add parent dir to path so we can import src
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.services.cloud_uploader import CloudUploader

def test_cloud_uploader():
    config = {
        "enable_cloud_upload": True,
        "firebase_api_key": "dummy_key",
        "firebase_project_id": "dummy_project",
        "cloud_device_id": "test_device_01",
        "cloud_offline_queue_path": "logs/test_offline_queue.jsonl",
        "cloud_upload_image": False  # Disable image upload for basic test
    }
    
    print("Initializing CloudUploader...")
    uploader = CloudUploader(config)
    
    print("Testing should_upload logic...")
    assert not uploader._should_upload("NORMAL"), "Should not upload on NORMAL"
    assert uploader._should_upload("WARNING"), "Should upload on WARNING"
    
    print("Starting uploader...")
    uploader.start()
    
    print("Enqueueing test record (WARNING)...")
    uploader.enqueue_record(
        frame=None,
        plant_report={
            "plant_name": "Tomato",
            "plant_disease": "Early_Blight",
            "stable_health_status": "Warning",
            "confidence": 0.85
        },
        sensors=[
            {"type": "temperature", "value": 28.5},
            {"type": "humidity", "value": 70.0}
        ],
        lstm_status="Early_Blight_Risk",
        alert_level="WARNING"
    )
    
    print("Enqueueing test record (NORMAL) - should be skipped...")
    uploader.enqueue_record(
        frame=None,
        plant_report={
            "plant_name": "Tomato",
            "plant_disease": "Healthy",
            "stable_health_status": "Healthy",
            "confidence": 0.95
        },
        sensors=[
            {"type": "temperature", "value": 25.0},
            {"type": "humidity", "value": 60.0}
        ],
        lstm_status="Healthy",
        alert_level="NORMAL"
    )
    
    time.sleep(2)
    uploader.stop()
    print("Done. Check logs for [Cloud] output. If using dummy keys, expected to see 'Firestore write failed' and saving to offline queue.")
    
    if os.path.exists(config["cloud_offline_queue_path"]):
        print(f"Offline queue created at {config['cloud_offline_queue_path']}")
        with open(config["cloud_offline_queue_path"], "r") as f:
            lines = f.readlines()
            print(f"Items in offline queue: {len(lines)} (expected: 1)")

if __name__ == "__main__":
    test_cloud_uploader()
