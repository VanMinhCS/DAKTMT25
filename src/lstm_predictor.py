import numpy as np
import pickle
import collections
from .logger import get_logger

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
        self.model   = None
        self.scaler  = None
        self.encoder = None
        self.classes = []
        self.window_size = config.get("lstm_window_size", 12)

        # Default values khi sensor thiếu (đơn vị gốc, chưa scale)
        self.defaults = {
            "Soil_Moisture":    config.get("lstm_default_soil_moisture",    72.0),
            "Soil_Temperature": config.get("lstm_default_soil_temperature", 18.0),
            "EC":               config.get("lstm_default_ec",             1200.0),
            "pH":               config.get("lstm_default_ph",                6.0),
            "Nitrogen":         config.get("lstm_default_nitrogen",         60.0),
            "Phosphorus":       config.get("lstm_default_phosphorus",       40.0),
            "Potassium":        config.get("lstm_default_potassium",       160.0),
        }

        self.buffer = collections.deque(maxlen=self.window_size)
        self._load()

    # ------------------------------------------------------------------
    def _load(self):
        try:
            import tensorflow as tf
            model_path   = self.config.get("lstm_model_path",   "model/potato_health_lstm.h5")
            scaler_path  = self.config.get("lstm_scaler_path",  "model/potato_scaler.pkl")
            encoder_path = self.config.get("lstm_encoder_path", "model/potato_encoder.pkl")

            self.model = tf.keras.models.load_model(model_path)
            with open(scaler_path, "rb")  as f: self.scaler  = pickle.load(f)
            with open(encoder_path, "rb") as f: self.encoder = pickle.load(f)
            self.classes = list(self.encoder.classes_)
            logger.info("Model loaded. Classes: %s | Window: %d",
                        self.classes, self.window_size)
        except Exception as e:
            logger.error("Load error: %s", e)
            self.model = None

    # ------------------------------------------------------------------
    def update(self, sensor_data):
        """
        Nhận dữ liệu sensor và thêm vào buffer.

        sensor_data: list of dict, ví dụ:
            [{"type": "temperature", "value": 18},
             {"type": "soil_moisture", "value": 72}, ...]
        """
        if not sensor_data:
            return

        # Parse sensor list → dict {FeatureKey: value}
        parsed = {}
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
        """
        if self.model is None:
            return None, None
        if len(self.buffer) < self.window_size:
            remaining = self.window_size - len(self.buffer)
            logger.debug("Collecting data... (%d more readings needed)", remaining)
            return None, None

        try:
            import warnings
            with warnings.catch_warnings():
                warnings.simplefilter("ignore", UserWarning)
                seq = np.array(self.buffer, dtype=np.float32)          # (W, 7)
                seq_scaled = self.scaler.transform(seq)                # (W, 7)
            
            X = seq_scaled.reshape(1, self.window_size, len(self.FEATURE_KEYS))  # (1, W, 7)

            probs = self.model.predict(X, verbose=0)[0]
            idx   = int(np.argmax(probs))
            label = self.classes[idx]
            conf  = float(probs[idx])

            logger.info("Prediction: %s (%.1f%%)", label, conf * 100)
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
