import io
from PIL import Image

def create_test_image(width=512, height=512, color=(120, 140, 160)):
    buf = io.BytesIO()
    img = Image.new("RGB", (width, height), color=color)
    img.save(buf, format="JPEG")
    return buf.getvalue()

def test_photo_upload_success(client):
    img_bytes = create_test_image(512, 600)
    files = {"file": ("selfie.jpg", img_bytes, "image/jpeg")}
    
    response = client.post("/v1/photos", files=files)
    assert response.status_code == 200
    data = response.json()
    assert data["ok"] is True
    assert len(data["photo_id"]) > 0
    assert data["expires_in"] == 86400

def test_photo_upload_too_small(client):
    small_bytes = create_test_image(100, 100)
    files = {"file": ("tiny.jpg", small_bytes, "image/jpeg")}
    
    response = client.post("/v1/photos", files=files)
    assert response.status_code == 200
    data = response.json()
    assert data["ok"] is False
    assert "FACE_TOO_SMALL" in data["issues"]

def test_photo_immediate_delete(client):
    img_bytes = create_test_image(512, 600)
    files = {"file": ("selfie.jpg", img_bytes, "image/jpeg")}
    upload_res = client.post("/v1/photos", files=files)
    photo_id = upload_res.json()["photo_id"]

    # Delete photo immediately
    del_res = client.delete(f"/v1/photos/{photo_id}")
    assert del_res.status_code == 200
    assert del_res.json()["ok"] is True

    # Confirm 404 on subsequent delete
    del_again = client.delete(f"/v1/photos/{photo_id}")
    assert del_again.status_code == 404
