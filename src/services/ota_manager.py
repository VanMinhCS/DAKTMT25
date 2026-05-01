import os
import sys
import requests
import zipfile
from ..core.logger import get_logger

logger = get_logger("OTA")


class OTAManager:
    """
    Quản lý quá trình cập nhật firmware qua mạng (Over-The-Air).

    Lý do tách ra: OTA là một luồng xử lý độc lập, có thể nâng cấp
    sau này thành delta-update hoặc rollback mà không đụng đến main.py.
    """

    def __init__(self, config: dict):
        self.config = config

    def handle_update(self, target_version: str, url: str, stop_callback=None):
        """
        Kiểm tra version, tải và giải nén bản cập nhật, sau đó restart app.

        Args:
            target_version: Version mục tiêu nhận từ ThingsBoard.
            url:            URL tải file .zip cập nhật.
            stop_callback:  Hàm gọi trước khi restart (thường là app.stop()).
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

            with open("update.zip", "wb") as f:
                f.write(r.content)
            logger.info("Download complete. Extracting...")

            # 2. Giải nén đè lên thư mục hiện tại
            with zipfile.ZipFile("update.zip", 'r') as z:
                z.extractall(".")

            os.remove("update.zip")

            # 3. Dừng app và restart
            logger.info("Update installed successfully. Restarting...")
            if stop_callback:
                stop_callback()

            os.execv(sys.executable, ['python'] + sys.argv)

        except Exception as e:
            logger.error("OTA update failed: %s", e)
