def test_face_shape_suggestions(client):
    res = client.post("/v1/suggestions", json={"face_shape": "round"})
    assert res.status_code == 200
    data = res.json()
    assert data["face_shape"] == "Round"
    assert len(data["recommended_hair"]) > 0
    assert len(data["recommended_beard"]) > 0
    assert "height" in data["description"].lower()

def test_save_and_list_looks(client):
    # Upload photo
    from tests.test_photos import create_test_image
    img_bytes = create_test_image(512, 600)
    upload_res = client.post("/v1/photos", files={"file": ("selfie.jpg", img_bytes, "image/jpeg")})
    photo_id = upload_res.json()["photo_id"]

    # Generate look
    gen_res = client.post("/v1/generations", json={
        "photo_id": photo_id,
        "hair_style_id": "H01",
        "beard_style_id": "B01",
    })
    gen_id = gen_res.json()["id"]

    # Save look
    save_res = client.post("/v1/looks", json={
        "generation_id": gen_id,
        "title": "My Classic Military Look",
    })
    assert save_res.status_code == 200
    look_id = save_res.json()["id"]
    assert save_res.json()["title"] == "My Classic Military Look"

    # List saved looks
    list_res = client.get("/v1/looks")
    assert list_res.status_code == 200
    looks = list_res.json()
    assert any(l["id"] == look_id for l in looks)

    # Delete saved look
    del_res = client.delete(f"/v1/looks/{look_id}")
    assert del_res.status_code == 200
    assert del_res.json()["ok"] is True

