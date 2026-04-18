import pytest
import base64
import json
import numpy as np
import cv2
from src.image_processor import ImageProcessor

@pytest.fixture
def image_processor():
    return ImageProcessor()

def create_fake_base64_image(width=100, height=100):
    # Tạo một ảnh dummy bằng OpenCV
    img = np.zeros((height, width, 3), dtype=np.uint8)
    cv2.putText(img, "Test", (10, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)
    _, buf = cv2.imencode('.jpg', img)
    return base64.b64encode(buf).decode('utf-8')

def test_compress_if_needed_no_compression_needed(image_processor):
    fake_img = create_fake_base64_image(100, 100)
    result_in = {"evidence_image": f"data:image/jpeg;base64,{fake_img}"}
    
    # max_bytes = 1MB, ảnh nhỏ sẽ không bị nén
    result_out = image_processor.compress_if_needed(result_in, max_bytes=1000000)
    
    assert result_out is result_in # Nếu không nén, trả về nguyên bản dict
    assert result_out["evidence_image"] == result_in["evidence_image"]

def test_compress_if_needed_triggers_compression(image_processor):
    # Cố ý set max_bytes rất nhỏ để ép nén
    fake_img = create_fake_base64_image(800, 600) # Lớn hơn MAX_WIDTH = 640
    result_in = {"evidence_image": f"data:image/jpeg;base64,{fake_img}", "extra_data": "some string"}
    
    result_out = image_processor.compress_if_needed(result_in, max_bytes=10)
    
    assert result_out is not result_in # Dict được copy
    assert result_out["evidence_image"] != result_in["evidence_image"]
    assert "data:image/jpeg;base64," in result_out["evidence_image"]
    assert result_out["extra_data"] == "some string" # Mất không thuộc tính khác
    
def test_compress_if_needed_invalid_image(image_processor):
    result_in = {"evidence_image": "not_an_image"}
    result_out = image_processor.compress_if_needed(result_in, max_bytes=10)
    assert result_out is result_in # Trả về bản gốc nếu lỗi xử lý ảnh
