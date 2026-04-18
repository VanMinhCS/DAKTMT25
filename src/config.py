"""
AppConfig — Định nghĩa và validate toàn bộ cấu hình ứng dụng.

Tại sao dùng Pydantic:
  - Phát hiện lỗi config NGAY KHI KHỞI ĐỘNG, không phải lúc runtime.
  - Tự động ép kiểu (str "0.65" → float 0.65).
  - Constraint rõ ràng (ge=0.0, le=1.0) thay vì bug âm thầm.
  - IDE auto-complete cho config keys.

Cách dùng:
    from src.config import AppConfig
    cfg = AppConfig.from_file("config.json")  # validate + trả về AppConfig
    cfg.as_dict()                              # → dict tương thích với code cũ
"""

from __future__ import annotations

from pydantic import BaseModel, Field, model_validator
from typing import Any


class AppConfig(BaseModel):
    """
    Schema đầy đủ của config.json + biến môi trường.
    model_config extra="ignore" để bỏ qua các key _comment_* trong JSON.
    """

    model_config = {"extra": "ignore"}

    # ── Camera ────────────────────────────────────────────────────────────
    camera_id:     Any = 0          # int hoặc string (RTSP URL)
    camera_width:  int = Field(640, ge=160,  description="Chiều rộng frame camera (px)")
    camera_height: int = Field(480, ge=120,  description="Chiều cao frame camera (px)")

    # ── AI / YOLO ─────────────────────────────────────────────────────────
    model_path:           str   = "models/yolo/plant_disease_v4.pt"
    confidence_threshold: float = Field(0.65, ge=0.0, le=1.0,
                                        description="Ngưỡng confidence YOLO (0.0–1.0)")
    inference_imgsz:      int   = Field(480, ge=320, le=1280,
                                        description="Kích thước ảnh khi inference (px)")

    # ── RTSP Streaming ─────────────────────────────────────────────────────
    rtsp_stream_name: str  = "mystream"
    show_fps:         bool = True

    # ── IoT / ThingsBoard (secrets từ .env) ───────────────────────────────
    thingsboard_host:         str = ""
    thingsboard_access_token: str = ""
    send_interval_seconds:    int = Field(10, ge=1, le=3600,
                                          description="Chu kỳ gửi báo cáo (giây)")
    current_version: str = "v1.0"

    # ── Device identity (từ .env) ──────────────────────────────────────────
    deviceId: str = "unknown-device"
    plantId:  str = "unknown-plant"

    # ── Feature Flags ─────────────────────────────────────────────────────
    enable_camera:  bool = True
    enable_sensor:  bool = True
    enable_mqtt:    bool = True
    enable_streamer: bool = True
    enable_lstm:    bool = True

    # ── Sensor Server ─────────────────────────────────────────────────────
    sensor_server_port: int = Field(5000, ge=1024, le=65535,
                                     description="Port HTTP nhận dữ liệu cảm biến")

    # ── LSTM ──────────────────────────────────────────────────────────────
    lstm_model_path:   str = "models/lstm/potato_health_lstm.h5"
    lstm_scaler_path:  str = "models/lstm/potato_scaler.pkl"
    lstm_encoder_path: str = "models/lstm/potato_encoder.pkl"
    lstm_window_size:  int = Field(12, ge=1,
                                   description="Số bước thời gian LSTM cần để predict")

    # Giá trị mặc định khi sensor không gửi đủ 7 feature
    lstm_default_soil_moisture:    float = Field(72.0,   ge=0.0)
    lstm_default_soil_temperature: float = Field(18.0,   ge=-50.0, le=100.0)
    lstm_default_ec:               float = Field(1200.0, ge=0.0)
    lstm_default_ph:               float = Field(6.0,    ge=0.0,   le=14.0)
    lstm_default_nitrogen:         float = Field(60.0,   ge=0.0)
    lstm_default_phosphorus:       float = Field(40.0,   ge=0.0)
    lstm_default_potassium:        float = Field(160.0,  ge=0.0)

    # ── Cross-field validation ─────────────────────────────────────────────
    @model_validator(mode="after")
    def _check_mqtt_secrets(self) -> "AppConfig":
        """Cảnh báo (không crash) nếu MQTT bật mà chưa có credentials."""
        if self.enable_mqtt and (
            not self.thingsboard_host or not self.thingsboard_access_token
        ):
            import logging
            logging.getLogger("Config").warning(
                "enable_mqtt=True but thingsboard_host or access_token is empty. "
                "Did you forget to set up .env?"
            )
        return self

    # ── Helpers ───────────────────────────────────────────────────────────

    def as_dict(self) -> dict:
        """Trả về config dưới dạng dict — tương thích với code cũ dùng .get()."""
        return self.model_dump()

    @classmethod
    def from_dict(cls, data: dict) -> "AppConfig":
        """Validate và tạo AppConfig từ dict (đã merge env vars)."""
        return cls.model_validate(data)

    def summary(self) -> str:
        """Tạo chuỗi tóm tắt config để log lúc khởi động."""
        lines = [
            "─" * 52,
            f"  Config Summary",
            "─" * 52,
            f"  Device      : {self.deviceId}",
            f"  Plant       : {self.plantId}",
            f"  Model       : {self.model_path}",
            f"  Confidence  : {self.confidence_threshold}",
            f"  Img size    : {self.inference_imgsz}px",
            f"  MQTT host   : {self.thingsboard_host or '(not set)'}",
            f"  Send every  : {self.send_interval_seconds}s",
            f"  LSTM window : {self.lstm_window_size} steps",
            "─" * 52,
        ]
        return "\n".join(lines)
