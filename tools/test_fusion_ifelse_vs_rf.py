import numpy as np
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

# 1. TẠO DỮ LIỆU MÔ PHỎNG CHO FUSION LAYER
# Inputs (Đầu vào từ các mô hình con & API):
# - lstm_risk: Xác suất nguy cơ nấm bệnh từ đất (0.0 -> 1.0)
# - cnn_disease: Xác suất lá đang có bệnh (0.0 -> 1.0)
# - weather_rain: Xác suất trời sắp mưa (0.0 -> 1.0)
# - weather_hot: Xác suất trời nắng gắt, nhiệt độ cao (0.0 -> 1.0)
# Output (Quyết định):
# 0: Không làm gì (Safe/Do Nothing)
# 1: Phun thuốc nấm (Spray Fungicide)

np.random.seed(42)
N_SAMPLES = 3000

X = []
y_true = []
scenario_type = [] # 0: Ca Dễ (Đồng nhất), 1: Ca Khó (Xung đột)

for _ in range(N_SAMPLES):
    # Sinh xác suất ngẫu nhiên từ các mô hình
    lstm_risk = np.random.uniform(0, 1)
    cnn_disease = np.random.uniform(0, 1)
    weather_rain = np.random.uniform(0, 1)
    weather_hot = np.random.uniform(0, 1)
    
    # --- ĐỊNH NGHĨA GROUND TRUTH LÝ TƯỞNG ---
    
    # Ca Dễ: Rõ ràng cần phun thuốc
    if cnn_disease > 0.7 and lstm_risk > 0.7:
        action = 1
        stype = 0
    # Ca Dễ: Rõ ràng cực kỳ an toàn
    elif cnn_disease < 0.3 and lstm_risk < 0.3 and weather_rain < 0.3:
        action = 0
        stype = 0
        
    # Ca Xung Đột 1: Đất ẩm báo nguy cơ bệnh (lstm_risk cao), nhưng thời tiết sắp nắng gắt
    # Logic thực tế: Nắng gắt sẽ tự làm khô đất và tiêu diệt nấm mốc -> KHÔNG CẦN PHUN
    elif lstm_risk > 0.75 and cnn_disease < 0.3 and weather_hot > 0.75 and weather_rain < 0.3:
        action = 0 
        stype = 1
        
    # Ca Xung Đột 2: Cây chưa có bệnh, nhưng đất bắt đầu rủi ro và SẮP MƯA TO
    # Logic thực tế: Phải phun phòng ngừa ngay vì mưa sẽ làm bùng phát nấm
    elif lstm_risk > 0.6 and cnn_disease < 0.4 and weather_rain > 0.8:
        action = 1 
        stype = 1
        
    else:
        # Các ca mập mờ khác: dùng logic tổ hợp tuyến tính
        score = lstm_risk * 0.35 + cnn_disease * 0.45 + weather_rain * 0.3 - weather_hot * 0.25
        action = 1 if score > 0.65 else 0
        stype = 0 if abs(score - 0.65) > 0.2 else 1
        
    X.append([lstm_risk, cnn_disease, weather_rain, weather_hot])
    y_true.append(action)
    scenario_type.append(stype)

X = np.array(X)
y_true = np.array(y_true)
scenario_type = np.array(scenario_type)

# 2. LOGIC IF-ELSE (Hardcoded Rule-based)
# Đặc điểm của IF-ELSE là lập trình viên thường viết các rule chết, rất khó cover hết các trường hợp xung đột thời tiết.
def if_else_fusion(x):
    lstm, cnn, rain, hot = x
    if cnn > 0.5:
        return 1
    elif lstm > 0.7:  
        # Sai lầm kinh điển: Chỉ nhìn thấy đất bệnh là phun, 
        # bỏ qua việc thời tiết hot > 0.8 có thể tự diệt nấm.
        return 1 
    elif rain > 0.8 and lstm > 0.8:
        return 1
    else:
        return 0

# 3. MÔ HÌNH RANDOM FOREST
X_train, X_test, y_train, y_test, stype_train, stype_test = train_test_split(
    X, y_true, scenario_type, test_size=0.3, random_state=123
)

rf = RandomForestClassifier(n_estimators=100, max_depth=6, random_state=42)
rf.fit(X_train, y_train)

# 4. ĐÁNH GIÁ (Trên tập test)
y_pred_ie = np.array([if_else_fusion(x) for x in X_test])
y_pred_rf = rf.predict(X_test)

acc_ie_all = np.mean(y_pred_ie == y_test) * 100
acc_rf_all = np.mean(y_pred_rf == y_test) * 100

mask_simple = (stype_test == 0)
mask_conflict = (stype_test == 1)

acc_ie_simple = np.mean(y_pred_ie[mask_simple] == y_test[mask_simple]) * 100
acc_rf_simple = np.mean(y_pred_rf[mask_simple] == y_test[mask_simple]) * 100

acc_ie_conflict = np.mean(y_pred_ie[mask_conflict] == y_test[mask_conflict]) * 100
acc_rf_conflict = np.mean(y_pred_rf[mask_conflict] == y_test[mask_conflict]) * 100

# 5. VẼ BIỂU ĐỒ SO SÁNH
labels = ['Tất cả các ca\n(Hiệu suất tổng thể)', 
          'Ca Đơn Giản\n(Tín hiệu đồng nhất)', 
          'Ca Xung Đột\n(VD: Đất bệnh nhưng\nTrời sắp nắng gắt)']

ifelse_acc = [acc_ie_all, acc_ie_simple, acc_ie_conflict]
rf_acc = [acc_rf_all, acc_rf_simple, acc_rf_conflict]

x = np.arange(len(labels))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6.5))

rects1 = ax.bar(x - width/2, ifelse_acc, width, label='Dung hợp bằng IF-ELSE', color='#e74c3c', edgecolor='white', linewidth=1.5)
rects2 = ax.bar(x + width/2, rf_acc, width, label='Dung hợp bằng Random Forest', color='#2ecc71', edgecolor='white', linewidth=1.5)

ax.set_ylabel('Độ chính xác (%)', fontsize=12, fontweight='bold', color="#333333")
ax.set_title('SO SÁNH DATA FUSION: IF-ELSE vs RANDOM FOREST\n(Giải quyết bài toán Xung Đột Tín Hiệu)', 
             fontsize=14, fontweight='bold', pad=20, color="#1a252f")

ax.set_xticks(x)
ax.set_xticklabels(labels, fontsize=11, fontweight='bold', color="#2c3e50")

# Chỉnh ylim cao lên để chú thích (legend) và số liệu không bị đè vào nhau
ax.set_ylim(0, 120)
ax.legend(fontsize=11, loc='upper center', ncol=2, frameon=False)

def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        ax.annotate(f'{height:.1f}%',
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 5),  
                    textcoords="offset points",
                    ha='center', va='bottom', fontweight='bold', fontsize=11, color="#2c3e50")

autolabel(rects1)
autolabel(rects2)

ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.grid(axis='y', linestyle='--', alpha=0.3)

plt.tight_layout()
out_path = r'C:\Users\Admin\.gemini\antigravity\brain\353ba16c-0e6c-44f7-8191-47b1ffdcb7e1\fusion_comparison.png'
plt.savefig(out_path, dpi=200, bbox_inches='tight')
print(f"Saved to {out_path}")
