import os
import sys
import hashlib
import zipfile
import requests
from ..core.logger import get_logger

logger = get_logger("OTA")

# Danh sách extension được phép giải nén (phòng thủ Zip Path Traversal)
_ALLOWED_EXTENSIONS = {".py", ".json", ".txt", ".md", ".onnx", ".tflite", ".pkl", ".sh"}


class OTAManager:
    """
    Quản lý quá trình cập nhật firmware qua mạng (Over-The-Air).

    Lý do tách ra: OTA là một luồng xử lý độc lập, có thể nâng cấp
    sau này thành delta-update hoặc rollback mà không đụng đến main.py.

    Bảo mật:
      - Verify SHA-256 checksum trước khi giải nén.
      - Kiểm tra Zip Path Traversal (không cho phép '../' trong tên file).
      - Chỉ giải nén các extension trong _ALLOWED_EXTENSIONS.
    """

    def __init__(self, config: dict):
        self.config = config

    def handle_update(self, target_version: str, url: str,
                      expected_sha256: str = "", stop_callback=None):
        """
        Kiểm tra version, tải, verify checksum, giải nén và restart app.

        Args:
            target_version:  Version mục tiêu nhận từ ThingsBoard.
            url:             URL tải file .zip cập nhật.
            expected_sha256: SHA-256 hex digest của file zip (từ ThingsBoard attribute).
                             Bỏ trống "" để bỏ qua verify (không khuyến khích).
            stop_callback:   Hàm gọi trước khi restart (thường là app.stop()).
        """
        current_version = self.config.get('current_version', 'v1.0')

        if target_version == current_version:
            return  # Đã là phiên bản mới nhất, không làm gì

        logger.info("New firmware detected: %s → %s", current_version, target_version)

        try:
            # 1. Tải file zip
            logger.info("Downloading update from: %s", url)
            r = requests.get(url, timeout=60)
            r.raise_for_status()

            zip_bytes = r.content

            # 2. Verify SHA-256 checksum (nếu được cung cấp)
            if expected_sha256:
                actual_sha256 = hashlib.sha256(zip_bytes).hexdigest()
                if actual_sha256.lower() != expected_sha256.lower():
                    logger.error(
                        "OTA ABORTED: Checksum mismatch! "
                        "expected=%s actual=%s",
                        expected_sha256, actual_sha256
                    )
                    return   # Từ chối cài đặt — không giải nén
                logger.info("Checksum OK: %s", actual_sha256)
            else:
                logger.warning(
                    "OTA: No expected_sha256 provided — skipping checksum verification. "
                    "Set 'firmware_sha256' attribute on ThingsBoard for security."
                )

            # 3. Lưu zip tạm
            with open("update.zip", "wb") as f:
                f.write(zip_bytes)
            logger.info("Download complete. Verifying archive...")

            # 4. Kiểm tra Zip Path Traversal trước khi giải nén
            with zipfile.ZipFile("update.zip", 'r') as z:
                for name in z.namelist():
                    # Chặn absolute path và directory traversal
                    if os.path.isabs(name) or ".." in name.split("/"):
                        logger.error("OTA ABORTED: Dangerous path in zip: '%s'", name)
                        os.remove("update.zip")
                        return

                    # Chỉ cho phép extension trong whitelist
                    _, ext = os.path.splitext(name)
                    if ext and ext.lower() not in _ALLOWED_EXTENSIONS:
                        logger.warning("OTA: Skipping file with disallowed extension: '%s'", name)
                        continue

                logger.info("Archive OK. Extracting...")
                z.extractall(".")

            os.remove("update.zip")

            # 5. Dừng app và restart
            logger.info("Update installed successfully. Restarting...")
            if stop_callback:
                stop_callback()

            os.execv(sys.executable, ['python'] + sys.argv)

        except Exception as e:
            logger.error("OTA update failed: %s", e)
            # Dọn dẹp file tạm nếu còn tồn tại
            if os.path.exists("update.zip"):
                os.remove("update.zip")

