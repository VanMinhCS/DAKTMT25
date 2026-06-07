import json
import re
import threading
import paho.mqtt.client as mqtt
from ..core.logger import get_logger
from ..core import metrics

logger = get_logger("IoTClient")

# ── Reconnect backoff config ──────────────────────────────────────────────────
_RECONNECT_DELAY_INIT = 5    # giây — lần thử đầu tiên
_RECONNECT_DELAY_MAX  = 60   # giây — giới hạn tối đa (tránh backoff vô hạn)


class IoTClient:
    """
    MQTT client kết nối với ThingsBoard/CoreIoT.

    Tính năng:
    - Tự động reconnect với exponential backoff khi mất kết nối.
    - Re-subscribe topics sau mỗi lần reconnect thành công.
    - Hỗ trợ callback OTA và test image từ ThingsBoard attributes.
    """

    def __init__(self, config: dict):
        self.config    = config
        self.client    = None
        self.connected = False
        self._running  = False

        # Callbacks — được wire từ main.py
        self.on_test_image_received = None
        self.on_update_received     = None

        # Reconnect state
        self._reconnect_delay  = _RECONNECT_DELAY_INIT
        self._reconnect_timer  = None
        self._reconnect_lock   = threading.Lock()

    # ── Lifecycle ─────────────────────────────────────────────────────────────

    def start(self):
        host  = self.config.get('thingsboard_host')
        token = self.config.get('thingsboard_access_token')

        if not host or not token:
            logger.warning("IoT config missing: host or access token not set.")
            return

        self._running = True
        self._host    = host
        self._token   = token

        self._build_client()
        self._connect()

    def stop(self):
        self._running = False
        self._cancel_reconnect_timer()
        if self.client:
            try:
                self.client.loop_stop()
                self.client.disconnect()
            except Exception:
                pass
        logger.info("IoTClient stopped.")

    # ── Public API ────────────────────────────────────────────────────────────

    def send_telemetry(self, data: dict):
        if self.client and self.connected:
            try:
                payload = json.dumps(data)
                size_kb = len(payload) / 1024
                logger.debug("Sending telemetry (%.2f KB)...", size_kb)

                info = self.client.publish('v1/devices/me/telemetry', payload)
                if info.rc != mqtt.MQTT_ERR_SUCCESS:
                    logger.error("MQTT publish failed, rc=%d", info.rc)
            except Exception as e:
                logger.error("Send error: %s", e)
        else:
            logger.warning("MQTT not connected — telemetry skipped.")

    # ── Internal setup ────────────────────────────────────────────────────────

    def _build_client(self):
        """Tạo mới MQTT client và gán callbacks."""
        self.client = mqtt.Client(
            callback_api_version=mqtt.CallbackAPIVersion.VERSION2
        )
        self.client.on_connect    = self._on_connect
        self.client.on_disconnect = self._on_disconnect
        self.client.on_message    = self._on_message
        self.client.username_pw_set(self._token)

    def _connect(self):
        """Thực hiện kết nối lần đầu."""
        try:
            self.client.connect(self._host, 1883, keepalive=60)
            self.client.loop_start()
            logger.info("Connecting to ThingsBoard at %s...", self._host)
        except Exception as e:
            logger.error("Initial connection failed: %s", e)
            self._schedule_reconnect()

    def _subscribe_topics(self):
        """Đăng ký lại tất cả topics sau mỗi lần connect/reconnect."""
        self.client.subscribe('v1/devices/me/attributes')
        # Yêu cầu shared attributes từ server (thêm firmware_sha256 cho OTA verify)
        self.client.publish(
            'v1/devices/me/attributes/request/1',
            '{"sharedKeys":"target_version,firmware_url,firmware_sha256"}'
        )

    # ── Reconnect logic ───────────────────────────────────────────────────────

    def _schedule_reconnect(self):
        """Lên lịch reconnect với exponential backoff, thread-safe."""
        if not self._running:
            return

        with self._reconnect_lock:
            self._cancel_reconnect_timer()
            delay = self._reconnect_delay
            logger.info("Reconnecting in %ds... (backoff: %ds)", delay, delay)

            self._reconnect_timer = threading.Timer(delay, self._do_reconnect)
            self._reconnect_timer.daemon = True
            self._reconnect_timer.start()

            # Tăng backoff cho lần thử tiếp theo (exponential, giới hạn max)
            self._reconnect_delay = min(self._reconnect_delay * 2, _RECONNECT_DELAY_MAX)

    def _do_reconnect(self):
        """Thực thi reconnect — chạy trong timer thread."""
        if not self._running:
            return

        logger.info("Attempting reconnect...")
        try:
            # Tái sử dụng client object (loop đã được start từ _connect)
            self.client.reconnect()
            # _on_connect sẽ được gọi tự động khi thành công
        except Exception as e:
            logger.warning("Reconnect attempt failed: %s", e)
            self._schedule_reconnect()  # Thử lại theo backoff mới

    def _cancel_reconnect_timer(self):
        """Hủy timer reconnect đang chờ (nếu có)."""
        if self._reconnect_timer:
            self._reconnect_timer.cancel()
            self._reconnect_timer = None

    def _reset_backoff(self):
        """Reset delay về giá trị ban đầu sau khi connect thành công."""
        self._reconnect_delay = _RECONNECT_DELAY_INIT

    # ── MQTT Callbacks ────────────────────────────────────────────────────────

    def _on_connect(self, client, userdata, flags, rc, properties=None):
        if rc == 0:
            self.connected = True
            self._cancel_reconnect_timer()
            self._reset_backoff()
            logger.info("Connected to ThingsBoard!")
            metrics.log_iot_event("MQTT_CONNECTED", {"host": self._host})
            self._subscribe_topics()
        else:
            logger.error("Connection failed, rc=%d. Will retry...", rc)
            self._schedule_reconnect()

    def _on_disconnect(self, client, userdata, flags, rc, properties=None):
        self.connected = False
        if rc == 0:
            # Disconnect chủ động (gọi stop()) — không reconnect
            logger.info("Disconnected gracefully.")
        else:
            # Mất kết nối bất ngờ — bắt đầu reconnect
            logger.warning("Unexpected disconnect (rc=%d). Scheduling reconnect...", rc)
            metrics.log_iot_event("MQTT_DISCONNECT", {
                "rc":   rc,
                "host": getattr(self, "_host", "unknown"),
            })
            self._schedule_reconnect()

    def _on_message(self, client, userdata, msg):
        if not msg.topic.startswith('v1/devices/me/attributes'):
            return

        try:
            data = json.loads(msg.payload.decode())
            data = data.get('shared', data)

            # ── OTA Update ────────────────────────────────────────────────
            if data.get('target_version') and self.on_update_received:
                self.on_update_received(
                    data.get('target_version'),
                    data.get('firmware_url'),
                    data.get('firmware_sha256', ''),   # truyền sha256 để verify
                )

            # ── Test Image ────────────────────────────────────────────────
            if data.get('image_request') and self.on_test_image_received:
                b64_img, req_id = self._parse_image_request(data['image_request'])
                if b64_img:
                    threading.Thread(
                        target=self.on_test_image_received,
                        args=(b64_img, req_id),
                        daemon=True
                    ).start()

        except Exception as e:
            logger.error("MQTT message handler error: %s", e)

    # ── Image request parser ──────────────────────────────────────────────────

    def _parse_image_request(self, payload) -> tuple[str | None, str | None]:
        """
        Parse image_request attribute từ ThingsBoard.
        Hỗ trợ 3 định dạng:
          1. Dict  : {"image": "<base64>", "uuid": "<id>"}
          2. JSON  : chuỗi JSON của dict trên
          3. Custom: "uuid:<id>,image:<base64>"
          4. Raw   : chuỗi base64 thuần

        Returns:
            (b64_image, request_id) hoặc (None, None) nếu parse thất bại.
        """
        b64_img = None
        req_id  = None

        try:
            # ── Trường hợp 1: dict trực tiếp ──────────────────────────────
            if isinstance(payload, dict):
                b64_img = payload.get('image')
                req_id  = payload.get('uuid')
                logger.debug("image_request parsed as dict.")
                return b64_img, req_id

            if not isinstance(payload, str):
                logger.warning("image_request has unexpected type: %s", type(payload))
                return None, None

            logger.debug("image_request (str, len=%d): %s...", len(payload), payload[:60])
            s = payload.strip()

            # ── Trường hợp 2: JSON string ─────────────────────────────────
            if s.startswith('{'):
                try:
                    parsed = json.loads(s)
                    b64_img = parsed.get('image')
                    req_id  = parsed.get('uuid')
                    logger.debug("image_request parsed as JSON string.")
                    return b64_img, req_id
                except json.JSONDecodeError as e:
                    logger.debug("JSON parse failed: %s", e)

            # ── Trường hợp 3: custom "uuid:...,image:..." ─────────────────
            if s.startswith('uuid:'):
                match = re.search(
                    r'uuid:\s*([^,]+),\s*image:\s*(.+)', s, re.DOTALL
                )
                if match:
                    req_id  = match.group(1).strip()
                    b64_img = match.group(2).strip()
                    logger.debug("image_request parsed as custom format. UUID: %s", req_id)
                    return b64_img, req_id
                else:
                    logger.debug("Custom-format regex did not match.")

            # ── Trường hợp 4: raw base64 string ──────────────────────────
            logger.debug("Treating image_request as raw base64 string.")
            b64_img = payload

        except Exception as e:
            logger.error("Error parsing image_request: %s", e)

        return b64_img, req_id
