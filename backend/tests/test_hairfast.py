import pytest
import numpy as np
import cv2
from app.services.hairfast_engine import HairFastEngine, COLOR_PALETTES

def test_hairfast_color_palettes():
    assert "natural" in COLOR_PALETTES
    assert "black" in COLOR_PALETTES
    assert "blonde" in COLOR_PALETTES
    assert "grey" in COLOR_PALETTES

    # Test color transfer on a synthetic patch
    dummy_patch = np.full((50, 50, 3), 100, dtype=np.uint8)
    blonde_patch = HairFastEngine.apply_color_transfer(dummy_patch, "blonde")
    assert blonde_patch.shape == dummy_patch.shape
    assert blonde_patch.dtype == np.uint8

def test_hairfast_detect_face_and_landmarks():
    # Load model_1.jpg portrait
    img = cv2.imread("assets/portraits/model_1.jpg")
    assert img is not None

    meta = HairFastEngine.detect_face_and_landmarks(img)
    assert meta is not None
    assert "box" in meta
    assert "left_eye" in meta
    assert "right_eye" in meta
    assert "angle" in meta
    assert isinstance(meta["angle"], float)

def test_hairfast_transform_end_to_end():
    with open("assets/portraits/model_1.jpg", "rb") as f:
        img_bytes = f.read()

    # Transform with H01 (hair) and B05 (beard) + espresso brown color
    output_bytes = HairFastEngine.transform(
        img_bytes,
        hair_style_id="H01",
        beard_style_id="B05",
        hair_color="dark_brown",
    )
    assert output_bytes is not None
    assert len(output_bytes) > 10000

    # Verify result is a valid decodable image
    nparr = np.frombuffer(output_bytes, np.uint8)
    res_img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    assert res_img is not None
    assert res_img.shape[0] > 0
    assert res_img.shape[1] > 0
