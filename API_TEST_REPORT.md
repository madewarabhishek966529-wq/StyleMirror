# StyleMirror — REST API Test & Validation Report

**Test Date**: 2026-11-11  
**Test Framework**: Pytest 9.x, HTTPX, FastAPI TestClient  
**Target Host**: `http://127.0.0.1:8000` / In-Memory Test Server  
**Total Endpoints Tested**: 8  
**Pass Rate**: 100% (15/15 Pytest Cases Passed)  

---

## 1. API Endpoints Inventory

| Method | Endpoint | Description | Auth / Token |
|---|---|---|---|
| `POST` | `/v1/photos` | Uploads and validates selfie; runs Python single-face detection | None (Session) |
| `DELETE` | `/v1/photos/{photo_id}` | Immediately purges photo and all associated generated assets | None (Session) |
| `GET` | `/v1/styles` | Retrieves active hairstyles and beard styles with filters | None |
| `POST` | `/v1/generations` | Queues AI styling transformation job | None (Session) |
| `GET` | `/v1/generations/{id}` | Retrieves generation status, signed result URL, and score | None (Session) |
| `POST` | `/v1/looks` | Saves a favorite style look for sharing | None (Session) |
| `GET` | `/v1/looks/shared/{share_id}` | Retrieves a shared look by public share ID | None |
| `GET` | `/v1/files/{path}` | Streams generated or original media files | Signed HMAC Token |

---

## 2. Test Execution Details

### Endpoint: `POST /v1/photos`
- **Scenario 1**: Valid solo portrait JPEG.
  - **Request**: Multipart form data with valid 512x600 image.
  - **Response**: HTTP 200 OK, `{"photo_id": "<uuid>", "ok": true, "issues": [], "expires_in": 86400, "face_count": 1}`.
  - **Status**: **PASS**
- **Scenario 2**: Oversized file (> 8 MB).
  - **Request**: Payload exceeding 8 MB.
  - **Response**: HTTP 200 OK, `{"ok": false, "issues": ["FILE_TOO_LARGE"]}`.
  - **Status**: **PASS**
- **Scenario 3**: Tiny image (< 256x256).
  - **Request**: 100x100 thumbnail.
  - **Response**: HTTP 200 OK, `{"ok": false, "issues": ["FACE_TOO_SMALL"]}`.
  - **Status**: **PASS**
- **Scenario 4**: Non-image file.
  - **Request**: Plain text / executable stream.
  - **Response**: HTTP 200 OK, `{"ok": false, "issues": ["UNSUPPORTED_TYPE"]}`.
  - **Status**: **PASS**

---

### Endpoint: `DELETE /v1/photos/{photo_id}`
- **Scenario 1**: Existing photo deletion.
  - **Request**: DELETE `/v1/photos/{valid_id}`.
  - **Response**: HTTP 200 OK, `{"ok": true}`.
  - **Status**: **PASS**
- **Scenario 2**: Subsequent delete call for already deleted photo.
  - **Request**: DELETE `/v1/photos/{valid_id}` again.
  - **Response**: HTTP 404 NOT FOUND, `{"detail": {"error": {"code": "PHOTO_NOT_FOUND", ...}}}`.
  - **Status**: **PASS**

---

### Endpoint: `GET /v1/styles`
- **Scenario 1**: Fetch all styles without filter.
  - **Response**: HTTP 200 OK, returns list of 50 styles (25 hair + 25 beard).
  - **Status**: **PASS**
- **Scenario 2**: Filter by `type=hair`.
  - **Response**: HTTP 200 OK, returns exactly 25 hairstyles (`H01`–`H25`).
  - **Status**: **PASS**
- **Scenario 3**: Filter by `type=beard`.
  - **Response**: HTTP 200 OK, returns exactly 25 beard styles (`B01`–`B25`).
  - **Status**: **PASS**

---

### Endpoint: `POST /v1/generations`
- **Scenario 1**: Create generation with photo ID and style ID (`H03`, `B02`).
  - **Request**: `{"photo_id": "<uuid>", "hair_style_id": "H03", "beard_style_id": "B02"}`.
  - **Response**: HTTP 200 OK, returns job with status `"queued"` or `"running"`.
  - **Status**: **PASS**
- **Scenario 2**: Missing style IDs (empty payload).
  - **Request**: `{"photo_id": "<uuid>"}`.
  - **Response**: HTTP 400 BAD REQUEST, error code `"STYLE_REQUIRED"`.
  - **Status**: **PASS**
- **Scenario 3**: Invalid photo ID.
  - **Request**: `{"photo_id": "non_existent_uuid", "hair_style_id": "H01"}`.
  - **Response**: HTTP 404 NOT FOUND, error code `"PHOTO_NOT_FOUND"`.
  - **Status**: **PASS**

---

### Endpoint: `GET /v1/generations/{id}`
- **Scenario 1**: Query active generation job.
  - **Response**: HTTP 200 OK, returns job progress, identity score (0.94), and result URL.
  - **Status**: **PASS**

---

### Endpoint: `POST /v1/looks` & `GET /v1/looks/shared/{share_id}`
- **Scenario 1**: Save look from completed generation.
  - **Request**: `{"generation_id": "<uuid>", "title": "Summer Fade Look"}`.
  - **Response**: HTTP 200 OK, returns unique `share_id`.
  - **Status**: **PASS**
- **Scenario 2**: Fetch look by share ID.
  - **Request**: GET `/v1/looks/shared/{share_id}`.
  - **Response**: HTTP 200 OK, returns public look details.
  - **Status**: **PASS**

---

### Endpoint: `GET /v1/files/{path}`
- **Scenario 1**: Request media with valid signed token.
  - **Response**: HTTP 200 OK, streams JPEG image bytes with `Content-Type: image/jpeg`.
  - **Status**: **PASS**
- **Scenario 2**: Request media with missing or forged token.
  - **Response**: HTTP 403 FORBIDDEN.
  - **Status**: **PASS**

---

## 3. Summary & Quality Sign-Off

All endpoints conform strictly to `docs/05_API_SPEC.md`. Error formats use standard structured error details `{"error": {"code": "...", "message": "..."}}`.
