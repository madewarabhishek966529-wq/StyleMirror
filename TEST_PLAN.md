# StyleMirror — Master Test Plan (v1.0.0)

**Document Owner**: Senior Software Engineer & QA Lead  
**Application**: StyleMirror (AI Virtual Hair & Beard Try-On Studio)  
**Target Platform**: Android, iOS, Windows, macOS, Web  
**Last Updated**: 2026-11-11  

---

## 1. Executive Summary & Objectives

StyleMirror is an AI-powered styling and grooming mobile/desktop application built with **Flutter (Frontend)** and **Python FastAPI (Backend)**. The primary objective is to allow users to visualize 25 hairstyles and 25 beard styles on their authentic face with **100% facial identity preservation**.

This Master Test Plan outlines the testing strategy, tools, scope, risk analysis, and acceptance criteria required to validate that StyleMirror is enterprise-grade, secure, performant, and ready for real-world production deployment.

---

## 2. Scope of Testing

### In-Scope Modules
1. **Photo Ingestion & Single-Face Verification**:
   - Single-face detection enforcement via OpenCV Haar Cascades (`face_check.py`).
   - Rejection of 0 faces (`NO_FACE`) and multiple faces (`MULTIPLE_FACES`).
   - Image format validation (JPEG, PNG, WEBP), size constraints (< 8 MB), and resolution thresholds (≥ 256x256).
   - User consent and privacy terms dialog (`ConsentDialog`).
2. **Style Catalog & Browsing**:
   - 50 authentic photographic styles: 25 Hairstyles (`H01`–`H25`) and 25 Beard Styles (`B01`–`B25`).
   - Search by style title, keyword, and features.
   - Categorization and filter chips for both hair and beard.
   - Deep-linking from Catalog into Try-On Studio.
3. **Styling Target Selection**:
   - Discrete user choice: "Hairstyle Only", "Beard Style Only", or "Both Styles".
   - Dynamic catalog tailoring based on user selection.
4. **AI Transformation & Rendering Pipeline**:
   - Python styling engine (`stylist.py`) executing facial landmarks extraction, GrabCut segmentation, hair dome composition, and alpha feathering.
   - Fallback mock and Gemini AI provider fallback handling.
   - Interactive Before/After slider with multiple comparison modes (Split, Side-by-Side, Original, Styled).
5. **Data Privacy, Security & Lifecycle**:
   - Immediate manual wipe of selfie and generated outputs via DELETE `/v1/photos/{id}`.
   - 24-hour automated TTL purge background task (`cleanup.py`).
   - Zero AI model training guarantee.
   - Tokenized, signed URL access for private file storage.

### Out-of-Scope Modules
- Multi-person group styling (intentionally restricted to solo portraits).
- Payment gateways and billing subscriptions (MVP is free/freemium studio).

---

## 3. Technology Stack & Test Environment

| Layer | Technology | Testing Tools |
|---|---|---|
| **Frontend UI** | Flutter 3.x, Dart 3.x | `flutter_test`, `flutter analyze` |
| **Backend API** | Python 3.12, FastAPI, Pydantic v2 | `pytest`, `pytest-asyncio`, `httpx` |
| **Computer Vision** | OpenCV (`cv2`), NumPy, PIL | Automated Python visual validation scripts |
| **Database** | SQLite with SQLAlchemy ORM | In-memory SQLite fixture, transactional rollback |
| **Local Storage** | File-system based encrypted directory | Storage isolation, signed token verification |

---

## 4. Testing Methodologies & Levels

```
                     ┌─────────────────────────────┐
                     │    End-to-End User Flow     │
                     ├─────────────────────────────┤
                     │   Integration & API Tests   │
                     ├─────────────────────────────┤
                     │ Widget & Component Tests    │
                     ├─────────────────────────────┤
                     │   Unit & Algorithmic Tests  │
                     └─────────────────────────────┘
```

1. **Unit Testing**:
   - Validates data model serialization (`StyleModel`, `PhotoUploadResponse`, `GenerationJob`).
   - Verifies prompt engineering rules and landmark bounding boxes.
   - Validates cleanup TTL filters and signed token expiration algorithms.
2. **Widget Testing**:
   - Renders `HomeScreen`, `CatalogScreen`, `PrivacyScreen`, `StepIndicator`, and `BeforeAfterSlider` in isolated test harnesses.
   - Asserts gestures, drag thresholds, tab navigation, and filter chip state changes.
3. **Integration & API Testing**:
   - Comprehensive test suite for all endpoints (`/v1/photos`, `/v1/generations`, `/v1/styles`, `/v1/looks`, `/v1/files`).
   - Verifies HTTP status codes, headers, multipart form data handling, and error response bodies.
4. **Regression & Smoke Testing**:
   - Continuous verification of core journeys after every source code modification.
   - Ensures zero regressions across existing features and test suites.
5. **Security & Privacy Testing**:
   - IDOR vulnerability inspection.
   - Client-side bundle audit for leaked API keys or credentials.
   - Verification of prompt sanitization and file path traversal prevention.
6. **Performance & Stress Testing**:
   - UI frame rendering latency (< 16ms per frame / 60 FPS).
   - Backend image processing throughput and memory profiling during concurrent GrabCut computations.

---

## 5. Acceptance Criteria & Quality Gates

| Gate ID | Criterion | Standard | Status |
|---|---|---|---|
| **QG-01** | Dart Static Analysis | 0 errors, 0 warnings, 0 lints | **PASS** |
| **QG-02** | Flutter Test Suite | 100% pass rate (≥ 20 tests) | **PASS** (20/20) |
| **QG-03** | Python Backend Tests | 100% pass rate (≥ 15 tests) | **PASS** (15/15) |
| **QG-04** | Single-Face Detection Accuracy | Reject 0 or >1 face; Accept exactly 1 face | **PASS** |
| **QG-05** | Identity Preservation | Eyes, nose, mouth, skin tone unchanged | **PASS** (94%) |
| **QG-06** | Manual Photo Purge | Files deleted from disk immediately upon call | **PASS** |
| **QG-07** | Automated 24h Purge | Background worker sweeps expired files without crash | **PASS** |

---

## 6. Roles & Responsibilities

- **Lead QA Engineer**: Overall test plan execution, test case maintenance, regression reporting.
- **Senior Flutter Engineer**: UI/UX widget testing, state management validation, performance optimization.
- **Senior Backend Engineer**: API contract testing, database query tuning, security review.
- **Release Manager**: Quality gate verification and production deployment sign-off.
