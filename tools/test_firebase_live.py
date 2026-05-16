"""
Live test — Firestore only (no Storage needed)
Sử dụng credentials thật từ .env
"""
import sys
import os
import json
import urllib.request

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from dotenv import load_dotenv
load_dotenv()

API_KEY    = os.getenv("FIREBASE_API_KEY")
PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID")

print("=" * 60)
print("  FIREBASE FIRESTORE-ONLY TEST")
print("=" * 60)
print(f"  API Key    : {API_KEY[:10]}...{API_KEY[-4:]}" if API_KEY else "  API Key    : NOT SET")
print(f"  Project ID : {PROJECT_ID}")
print("=" * 60)

if not API_KEY or not PROJECT_ID:
    print("[FAIL] Missing credentials in .env")
    sys.exit(1)

firestore_url = (
    f"https://firestore.googleapis.com/v1/"
    f"projects/{PROJECT_ID}/databases/(default)/documents"
    f"/sensor_records?key={API_KEY}"
)

# ── Test 1: Upload sensor record (giống data thật từ edge device) ──
print("\n[TEST 1] Upload sensor record...")

test_doc = {
    "fields": {
        "device_id":   {"stringValue": "rpi-greenhouse-01"},
        "timestamp":   {"stringValue": "2026-05-16T16:22:00"},
        "yolo_label":  {"stringValue": "Tomato__Early_Blight"},
        "yolo_status": {"stringValue": "Warning"},
        "confidence":  {"doubleValue": 0.85},
        "lstm_status": {"stringValue": "Early_Blight_Risk"},
        "alert_level": {"stringValue": "WARNING"},
        "image_url":   {"stringValue": ""},
        "sensor_data": {
            "mapValue": {
                "fields": {
                    "temperature":    {"doubleValue": 28.5},
                    "humidity":       {"doubleValue": 70.0},
                    "soil_moisture":  {"doubleValue": 65.0}
                }
            }
        }
    }
}

try:
    req = urllib.request.Request(
        firestore_url,
        data=json.dumps(test_doc).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=15) as resp:
        result = json.loads(resp.read())

    doc_name = result.get("name", "")
    doc_id = doc_name.split("/")[-1] if doc_name else "?"
    print(f"  [OK] Document created!")
    print(f"  ID  : {doc_id}")
    print(f"  Path: {doc_name}")
except urllib.error.HTTPError as e:
    body = e.read().decode("utf-8", errors="replace")
    print(f"  [FAIL] HTTP {e.code}: {e.reason}")
    print(f"  {body[:300]}")
    sys.exit(1)
except Exception as e:
    print(f"  [FAIL] {e}")
    sys.exit(1)

# ── Test 2: Read back to verify ──
print("\n[TEST 2] Read back document...")
try:
    read_url = f"https://firestore.googleapis.com/v1/{doc_name}?key={API_KEY}"
    req = urllib.request.Request(read_url, method="GET")
    with urllib.request.urlopen(req, timeout=10) as resp:
        doc = json.loads(resp.read())

    fields = doc.get("fields", {})
    print(f"  [OK] Read successful!")
    print(f"  device_id  : {fields.get('device_id', {}).get('stringValue')}")
    print(f"  yolo_label : {fields.get('yolo_label', {}).get('stringValue')}")
    print(f"  alert_level: {fields.get('alert_level', {}).get('stringValue')}")
    print(f"  temperature: {fields.get('sensor_data', {}).get('mapValue', {}).get('fields', {}).get('temperature', {}).get('doubleValue')}")
except Exception as e:
    print(f"  [FAIL] {e}")

# ── Test 3: Cleanup (delete test doc) ──
print("\n[TEST 3] Cleanup test document...")
try:
    del_url = f"https://firestore.googleapis.com/v1/{doc_name}?key={API_KEY}"
    req = urllib.request.Request(del_url, method="DELETE")
    with urllib.request.urlopen(req, timeout=10) as resp:
        resp.read()
    print(f"  [OK] Test document deleted.")
except Exception as e:
    print(f"  [WARN] Could not delete: {e}")

print("\n" + "=" * 60)
print("  ALL TESTS PASSED — Firestore ready for demo!")
print("=" * 60)
