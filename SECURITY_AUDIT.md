# StyleMirror — Application Security & Privacy Audit

**Audit Date**: 2026-11-11  
**Security Lead**: Senior Application Security Engineer & QA Lead  
**Scope**: Mobile Client (Flutter), Backend Services (FastAPI), Storage, and Data Transmission  
**Classification**: **PASS / SECURE FOR PRODUCTION**  

---

## 1. Executive Summary

This Security Audit was conducted according to **OWASP Top 10 for Mobile** and **OWASP Top 10 for API Security** standards. The audit evaluated client-side secret exposure, input validation, authentication and token signing, data storage security, and compliance with privacy commitments (Zero AI Model Training, 24-Hour TTL Purge, and Instant Wipe).

No critical or high-risk vulnerabilities were identified in the production release candidate.

---

## 2. Threat Modeling & Vulnerability Analysis

| Threat Category (STRIDE) | Risk Vector | Mitigation Implemented | Status |
|---|---|---|---|
| **Spoofing Identity** | Unauthorized file access / impersonation | Signed HMAC tokens required for media routes (`/v1/files/`) | **SECURE** |
| **Tampering with Data** | Image payload modification or injection | SHA-256 hash calculated on upload; PIL re-encoding strips EXIF metadata | **SECURE** |
| **Repudiation** | Untracked deletion of sensitive selfies | Synchronous delete operations with audit logging | **SECURE** |
| **Information Disclosure** | API keys or user selfies leaked to public | Server-only `.env` isolation; no keys in mobile client bundle | **SECURE** |
| **Denial of Service (DoS)** | Memory exhaustion via oversized images | 8 MB max upload ceiling; 256x256 minimum resolution gate | **SECURE** |
| **Elevation of Privilege** | Database manipulation via SQL Injection | SQLAlchemy parameterized ORM queries; no raw SQL execution | **SECURE** |

---

## 3. Secret Scanning & Credential Exposure Audit

A comprehensive static analysis search was conducted across all files in `lib/`, `assets/`, `backend/`, and configuration manifests.

- **Client Code Review**:
  - `lib/services/api_service.dart`: Zero hardcoded Gemini/OpenAI API keys, zero authorization headers embedded in client binaries.
  - `lib/core/constants/api_constants.dart`: Only defines standard endpoint URIs.
- **Server Configuration**:
  - All AI provider keys (`GEMINI_API_KEYS`, `SECRET_KEY`) reside exclusively in `backend/.env`.
  - `.gitignore` explicitly excludes `.env`, `*.db`, `storage/`, and temporary build artifacts.

---

## 4. Insecure Direct Object Reference (IDOR) & Storage Protection

- **File Serving Security**:
  - Direct file system traversal is blocked in `backend/app/routers/files.py`. Paths are strictly constrained within `settings.storage_dir`.
  - Media downloads require a valid HMAC signature token:
    ```
    /v1/files/photos/{photo_id}/out/{gen_id}.jpg?token={hmac_sha256}
    ```
  - Expired or forged tokens return HTTP 403 Forbidden.
- **File System Permissions**:
  - Uploaded user files are isolated in separate UUID subdirectories (`storage/photos/{photo_id}/`).
  - Storage directory is excluded from web server public document roots.

---

## 5. Input Validation & Media Sanitization

- **MIME & Byte Verification**:
  - The backend validates image byte streams through PIL Image verification.
  - Non-image files, corrupted bytes, and executable payloads are rejected with `UNSUPPORTED_TYPE`.
- **EXIF Stripping & Orientation Normalization**:
  - `ImageOps.exif_transpose()` safely handles orientation tags without executing embedded metadata scripts.
  - All processed outputs are re-encoded into clean, normalized JPEG buffers, discarding any lingering EXIF geolocation or device data.

---

## 6. Privacy & Data Lifecycle Compliance

- **Zero AI Model Training**:
  - StyleMirror operates strictly in inference mode. User selfies are never used to train, fine-tune, or calibrate generative models.
- **Immediate Data Wipe**:
  - DELETE `/v1/photos/{photo_id}` immediately calls `delete_photo_storage(photo_id)`:
    - Removes original selfie (`orig.jpg`).
    - Removes all generated variant images (`out/*.jpg`).
    - Removes containing directories.
    - Cascades DB deletion to all generation records.
- **24-Hour Automated Cleanup Daemon**:
  - `cleanup.py` executes automated queries against the database for photos with `created_at < now - 24 hours`.
  - Stale files and database rows are purged automatically, honoring GDPR Right to be Forgotten and CCPA compliance.

---

## 7. Security Audit Conclusion

StyleMirror meets all enterprise security standards for a consumer-facing virtual try-on application. The application is cleared for production release.

