"""
MetricsLogger — Ghi log đánh giá hệ thống phục vụ luận văn.

Đặc điểm:
  - Mỗi sự kiện là một dòng JSON (JSONL) trong file logs/evaluation_metrics.jsonl.
  - KHÔNG bao giờ in ra terminal (logger.propagate = False).
  - Toàn bộ module là stateless ở phía caller: chỉ cần gọi hàm tiện ích.
  - Tất cả hàm là no-op nếu chưa gọi init() hoặc enabled=False.

Cách dùng:
    # Trong main.py (sau khi load config):
    from src.core import metrics
    metrics.init(config)

    # Trong bất kỳ module nào:
    from src.core import metrics
    metrics.log_ai_performance(yolo_ms=12.5, num_boxes=2, avg_conf=0.87)
"""

from __future__ import annotations

import json
import logging
import os
import time
from datetime import datetime

# ── Singleton logger (file-only, không propagate lên root) ───────────────────
_logger: logging.Logger | None = None
_enabled: bool = False

# ── Tên event ─────────────────────────────────────────────────────────────────
EVT_AI_PERF       = "AI_PERFORMANCE"
EVT_LSTM_PERF     = "LSTM_PERFORMANCE"
EVT_SYS_RESOURCES = "SYSTEM_RESOURCES"
EVT_ALERT         = "ALERT_TRANSITION"
EVT_IOT           = "IOT_EVENT"


# ══════════════════════════════════════════════════════════════════════════════
# Public API — init
# ══════════════════════════════════════════════════════════════════════════════

def init(config: dict) -> None:
    """
    Khởi tạo MetricsLogger từ config dict.
    Gọi một lần duy nhất trong main.py sau khi load_config().
    """
    global _logger, _enabled

    _enabled = config.get("enable_metrics_log", True)
    if not _enabled:
        return

    log_path = config.get("metrics_log_path", "logs/evaluation_metrics.jsonl")
    os.makedirs(os.path.dirname(log_path), exist_ok=True)

    logger = logging.getLogger("_Metrics_")
    logger.setLevel(logging.DEBUG)
    # QUAN TRỌNG: propagate=False → không lên root logger → không ra terminal
    logger.propagate = False

    # Xóa handler cũ nếu init() được gọi lại
    for h in logger.handlers[:]:
        logger.removeHandler(h)

    handler = logging.FileHandler(log_path, encoding="utf-8", mode="a")
    # Format: chỉ in nội dung JSON, không prefix timestamp của logging
    handler.setFormatter(logging.Formatter("%(message)s"))
    logger.addHandler(handler)

    _logger = logger


# ══════════════════════════════════════════════════════════════════════════════
# Internal helper
# ══════════════════════════════════════════════════════════════════════════════

def _write(event_type: str, data: dict) -> None:
    """Ghi một dòng JSON vào file JSONL."""
    if _logger is None:
        return
    record = {
        "ts":    datetime.now().isoformat(timespec="milliseconds"),
        "event": event_type,
        **data,
    }
    _logger.info(json.dumps(record, ensure_ascii=False))


# ══════════════════════════════════════════════════════════════════════════════
# Public API — log functions
# ══════════════════════════════════════════════════════════════════════════════

def log_ai_performance(yolo_ms: float, num_boxes: int, avg_conf: float,
                       pre_ms: float = 0.0) -> None:
    """
    Ghi kết quả một lần chạy YOLO inference.

    Args:
        yolo_ms:   Thời gian inference thuần (milli-giây).
        num_boxes: Số bounding box vượt ngưỡng confidence.
        avg_conf:  Trung bình confidence của các box tìm được (0.0 nếu không có).
        pre_ms:    Thời gian preprocessing letterbox+normalize (milli-giây).
    """
    _write(EVT_AI_PERF, {
        "yolo_ms":   round(yolo_ms, 2),
        "pre_ms":    round(pre_ms, 2),
        "total_ms":  round(yolo_ms + pre_ms, 2),
        "num_boxes": num_boxes,
        "avg_conf":  round(avg_conf, 4),
    })


def log_lstm_performance(lstm_ms: float, label: str, confidence: float) -> None:
    """
    Ghi kết quả một lần chạy LSTM inference.

    Args:
        lstm_ms:    Thời gian invoke() (milli-giây).
        label:      Nhãn dự đoán (vd: "Healthy", "Early_Blight_Risk").
        confidence: Xác suất của nhãn thắng (0.0–1.0).
    """
    _write(EVT_LSTM_PERF, {
        "lstm_ms":    round(lstm_ms, 2),
        "label":      label,
        "confidence": round(confidence, 4),
    })


def log_system_resources(ram_available_mb: float,
                         temperature_c: float | None,
                         cpu_percent: float | None = None) -> None:
    """
    Ghi thông số tài nguyên hệ thống (đọc từ /proc, không cần psutil).

    Args:
        ram_available_mb: RAM còn trống (MB).
        temperature_c:    Nhiệt độ CPU (°C), None nếu không đọc được.
        cpu_percent:      Mức dùng CPU (%), None nếu không đọc được.
    """
    data: dict = {"ram_available_mb": ram_available_mb}
    if temperature_c is not None:
        data["temperature_c"] = temperature_c
    if cpu_percent is not None:
        data["cpu_percent"] = cpu_percent
    _write(EVT_SYS_RESOURCES, data)


def log_alert_transition(old_level: str | None,
                         new_level: str,
                         yolo_status: str,
                         lstm_status: str | None) -> None:
    """
    Ghi khi mức cảnh báo thay đổi (Decision Fusion).

    Args:
        old_level:   Mức cũ (None nếu lần đầu tiên).
        new_level:   Mức mới (NORMAL / PRE_WARNING / WARNING / VERIFICATION / CRITICAL).
        yolo_status: Trạng thái YOLO tại thời điểm này.
        lstm_status: Nhãn LSTM tại thời điểm này.
    """
    _write(EVT_ALERT, {
        "from":        old_level or "INIT",
        "to":          new_level,
        "yolo_status": yolo_status,
        "lstm_status": lstm_status or "N/A",
    })


def log_iot_event(sub_event: str, details: dict | None = None) -> None:
    """
    Ghi sự kiện IoT (MQTT disconnect, sensor error, v.v.).

    Args:
        sub_event: Tên sự kiện cụ thể (vd: "MQTT_DISCONNECT", "SENSOR_ERROR").
        details:   Thông tin bổ sung tùy ý.
    """
    payload: dict = {"sub_event": sub_event}
    if details:
        payload.update(details)
    _write(EVT_IOT, payload)


# ══════════════════════════════════════════════════════════════════════════════
# System resource readers (không dùng psutil, an toàn trên Yocto Linux)
# ══════════════════════════════════════════════════════════════════════════════

def read_ram_available_mb() -> float | None:
    """Đọc RAM còn trống (MB) từ /proc/meminfo."""
    try:
        with open("/proc/meminfo", "r") as f:
            for line in f:
                if line.startswith("MemAvailable:"):
                    kb = int(line.split()[1])
                    return round(kb / 1024.0, 1)
    except Exception:
        pass
    return None


def read_temperature_c() -> float | None:
    """Đọc nhiệt độ CPU (°C) từ thermal zone của Linux."""
    thermal_paths = [
        "/sys/class/thermal/thermal_zone0/temp",
        "/sys/class/thermal/thermal_zone1/temp",
    ]
    for path in thermal_paths:
        try:
            with open(path, "r") as f:
                raw = int(f.read().strip())
                # Giá trị thường là milli-Celsius (vd: 45000 = 45°C)
                return round(raw / 1000.0, 1)
        except Exception:
            continue
    return None


def read_cpu_percent(interval: float = 1.0) -> float | None:
    """
    Tính CPU usage (%) bằng cách đọc /proc/stat 2 lần cách nhau `interval` giây.
    Hoàn toàn không cần psutil.
    """
    def _parse_stat():
        try:
            with open("/proc/stat", "r") as f:
                line = f.readline()  # dòng đầu: "cpu  ..."
            parts = line.split()
            values = [int(x) for x in parts[1:]]
            total = sum(values)
            idle  = values[3]  # index 3 = idle
            return total, idle
        except Exception:
            return None, None

    t1, i1 = _parse_stat()
    if t1 is None:
        return None
    time.sleep(interval)
    t2, i2 = _parse_stat()
    if t2 is None:
        return None

    delta_total = t2 - t1
    delta_idle  = i2 - i1
    if delta_total <= 0:
        return 0.0
    return round((1.0 - delta_idle / delta_total) * 100.0, 1)
