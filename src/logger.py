"""
Centralized logging setup cho toàn bộ ứng dụng.

Cách dùng trong mỗi module:
    from .logger import get_logger
    logger = get_logger("TênModule")

    logger.debug("Chi tiết nội bộ, chỉ ghi vào file")
    logger.info("Sự kiện bình thường")
    logger.warning("Cảnh báo nhưng app vẫn chạy được")
    logger.error("Lỗi nghiêm trọng cần chú ý")
"""

import logging
import os
import sys
from logging.handlers import RotatingFileHandler

# ── Cấu hình chung ─────────────────────────────────────────────────────────
_LOG_DIR    = "logs"
_LOG_FILE   = os.path.join(_LOG_DIR, "app.log")
_FMT        = "%(asctime)s | %(levelname)-8s | %(name)-18s | %(message)s"
_DATE_FMT   = "%Y-%m-%d %H:%M:%S"

# Console: INFO trở lên (giữ terminal gọn)
# File:    DEBUG trở lên (lưu đầy đủ để debug sau)
_CONSOLE_LEVEL = logging.INFO
_FILE_LEVEL    = logging.DEBUG

_initialized = False  # Đảm bảo chỉ setup handler một lần


def _setup_root_logger():
    """Cấu hình root logger với console + rotating file handler."""
    global _initialized
    if _initialized:
        return
    _initialized = True

    os.makedirs(_LOG_DIR, exist_ok=True)

    root = logging.getLogger()
    root.setLevel(logging.DEBUG)

    fmt = logging.Formatter(_FMT, _DATE_FMT)

    # ── Console handler ────────────────────────────────────────────────────
    console = logging.StreamHandler(sys.stdout)
    console.setLevel(_CONSOLE_LEVEL)
    console.setFormatter(fmt)

    # ── Rotating file handler (tối đa 5 MB × 3 file) ──────────────────────
    file_h = RotatingFileHandler(
        _LOG_FILE,
        maxBytes=5 * 1024 * 1024,
        backupCount=3,
        encoding="utf-8",
    )
    file_h.setLevel(_FILE_LEVEL)
    file_h.setFormatter(fmt)

    root.addHandler(console)
    root.addHandler(file_h)

    # Tắt log verbose của các thư viện bên thứ ba
    logging.getLogger("werkzeug").setLevel(logging.ERROR)
    logging.getLogger("ultralytics").setLevel(logging.WARNING)
    logging.getLogger("tensorflow").setLevel(logging.ERROR)


def get_logger(name: str) -> logging.Logger:
    """
    Trả về logger đã được cấu hình cho module có tên `name`.
    Gọi _setup_root_logger() tự động nếu chưa khởi tạo.
    """
    _setup_root_logger()
    return logging.getLogger(name)
