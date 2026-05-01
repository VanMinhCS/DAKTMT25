import json
import base64
import cv2
import numpy as np
from ..core.logger import get_logger

logger = get_logger("ImageProcessor")


class ImageProcessor:
    """
    Xử lý và nén ảnh evidence trước khi gửi qua MQTT.

    Lý do tách ra: logic này không liên quan đến việc điều phối app,
    nó là một bước xử lý dữ liệu thuần túy.
    """

    MAX_WIDTH    = 640   # px — thu nhỏ nếu ảnh rộng hơn ngưỡng này
    JPEG_QUALITY = 50    # 0-100 — chất lượng JPEG khi nén

    def compress_if_needed(self, result: dict, max_bytes: int = 60_000) -> dict:
        """
        Kiểm tra kích thước payload JSON.
        Nếu vượt quá max_bytes → nén ảnh evidence_image xuống rồi trả về.
        Nếu không cần nén hoặc nén thất bại → trả về dict gốc.
        """
        payload_str = json.dumps({"image_report": result})
        if len(payload_str) <= max_bytes:
            return result

        logger.warning("Payload too large (%d bytes). Compressing image...", len(payload_str))

        try:
            img_data = result.get("evidence_image", "")

            # Tách phần base64 thuần khỏi data URI
            if img_data and "base64," in img_data:
                img_data = img_data.split("base64,")[1]

            if not img_data:
                return result

            # Decode → numpy array
            img_bytes = base64.b64decode(img_data)
            nparr     = np.frombuffer(img_bytes, np.uint8)
            img       = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

            if img is None:
                return result

            # Thu nhỏ nếu cần
            h, w = img.shape[:2]
            if w > self.MAX_WIDTH:
                scale = self.MAX_WIDTH / w
                img = cv2.resize(img, (0, 0), fx=scale, fy=scale)

            # Re-encode với chất lượng thấp hơn
            ret, buf = cv2.imencode(
                '.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), self.JPEG_QUALITY]
            )
            if ret:
                b64_res = base64.b64encode(buf).decode('utf-8')
                result  = dict(result)  # shallow copy — không mutate dict gốc
                result["evidence_image"] = f"data:image/jpeg;base64,{b64_res}"
                logger.info("Image compressed successfully.")

        except Exception as e:
            logger.error("Image compression error: %s", e)

        return result
