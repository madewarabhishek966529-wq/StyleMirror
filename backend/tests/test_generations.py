import io
from PIL import Image

def create_test_image(width=512, height=600):
    buf = io.BytesIO()
    img = Image.new("RGB", (width, height), color=(130, 150, 170))
    img.save(buf, format="JPEG")
    return buf.getvalue()

def test_generation_flow_and_cache(client):
    # 1. Upload photo
    img_bytes = create_test_image()
    upload_res = client.post("/v1/photos", files={"file": ("selfie.jpg", img_bytes, "image/jpeg")})
    photo_id = upload_res.json()["photo_id"]

    # 2. Trigger generation
    gen_payload = {
        "photo_id": photo_id,
        "hair_style_id": "H03",
        "beard_style_id": "B02",
        "view": "front",
    }
    gen_res = client.post("/v1/generations", json=gen_payload)
    assert gen_res.status_code == 200
    gen_data = gen_res.json()
    assert gen_data["photo_id"] == photo_id
    assert gen_data["hair_style_id"] == "H03"
    assert gen_data["beard_style_id"] == "B02"
    job_id = gen_data["id"]

    # 3. Check status
    status_res = client.get(f"/v1/generations/{job_id}")
    assert status_res.status_code == 200
    assert status_res.json()["id"] == job_id

def test_generation_requires_at_least_one_style(client):
    img_bytes = create_test_image()
    upload_res = client.post("/v1/photos", files={"file": ("selfie.jpg", img_bytes, "image/jpeg")})
    photo_id = upload_res.json()["photo_id"]

    # Empty styles payload
    bad_payload = {"photo_id": photo_id}
    res = client.post("/v1/generations", json=bad_payload)
    assert res.status_code == 400
    assert res.json()["detail"]["error"]["code"] == "STYLE_REQUIRED"

def test_generation_photo_not_found(client):
    payload = {
        "photo_id": "non_existent_uuid",
        "hair_style_id": "H01",
    }
    res = client.post("/v1/generations", json=payload)
    assert res.status_code == 404
    assert res.json()["detail"]["error"]["code"] == "PHOTO_NOT_FOUND"

