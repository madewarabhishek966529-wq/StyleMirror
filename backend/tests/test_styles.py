def test_get_all_styles(client):
    response = client.get("/v1/styles")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 50

def test_get_hair_styles_only(client):
    response = client.get("/v1/styles?type=hair")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 25
    assert all(item["type"] == "hair" for item in data)
    assert any(item["id"] == "H01" for item in data)
    assert any(item["name"] == "French Crop" for item in data)

def test_get_beard_styles_only(client):
    response = client.get("/v1/styles?type=beard")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 25
    assert all(item["type"] == "beard" for item in data)
    assert any(item["id"] == "B01" for item in data)
    assert any(item["name"] == "Full Beard" for item in data)

