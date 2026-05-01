# Dataset Documentation — Tomato & Potato Health Monitoring

## Tổng quan

| Thông tin | Giá trị |
|---|---|
| Cây giám sát | Cà chua (*Lycopersicon esculentum*), Khoai tây (*Solanum tuberosum*) |
| Cảm biến | 7-in-1 Soil Sensor (RS485 Modbus RTU) |
| Thời gian mô phỏng | 2023–2024 (2 năm liên tục) |
| Tần suất đọc | Mỗi 1 giờ |
| Window size | 24 timestep (24 giờ) |
| Tổng sequences | ~10,300 |
| Tổng dòng | ~247,200 |

---

## Thông số cảm biến (Features)

| Feature | Đơn vị | Mô tả |
|---|---|---|
| `Soil_Moisture` | % | Độ ẩm đất |
| `Soil_Temperature` | °C | Nhiệt độ đất |
| `EC` | µS/cm | Electrical Conductivity — proxy cho tổng dinh dưỡng hòa tan |
| `pH` | — | Độ pH đất |
| `Nitrogen` | mg/kg | Hàm lượng Đạm trong đất |
| `Phosphorus` | mg/kg | Hàm lượng Lân trong đất |
| `Potassium` | mg/kg | Hàm lượng Kali trong đất |

---

## Nhãn phân loại (Labels) & Căn cứ nông học

### Healthy — Khỏe mạnh

Tất cả thông số nằm trong khoảng tối ưu theo khuyến cáo FAO cho họ Cà (Solanaceae).

| | Cà chua | Khoai tây |
|---|---|---|
| Moisture (%) | 65–75 | 70–80 |
| Temp (°C) | 20–28 | 15–22 |
| EC (µS/cm) | 1800–2500 | 1500–2200 |
| pH | 6.0–6.8 | 5.5–6.5 |
| N (mg/kg) | 140–200 | 120–180 |
| P (mg/kg) | 50–80 | 40–70 |
| K (mg/kg) | 180–250 | 200–280 |

> **Nguồn**: FAO Irrigation & Drainage Paper 56; FAO Agronomy Series — Potato Production

---

### N_Deficient — Thiếu Đạm (Nitrogen)

**Triệu chứng thực vật**: Lá vàng từ lá già lên lá non, cây còi cọc, thân nhỏ.

**Dấu hiệu sensor**:
- Nitrogen < 50 mg/kg
- EC < 1300 µS/cm (EC thấp tương quan với tổng dinh dưỡng thấp)

> **Nguồn**: Marschner, H. (1995). *Mineral Nutrition of Higher Plants*, 2nd Ed.; USDA-ARS Crop Nutrient Tool

---

### P_Deficient — Thiếu Lân (Phosphorus)

**Triệu chứng thực vật**: Lá màu tím/đỏ tía (anthocyanin tích lũy), rễ kém phát triển.

**Dấu hiệu sensor**:
- Phosphorus < 20 mg/kg
- pH < 5.5 → P bị cố định bởi Fe và Al (iron/aluminum phosphate)

> **Cơ chế**: Ở pH < 5.5, P phản ứng với Fe³⁺ và Al³⁺ tạo thành muối không tan, cây không hấp thụ được dù P có trong đất.

> **Nguồn**: Brady & Weil (2008). *The Nature and Properties of Soils*, 14th Ed.

---

### K_Deficient — Thiếu Kali (Potassium)

**Triệu chứng thực vật**: Mép lá cháy vàng (marginal scorch), quả nhỏ, sức đề kháng bệnh kém.

**Dấu hiệu sensor**:
- Potassium < 90 mg/kg

> **Nguồn**: Agrios, G.N. (2005). *Plant Pathology*, 5th Ed., Academic Press.

---

### Fe_Deficient — Thiếu Sắt (Iron)

**Triệu chứng thực vật**: Lá non vàng nhưng gân lá vẫn xanh (interveinal chlorosis).

**Dấu hiệu sensor**:
- pH > 7.2 → Fe(OH)₃ kết tủa, Fe³⁺ không tan, cây không hấp thụ được
- Iron deficiency do đất kiềm hóa (very common in calcareous/limestone soils)

> **Nguồn**: Lindsay, W.L. (1979). *Chemical Equilibria in Soils*, Wiley-Interscience.

---

### Late_Blight_Risk — Nguy cơ Mốc sương

**Tác nhân**: *Phytophthora infestans* (Oomycete)

**Điều kiện phát sinh**:
- Độ ẩm đất > 85% (kết hợp ẩm không khí cao)
- Nhiệt độ 10–22°C (đặc biệt nguy hiểm khi đêm lạnh + ngày ẩm)
- Nguy cơ cao nhất trong mùa mưa

> **Ghi chú**: Đây là bệnh nguy hiểm nhất với khoai tây — có thể gây thối toàn bộ củ trong 7–10 ngày.

> **Nguồn**: CABI. *Phytophthora infestans* Datasheet; Fry, W.E. (2008). *Phytophthora infestans*: the plant (and R gene) destroyer. Mol. Plant Pathol.

---

### Early_Blight_Risk — Nguy cơ Đốm lá sớm

**Tác nhân**: *Alternaria solani*

**Điều kiện phát sinh**:
- Hạn hán: Moisture < 45%
- Nhiệt độ cao: 25–34°C
- Nitrogen thấp (< 80 mg/kg) — cây suy yếu, sức đề kháng giảm

> **Nguồn**: Agrios (2005); USDA Plant Disease Handbook.

---

### Bacterial_Spot_Risk — Nguy cơ Đốm vi khuẩn

**Tác nhân**: *Xanthomonas vesicatoria* (cà chua), *X. campestris* (khoai tây)

**Điều kiện phát sinh**:
- Moisture 78–92%
- Nhiệt độ ấm 25–33°C
- pH 6.5–7.5 (pH trung tính đến kiềm nhẹ)

> **Nguồn**: Jones, J.B. et al. (1991). *Compendium of Tomato Diseases*, APS Press.

---

### Leaf_Mold_Risk — Nguy cơ Mốc lá

**Tác nhân**: *Passalora fulva* (syn. *Fulvia fulva*, *Cladosporium fulvum*)

**Điều kiện phát sinh**:
- Moisture đất > 80% (tương quan ẩm không khí > 85%)
- Nhiệt độ mát 18–26°C
- Thông gió kém

> **Nguồn**: CABI. *Passalora fulva* Datasheet.

---

## Phân phối Dataset

| Label | Tomato | Potato | Tổng seq | Tỷ lệ |
|---|---|---|---|---|
| Healthy | 250 | 250 | 500 | ~4.9% |
| N_Deficient | 600 | 600 | 1,200 | ~11.6% |
| P_Deficient | 600 | 600 | 1,200 | ~11.6% |
| K_Deficient | 600 | 600 | 1,200 | ~11.6% |
| Fe_Deficient | 600 | 600 | 1,200 | ~11.6% |
| Late_Blight_Risk | 700 | 700 | 1,400 | ~13.6% |
| Early_Blight_Risk | 700 | 700 | 1,400 | ~13.6% |
| Bacterial_Spot_Risk | 550 | 550 | 1,100 | ~10.7% |
| Leaf_Mold_Risk | 550 | 550 | 1,100 | ~10.7% |
| **Tổng** | **5,150** | **5,150** | **10,300** | **100%** |

> **Lý do phân phối lệch về bệnh**: Mô hình LSTM đóng vai trò hệ thống cảnh báo sớm (early warning system). Trường hợp `Healthy` đã được mô hình YOLO xử lý từ ảnh camera, do đó LSTM tập trung nhận diện các điều kiện đất bất thường.

---

## Seasonal Variation (Biến động mùa)

Dataset bao gồm biến động theo mùa cho phù hợp với khí hậu nhiệt đới Việt Nam:

| Mùa | Tháng | Soil_Moisture | Soil_Temperature |
|---|---|---|---|
| Mùa mưa | 5–10 | +8% | −3°C |
| Mùa khô | 11–4 | −7% | +3°C |

---

## Cách sử dụng dataset để train LSTM

```python
import pandas as pd
import numpy as np

df = pd.read_csv("data/tomato_potato_health.csv")

feature_cols = ["Soil_Moisture", "Soil_Temperature", "EC",
                "pH", "Nitrogen", "Phosphorus", "Potassium"]

# Tạo sequences
X, y = [], []
for seq_id in df["sequence_id"].unique():
    seq = df[df["sequence_id"] == seq_id]
    X.append(seq[feature_cols].values)         # shape: (24, 7)
    y.append(seq["label"].iloc[0])             # 1 nhãn / sequence

X = np.array(X)   # (10300, 24, 7)
y = np.array(y)   # (10300,)
```
