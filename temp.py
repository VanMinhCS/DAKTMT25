import subprocess
r = subprocess.run(['nvidia-smi'], capture_output=True, text=True)
print(r.stdout if r.returncode == 0 else 'Khong co GPU')
!pip install -q scikit-learn tensorflow matplotlib seaborn pandas numpy
#CELL
import tensorflow as tf
print(f'TensorFlow : {tf.__version__}')
print(f'GPU        : {tf.config.list_physical_devices("GPU")}')
gpus = tf.config.list_physical_devices('GPU')
if gpus:
    for gpu in gpus:
        tf.config.experimental.set_memory_growth(gpu, True)
#CELL
# CACH 1: Upload tu may tinh
from google.colab import files
uploaded = files.upload()   # Chon file tomato_potato_health.csv
CSV_PATH = list(uploaded.keys())[0]
print(f'File: {CSV_PATH}')
#CELL
# CACH 2: Google Drive (comment/uncomment tuy y)
# from google.colab import drive
# drive.mount('/content/drive')
# CSV_PATH = '/content/drive/MyDrive/plant_disease/tomato_potato_health.csv'
#CELL
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

plt.style.use('seaborn-v0_8-darkgrid')

df = pd.read_csv(CSV_PATH)
print(f'Shape  : {df.shape}')
print(f'Labels : {sorted(df["label"].unique())}')
print(f'Plants : {df["plant_type"].unique()}')
df.head(3)
#CELL
# Phan phoi nhan
fig, axes = plt.subplots(1, 2, figsize=(16, 5))
counts = df.groupby(['plant_type', 'label'])['sequence_id'].nunique().reset_index()
counts.columns = ['plant_type', 'label', 'count']
for ax, plant in zip(axes, ['tomato', 'potato']):
    d = counts[counts['plant_type'] == plant].sort_values('count')
    bars = ax.barh(d['label'], d['count'], color=sns.color_palette('husl', len(d)))
    ax.set_title(f'{plant.upper()} — Label distribution', fontweight='bold')
    for b, v in zip(bars, d['count']):
        ax.text(b.get_width()+5, b.get_y()+b.get_height()/2, str(v), va='center', fontsize=9)
plt.tight_layout()
plt.savefig('label_dist.png', dpi=120, bbox_inches='tight')
plt.show()
#CELL
from sklearn.preprocessing import StandardScaler, LabelEncoder

WINDOW_SIZE  = 24
FEATURE_COLS = ['Soil_Moisture', 'Soil_Temperature', 'EC',
                'pH', 'Nitrogen', 'Phosphorus', 'Potassium']

scaler  = StandardScaler()
encoder = LabelEncoder()

df_s = df.copy()
df_s[FEATURE_COLS]   = scaler.fit_transform(df[FEATURE_COLS])
df_s['label_encoded'] = encoder.fit_transform(df_s['label'])

print(f'Classes ({len(encoder.classes_)}): {list(encoder.classes_)}')
#CELL
print('Building sequences...')
X_list, y_list = [], []
for seq_id, grp in df_s.groupby('sequence_id'):
    g = grp.sort_values('timestep')
    if len(g) == WINDOW_SIZE:
        X_list.append(g[FEATURE_COLS].values)
        y_list.append(g['label_encoded'].iloc[0])

X = np.array(X_list, dtype=np.float32)
y = np.array(y_list, dtype=np.int32)
NUM_CLASSES = len(encoder.classes_)

print(f'X: {X.shape}   y: {y.shape}   Classes: {NUM_CLASSES}')
#CELL
from sklearn.model_selection import train_test_split
from sklearn.utils.class_weight import compute_class_weight
from tensorflow.keras.utils import to_categorical

X_tmp, X_test, y_tmp, y_test = train_test_split(X, y, test_size=0.10, stratify=y, random_state=42)
X_train, X_val, y_train, y_val = train_test_split(X_tmp, y_tmp, test_size=0.111, stratify=y_tmp, random_state=42)

y_train_cat = to_categorical(y_train, NUM_CLASSES)
y_val_cat   = to_categorical(y_val,   NUM_CLASSES)
y_test_cat  = to_categorical(y_test,  NUM_CLASSES)

cw_arr = compute_class_weight('balanced', classes=np.unique(y_train), y=y_train)
class_weights = dict(enumerate(cw_arr))

print(f'Train: {len(X_train):,}  Val: {len(X_val):,}  Test: {len(X_test):,}')
#CELL
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout, BatchNormalization, Input
from tensorflow.keras.regularizers import l2

model = Sequential([
    Input(shape=(WINDOW_SIZE, len(FEATURE_COLS))),
    LSTM(128, return_sequences=True,  kernel_regularizer=l2(1e-4), recurrent_regularizer=l2(1e-4)),
    BatchNormalization(), Dropout(0.3),
    LSTM(64,  return_sequences=False, kernel_regularizer=l2(1e-4)),
    BatchNormalization(), Dropout(0.3),
    Dense(128, activation='relu', kernel_regularizer=l2(1e-4)),
    Dropout(0.25),
    Dense(64, activation='relu'),
    Dropout(0.2),
    Dense(NUM_CLASSES, activation='softmax')
], name='PlantHealthLSTM')

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
    loss='categorical_crossentropy',
    metrics=['accuracy']
)
model.summary()
#CELL
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau, ModelCheckpoint, CSVLogger

callbacks = [
    EarlyStopping(monitor='val_loss', patience=12, restore_best_weights=True, verbose=1),
    ReduceLROnPlateau(monitor='val_loss', factor=0.5, patience=5, min_lr=1e-7, verbose=1),
    ModelCheckpoint('best_checkpoint.keras', monitor='val_accuracy', save_best_only=True, verbose=0),
    CSVLogger('training_log.csv')
]

history = model.fit(
    X_train, y_train_cat,
    validation_data=(X_val, y_val_cat),
    epochs=60,
    batch_size=64,
    class_weight=class_weights,
    callbacks=callbacks,
    verbose=1
)
#CELL
fig, axes = plt.subplots(1, 2, figsize=(14, 5))
for ax, metric, title in zip(axes, ['accuracy','loss'], ['Accuracy','Loss']):
    ax.plot(history.history[metric],         label='Train', lw=2, color='#2196F3')
    ax.plot(history.history[f'val_{metric}'], label='Val',   lw=2, color='#FF5722', ls='--')
    ax.set_title(f'Model {title}', fontweight='bold')
    ax.set_xlabel('Epoch'); ax.legend(); ax.grid(alpha=0.3)
plt.tight_layout()
plt.savefig('training_history.png', dpi=130, bbox_inches='tight')
plt.show()
print(f'Best val_acc  : {max(history.history["val_accuracy"]):.4f}')
print(f'Best val_loss : {min(history.history["val_loss"]):.4f}')
#CELL
from sklearn.metrics import classification_report, confusion_matrix

test_loss, test_acc = model.evaluate(X_test, y_test_cat, verbose=0)
print(f'Test Loss     : {test_loss:.4f}')
print(f'Test Accuracy : {test_acc*100:.2f}%\n')

y_pred = np.argmax(model.predict(X_test, verbose=0), axis=1)
print(classification_report(y_test, y_pred, target_names=encoder.classes_))
#CELL
cm = confusion_matrix(y_test, y_pred)
cm_n = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]

fig, axes = plt.subplots(1, 2, figsize=(18, 7))
for ax, data, fmt, title in zip(axes, [cm, cm_n], ['d', '.2f'], ['So luong', 'Ti le']):
    sns.heatmap(data, annot=True, fmt=fmt, cmap='Blues' if fmt=='d' else 'RdYlGn',
                xticklabels=encoder.classes_, yticklabels=encoder.classes_,
                ax=ax, linewidths=0.5)
    ax.set_title(f'Confusion Matrix ({title})', fontweight='bold')
    ax.set_xlabel('Predicted'); ax.set_ylabel('Actual')
    plt.setp(ax.get_xticklabels(), rotation=40, ha='right')
plt.tight_layout()
plt.savefig('confusion_matrix.png', dpi=130, bbox_inches='tight')
plt.show()
#CELL
import os, pickle, json

BASE_NAME    = 'tomato_potato_lstm'
KERAS_FILE   = f'{BASE_NAME}.keras'
TFLITE_FILE  = f'{BASE_NAME}.tflite'
SCALER_FILE  = f'{BASE_NAME}_scaler.pkl'
ENCODER_FILE = f'{BASE_NAME}_encoder.pkl'

# ── Luu Keras model tam (can cho converter) ─────────────────────
model.save(KERAS_FILE)
print(f'Saved Keras: {os.path.getsize(KERAS_FILE)/1024:.1f} KB')
#CELL
# ── Convert sang TFLite (Dynamic Range Quantization) ────────────
#
# Dynamic Range Quantization:
#   - Quantize WEIGHTS xuong INT8
#   - Activations van dung float32 luc inference
#   - Khong can calibration data
#   - Accuracy drop thap nhat (~0.1%)
#   - Size giam 2-4x
#
print('Converting to TFLite (Dynamic Range Quantization)...')

converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]   # <-- bat DRQ

tflite_model = converter.convert()

with open(TFLITE_FILE, 'wb') as f:
    f.write(tflite_model)

keras_size  = os.path.getsize(KERAS_FILE)  / 1024
tflite_size = os.path.getsize(TFLITE_FILE) / 1024

print(f'\nKet qua:')
print(f'  .keras  : {keras_size:8.1f} KB')
print(f'  .tflite : {tflite_size:8.1f} KB')
print(f'  Nho hon : {(1 - tflite_size/keras_size)*100:.1f}%')
print(f'\n[OK] Da tao: {TFLITE_FILE}')
#CELL
# ── Kiem tra accuracy cua TFLite model ─────────────────────────
print('Verifying TFLite accuracy on test set...')

interpreter = tf.lite.Interpreter(model_path=TFLITE_FILE)
interpreter.allocate_tensors()
input_idx  = interpreter.get_input_details()[0]['index']
output_idx = interpreter.get_output_details()[0]['index']

y_pred_tflite = []
for i in range(len(X_test)):
    inp = X_test[i:i+1].astype(np.float32)
    interpreter.set_tensor(input_idx, inp)
    interpreter.invoke()
    probs = interpreter.get_tensor(output_idx)[0]
    y_pred_tflite.append(np.argmax(probs))

tflite_acc = (np.array(y_pred_tflite) == y_test).mean()

print(f'\nKeras  Accuracy : {test_acc*100:.4f}%')
print(f'TFLite Accuracy : {tflite_acc*100:.4f}%')
print(f'Accuracy drop   : {abs(test_acc - tflite_acc)*100:.4f}%')

if abs(test_acc - tflite_acc) < 0.01:
    print('\n[OK] Accuracy drop < 1% -> TFLite model hop le!')
else:
    print('\n[WARN] Accuracy drop > 1% -> Nen kiem tra lai.')
#CELL
# ── Luu scaler & encoder ────────────────────────────────────────
with open(SCALER_FILE,  'wb') as f: pickle.dump(scaler,  f)
with open(ENCODER_FILE, 'wb') as f: pickle.dump(encoder, f)

# ── Metadata ────────────────────────────────────────────────────
META_FILE = f'{BASE_NAME}_metadata.json'
metadata = {
    'model_name':    BASE_NAME,
    'format':        'tflite',
    'window_size':   WINDOW_SIZE,
    'feature_cols':  FEATURE_COLS,
    'num_classes':   NUM_CLASSES,
    'classes':       list(encoder.classes_),
    'keras_acc':     float(test_acc),
    'tflite_acc':    float(tflite_acc),
    'tflite_size_kb': round(tflite_size, 1),
    'epochs_ran':    len(history.history['loss']),
}
with open(META_FILE, 'w') as f:
    json.dump(metadata, f, indent=2)

print('Files can download:')
for fname in [TFLITE_FILE, SCALER_FILE, ENCODER_FILE, META_FILE]:
    size = os.path.getsize(fname)
    print(f'  {fname:45s} {size/1024:8.1f} KB')
#CELL
# ── Download ve may ─────────────────────────────────────────────
# Dat vao thu muc models/lstm/ trong project
from google.colab import files

for fname in [TFLITE_FILE, SCALER_FILE, ENCODER_FILE, META_FILE,
              'confusion_matrix.png', 'training_history.png', 'training_log.csv']:
    if os.path.exists(fname):
        print(f'Downloading {fname}...')
        files.download(fname)

print('\nDone!')
#CELL
# Test 10 samples ngau nhien
print(f'{"Idx":>4} | {"Actual":<25} | {"Predicted":<25} | Conf   | OK?')
print('-' * 75)
correct = 0
for idx in np.random.choice(len(X_test), 10, replace=False):
    inp = X_test[idx:idx+1].astype(np.float32)
    interpreter.set_tensor(input_idx, inp)
    interpreter.invoke()
    probs    = interpreter.get_tensor(output_idx)[0]
    pred_idx = np.argmax(probs)
    pred_cls = encoder.classes_[pred_idx]
    actual   = encoder.classes_[y_test[idx]]
    ok = pred_cls == actual
    if ok: correct += 1
    print(f'{idx:>4} | {actual:<25} | {pred_cls:<25} | {probs[pred_idx]*100:5.1f}% | {"OK" if ok else "MISS"}')
print('-' * 75)
print(f'Result: {correct}/10')