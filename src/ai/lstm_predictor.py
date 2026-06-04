import numpy as np
import pickle
import collections
import time
from ..core.logger import get_logger
from ..core import metrics

logger = get_logger("LSTM")

class LSTMPredictor:
    """
    Dự đoán sức khỏe cây trồng dựa trên chuỗi dữ liệu cảm biến.

    Features (đúng thứ tự lúc train):
        Soil_Moisture, Soil_Temperature, EC, pH, Nitrogen, Phosphorus, Potassium

    Cách dùng:
        predictor = LSTMPredictor(config)
        predictor.update(sensor_list)   # gọi mỗi khi có data sensor mới
        label, conf = predictor.predict()
    """

    FEATURE_KEYS = [
        "Soil_Moisture",
        "Soil_Temperature",
        "EC",
        "pH",
        "Nitrogen",
        "Phosphorus",
        "Potassium",
    ]

    # Alias để map tên sensor từ ESP32 (lowercase) sang feature key
    SENSOR_ALIASES = {
        # Soil_Moisture
        "soil_moisture": "Soil_Moisture",
        "moisture":      "Soil_Moisture",
        # Soil_Temperature
        "soil_temperature": "Soil_Temperature",
        "temperature":      "Soil_Temperature",
        "temp":             "Soil_Temperature",
        # EC
        "ec":                      "EC",
        "electrical_conductivity": "EC",
        # pH
        "ph": "pH",
        # NPK
        "nitrogen":   "Nitrogen",
        "n":          "Nitrogen",
        "phosphorus": "Phosphorus",
        "p":          "Phosphorus",
        "potassium":  "Potassium",
        "k":          "Potassium",
    }

    def __init__(self, config: dict):
        self.config = config

        # ── Model handles (một trong hai sẽ được set sau _load) ──
        self.model       = None   # Keras model (nếu dùng .keras/.h5)
        self.interpreter = None   # TFLite interpreter (nếu dùng .tflite)
        self.input_idx   = None   # index tensor input của TFLite
        self.output_idx  = None   # index tensor output của TFLite
        self.use_tflite  = False

        self.scaler  = None
        self.encoder = None
        self.classes = []
        self.window_size = config.get("lstm_window_size", 24)

        # Default values khi sensor thiếu (đơn vị gốc, chưa scale)
        self.defaults = {
            "Soil_Moisture":    config.get("lstm_default_soil_moisture",    72.0),
            "Soil_Temperature": config.get("lstm_default_soil_temperature", 18.0),
            "EC":               config.get("lstm_default_ec",             1600.0),
            "pH":               config.get("lstm_default_ph",                6.2),
            "Nitrogen":         config.get("lstm_default_nitrogen",        130.0),
            "Phosphorus":       config.get("lstm_default_phosphorus",       55.0),
            "Potassium":        config.get("lstm_default_potassium",       210.0),
        }

        self.buffer = collections.deque(maxlen=self.window_size)
        self._load()

    # ------------------------------------------------------------------
    def _load(self):
        try:
            model_path   = self.config.get("lstm_model_path",   "models/lstm/tomato_potato_lstm.tflite")
            scaler_path  = self.config.get("lstm_scaler_path",  "models/lstm/tomato_potato_lstm_scaler.pkl")
            encoder_path = self.config.get("lstm_encoder_path", "models/lstm/tomato_potato_lstm_encoder.pkl")

            if model_path.lower().endswith(".tflite"):
                # ── TFLite path ───────────────────────────────────────────
                try:
                    import tflite_runtime.interpreter as tflite
                except ImportError:
                    import tensorflow.lite as tflite

                self.interpreter = tflite.Interpreter(model_path=model_path)
                try:
                    self.interpreter.allocate_tensors()
                except RuntimeError as flex_err:
                    # Flex delegate chua duoc link → fallback sang Keras
                    if "Flex" in str(flex_err) or "Select TensorFlow" in str(flex_err):
                        logger.warning("[TFLite] Flex delegate unavailable, falling back to Keras: %s", model_path)
                        import tensorflow as tf
                        keras_path = model_path.replace(".tflite", ".keras")
                        self.model = tf.keras.models.load_model(keras_path)
                        self.interpreter = None
                        self.use_tflite = False
                        logger.info("[Keras] Fallback model loaded: %s", keras_path)
                    else:
                        raise
                else:
                    self.input_idx  = self.interpreter.get_input_details()[0]["index"]
                    self.output_idx = self.interpreter.get_output_details()[0]["index"]
                    self.use_tflite = True
                    logger.info("[TFLite] Model loaded: %s | Window: %d", model_path, self.window_size)
            else:
                # ── Keras / HDF5 path ─────────────────────────────────────
                import tensorflow as tf
                self.model = tf.keras.models.load_model(model_path)
                self.use_tflite = False
                logger.info("[Keras] Model loaded: %s | Window: %d", model_path, self.window_size)

            import warnings
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")  # suppress sklearn InconsistentVersionWarning
                with open(scaler_path,  "rb") as f: self.scaler  = pickle.load(f)
                with open(encoder_path, "rb") as f: self.encoder = pickle.load(f)
            self.classes = list(self.encoder.classes_)
            logger.info("Classes (%d): %s", len(self.classes), self.classes)
            logger.info("Active backend: [%s] | Window: %d steps", self.backend.upper(), self.window_size)

        except Exception as e:
            logger.error("Load error: %s", e)
            self.model       = None
            self.interpreter = None

    # ------------------------------------------------------------------
    def update(self, sensor_data):
        """
        Nhận dữ liệu sensor và thêm vào buffer.

        Chấp nhận 2 format:
          1. List of dict (MQTT format từ ESP32):
             [{"type": "soil_moisture", "value": 72}, ...]
          2. Dict trực tiếp với FeatureKey:
             {"Soil_Moisture": 72, "Soil_Temperature": 18, ...}
        """
        if not sensor_data:
            return

        parsed = {}

        if isinstance(sensor_data, dict):
            # ── Format 2: dict {FeatureKey: value} ───────────────────
            for k, v in sensor_data.items():
                if k in self.FEATURE_KEYS:
                    parsed[k] = float(v)
                else:
                    alias = self.SENSOR_ALIASES.get(k.lower().strip())
                    if alias:
                        parsed[alias] = float(v)
        else:
            # ── Format 1: list of {type, value} (MQTT) ───────────────
            for item in sensor_data:
                raw_type = str(item.get("type", "")).lower().strip()
                value    = item.get("value", None)
                if value is None:
                    continue
                alias = self.SENSOR_ALIASES.get(raw_type)
                if alias:
                    parsed[alias] = float(value)

        # Build feature vector (dùng default nếu thiếu)
        row = [parsed.get(k, self.defaults[k]) for k in self.FEATURE_KEYS]
        self.buffer.append(row)

    # ------------------------------------------------------------------
    def predict(self):
        """
        Trả về (label: str, confidence: float) hoặc (None, None) nếu chưa đủ data.
        Hỗ trợ cả TFLite interpreter và Keras model.
        """
        if self.interpreter is None and self.model is None:
            return None, None
        if len(self.buffer) < self.window_size:
            remaining = self.window_size - len(self.buffer)
            logger.debug("Collecting data... (%d more readings needed)", remaining)
            return None, None

        try:
            import warnings
            with warnings.catch_warnings():
                warnings.simplefilter("ignore", UserWarning)
                seq = np.array(self.buffer, dtype=np.float32)   # (W, 7)
                seq_scaled = self.scaler.transform(seq)         # (W, 7)

            X = seq_scaled.reshape(
                1, self.window_size, len(self.FEATURE_KEYS)
            ).astype(np.float32)                                # (1, W, 7)

            if self.use_tflite:
                # ── TFLite inference (nhẹ, nhanh) ───────────────────────
                self.interpreter.set_tensor(self.input_idx, X)
                _t0 = time.perf_counter()
                self.interpreter.invoke()
                _lstm_ms = (time.perf_counter() - _t0) * 1000.0
                probs = self.interpreter.get_tensor(self.output_idx)[0]  # (n_classes,)
            else:
                # ── Keras inference ───────────────────────────────────
                _t0 = time.perf_counter()
                probs = self.model.predict(X, verbose=0)[0]
                _lstm_ms = (time.perf_counter() - _t0) * 1000.0

            idx   = int(np.argmax(probs))
            label = self.classes[idx]
            conf  = float(probs[idx])

            logger.info("Prediction: %s (%.1f%%)", label, conf * 100)

            # ── Ghi metrics (chỉ vào file, không ra terminal) ─────────────────
            metrics.log_lstm_performance(
                lstm_ms=_lstm_ms,
                label=label,
                confidence=conf,
            )

            return label, conf
        except Exception as e:
            logger.error("Predict error: %s", e)
            return None, None

    # ------------------------------------------------------------------
    def reset_buffer(self):
        """Xoá toàn bộ buffer (dùng khi reset test)."""
        self.buffer.clear()
        logger.debug("Buffer cleared.")

    @property
    def is_ready(self) -> bool:
        """True khi buffer đã đủ window_size bước."""
        return len(self.buffer) >= self.window_size

    @property
    def backend(self) -> str:
        """Trả về tên backend đang dùng: 'tflite' hoặc 'keras'."""
        if self.use_tflite:
            return "tflite"
        elif self.model is not None:
            return "keras"
        return "none"
