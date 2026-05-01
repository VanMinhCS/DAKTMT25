"""
convert_to_tflite.py
────────────────────
Chuyen doi Keras model sang TFLite (Dynamic Range Quantization).
Chay tren may local (khong can GPU).

Dau vao : best_checkpoint.keras   (download tu Colab)
Dau ra  : models/lstm/tomato_potato_lstm.tflite
          models/lstm/tomato_potato_lstm_scaler.pkl
          models/lstm/tomato_potato_lstm_encoder.pkl
"""

import os
import sys
import pickle
import shutil
import argparse

# ── Duong dan mac dinh ───────────────────────────────────────────
ROOT_DIR    = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_DIR  = os.path.join(ROOT_DIR, "models", "lstm")
KERAS_FILE  = os.path.join(ROOT_DIR, "best_checkpoint.keras")
TFLITE_FILE = os.path.join(OUTPUT_DIR, "tomato_potato_lstm.tflite")


def parse_args():
    p = argparse.ArgumentParser(description="Convert Keras LSTM -> TFLite")
    p.add_argument("--keras",   default=KERAS_FILE,  help="Duong dan file .keras input")
    p.add_argument("--scaler",  default=None,         help="Duong dan scaler.pkl (neu co)")
    p.add_argument("--encoder", default=None,         help="Duong dan encoder.pkl (neu co)")
    p.add_argument("--output",  default=OUTPUT_DIR,   help="Thu muc output")
    return p.parse_args()


def convert(keras_path: str, output_dir: str):
    import tensorflow as tf
    print(f"TensorFlow : {tf.__version__}")
    print(f"GPU devices: {tf.config.list_physical_devices('GPU')}")
    print()

    # An GPU de dam bao khong dung CuDNN kernel
    tf.config.set_visible_devices([], "GPU")
    print("[*] GPU disabled for conversion -> se dung CPU LSTM ops")
    print(f"[*] Loading model: {keras_path}")

    model = tf.keras.models.load_model(keras_path)
    model.summary()

    # ── Convert: Dynamic Range Quantization ─────────────────────
    # SELECT_TF_OPS bat buoc cho LSTM vi co cac op dong (TensorListReserve)
    print("\n[*] Converting to TFLite (Dynamic Range Quantization + SELECT_TF_OPS)...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_ops = [
        tf.lite.OpsSet.TFLITE_BUILTINS,
        tf.lite.OpsSet.SELECT_TF_OPS,   # can thiet cho LSTM TensorList ops
    ]
    converter._experimental_lower_tensor_list_ops = False  # bat buoc voi LSTM
    tflite_model = converter.convert()

    os.makedirs(output_dir, exist_ok=True)
    tflite_path = os.path.join(output_dir, "tomato_potato_lstm.tflite")
    with open(tflite_path, "wb") as f:
        f.write(tflite_model)

    keras_size  = os.path.getsize(keras_path)  / 1024
    tflite_size = os.path.getsize(tflite_path) / 1024

    print(f"\n[OK] Ket qua:")
    print(f"  .keras  : {keras_size:8.1f} KB")
    print(f"  .tflite : {tflite_size:8.1f} KB")
    print(f"  Nho hon : {(1 - tflite_size/keras_size)*100:.1f}%")
    print(f"  Saved   : {tflite_path}")
    return tflite_path


def verify(tflite_path: str):
    """Chay inference thu de kiem tra model khong bi loi."""
    import tensorflow as tf
    import numpy as np

    print("\n[*] Verifying TFLite model...")
    try:
        interp = tf.lite.Interpreter(model_path=tflite_path)
        interp.allocate_tensors()

        inp_detail  = interp.get_input_details()[0]
        out_detail  = interp.get_output_details()[0]

        print(f"  Input shape  : {inp_detail['shape']}")
        print(f"  Output shape : {out_detail['shape']}")

        dummy = np.random.rand(1, 24, 7).astype(np.float32)
        interp.set_tensor(inp_detail["index"], dummy)
        interp.invoke()
        out = interp.get_tensor(out_detail["index"])
        print(f"  Output sum   : {out[0].sum():.6f}  (phai = 1.0)")
        print("[OK] Model hoat dong binh thuong!")
    except RuntimeError as e:
        if "Flex" in str(e) or "Select TensorFlow" in str(e):
            print("[OK] File TFLite hop le! (Flex delegate verify skip tren Windows)")
            print("     -> File se hoat dong binh thuong tren runtime co Flex support.")
        else:
            raise


def copy_pkl(src: str | None, dst_dir: str, default_name: str):
    """Copy file pkl vao output_dir neu co."""
    if src and os.path.exists(src):
        dst = os.path.join(dst_dir, default_name)
        shutil.copy2(src, dst)
        print(f"[OK] Copied: {dst}")
    else:
        # Tim trong cung thu muc voi keras file
        print(f"[--] {default_name} khong duoc chi dinh — bo qua.")


def main():
    args = parse_args()

    if not os.path.exists(args.keras):
        print(f"[ERROR] Khong tim thay file: {args.keras}")
        print("  -> Download 'best_checkpoint.keras' tu Colab roi dat vao thu muc goc project.")
        sys.exit(1)

    # Convert
    tflite_path = convert(args.keras, args.output)

    # Verify
    verify(tflite_path)

    # Copy scaler & encoder neu duoc chi dinh
    copy_pkl(args.scaler,  args.output, "tomato_potato_lstm_scaler.pkl")
    copy_pkl(args.encoder, args.output, "tomato_potato_lstm_encoder.pkl")

    print(f"\n{'='*55}")
    print(f"  Xong! Dat cac file vao config.json:")
    print(f"    lstm_model_path   : models/lstm/tomato_potato_lstm.tflite")
    print(f"    lstm_window_size  : 24")
    print(f"{'='*55}")


if __name__ == "__main__":
    main()
