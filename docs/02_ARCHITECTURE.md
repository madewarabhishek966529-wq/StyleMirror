# 02 — Architecture

## Multi-Language Tech Stack (No Docker)

| Layer | Language / Technology | Why & Location |
|---|---|---|
| **Mobile & Desktop Client** | **Dart 3.x with Flutter 3.x** | Fast cross-platform native rendering (Android, iOS, Windows, macOS, Linux, Web), reactive state management, custom touch widgets. Found in `lib/`. |
| **Backend REST API** | **Python 3.12+ with FastAPI & Uvicorn** | Asynchronous HTTP server, native AI/ML libraries, OpenCV computer vision, and schema validation with Pydantic v2. Found in `backend/app/`. |
| **Native Platform Embeddings** | **Kotlin (Android), Swift (iOS/macOS), C++ (Windows)** | Native camera permissions, hardware acceleration, window chrome, and process lifecycle. Found in `android/`, `ios/`, `macos/`, and `windows/`. |
| **Automation & Launchers** | **PowerShell & Windows Batch** | 1-click startup automation scripts (`run.ps1`, `run.bat`) that coordinate Python daemon execution and Flutter client attachment. |
| **AI Generation** | **Google Gemini Vision / Inpainting AI** | Identity-preserving facial editing via multi-key rotating pool (`KeyPool`). Offline studio model fallback when disconnected. |
| **Facial Validation** | **OpenCV (`cv2`) Haar Cascade** | Adaptive bounding-box single face detection (`face_check.py`), blur variance score, and frontal alignment checks. |
| **Database & Persistence** | **SQLite + SQLAlchemy ORM** | Lightweight relational database for styles catalog, generation job tracking, and saved look bookmarks. |
| **Temporary File Storage** | **Local Disk Storage (`backend/storage/`)** | Zero container overhead; strictly regulated by 24-hour TTL automated purge. |

---

## API Keys & Security Architecture
* **Server-Side API Key Confinement**: The AI provider API keys (`GEMINI_API_KEYS`) live exclusively in `backend/.env` on the server machine. Keys are never embedded into Dart code or exposed to client apps.
* **KeyPool Rotation**: The backend implements round-robin key rotation across comma-separated keys and automatically marks/skips keys encountering 429 quota exhaustion.
* **Offline Demo Fallback**: When API keys are not supplied or network is unavailable, the Flutter app and backend seamlessly switch to local studio model presets, ensuring full offline functionality.

---

## System Architecture Diagram

```
┌────────────────────────────────────────────────────────┐
│             Flutter Client (Dart 3.x)                  │
│                                                        │
│  • DashboardView (My Face Profile & Recommendations)   │
│  • ExplorerView (25 Hairstyles + 25 Beard Styles)      │
│  • TryOnStudio (Selfie Capture & Fine-Tuning Controls) │
│  • MyStylesVault (Saved Looks & Barber Card Export)    │
│  • ProfileGuide (Face Calibration & Grooming Hub)      │
└───────────────────────────┬────────────────────────────┘
                            │
               HTTP / REST  │ (Port 8000)
                            ▼
┌────────────────────────────────────────────────────────┐
│          FastAPI Backend (Python 3.12+)                │
│                                                        │
│  • OpenCV Face Check: Exactly 1 face, blur check       │
│  • Routers: /v1/photos, /v1/generations, /v1/styles    │
│  • KeyPool: Multi-key rotation & 429 quota handling    │
│  • Storage Service: 24-hour TTL automated purge worker │
│  • SQLite DB: stylemirror.db via SQLAlchemy ORM        │
└───────────────────────────┬────────────────────────────┘
                            │
              HTTPS API Key │ (Inpainting Prompt)
                            ▼
┌────────────────────────────────────────────────────────┐
│     Google Gemini Vision / Image Editing API           │
│     (Preserves authentic facial identity)              │
└────────────────────────────────────────────────────────┘
```

---

## Request & Data Lifecycle

1. **Auto-Launch Check**: On startup, Flutter's `BackendLauncher` verifies `http://localhost:8000/health`. If inactive, it spawns `uvicorn app.main:app --port 8000` automatically.
2. **Selfie Upload & OpenCV Check**: Flutter posts multipart photo to `POST /v1/photos`. `face_check.py` validates that exactly 1 face exists with sharpness $\sigma^2 > 45.0$.
3. **Generation Dispatch**: Client issues `POST /v1/generations` specifying `photo_id`, `hair_style_id` (`H01`–`H25`), and/or `beard_style_id` (`B01`–`B25`).
4. **AI Inpainting**: Background task prompts Gemini Vision to retain eyes, nose, mouth, jawline, and skin tone while inpainting only the target hairstyle or beard silhouette.
5. **Interactive Inspection**: Result image is streamed back to Flutter, which renders the tactile Before/After split slider.
6. **Barber Consultation Export**: User saves look to My Styles and generates the Barber Card with clipper guard numbers.
7. **Automated Purge**: 24-hour TTL background cleaner permanently deletes photos and generation outputs from storage and database.

---

## Directory Organization

```
stylemirror/
├── android/                 # Android native embedding & Kotlin build tasks
├── ios/                     # iOS native embedding & camera permissions
├── macos/                   # macOS desktop runner
├── windows/                 # Windows C++ desktop runner & CMake files
├── lib/                     # Flutter Client Application (Dart)
│   ├── core/theme/          # Master obsidian & gold theme palette
│   ├── data/                # 50 styles catalog & grooming guide data
│   ├── models/              # FaceProfile, StyleModel, Generation, Photo
│   ├── screens/             # 5 core tabs + 13 complete screen interfaces
│   ├── services/            # ApiService client & BackendLauncher daemon
│   └── widgets/             # BeforeAfterSlider, Dialogs, StyleCard
├── test/                    # 22 Flutter unit, widget & catalog tests
├── backend/                 # FastAPI REST Backend (Python 3.12+)
│   ├── app/
│   │   ├── ai/              # Gemini Vision provider & KeyPool rotation
│   │   ├── routers/         # /styles, /photos, /generations, /suggestions
│   │   ├── services/        # OpenCV face_check, storage, 24h cleanup
│   │   ├── config.py        # Pydantic v2 settings
│   │   ├── db.py            # SQLite database engine
│   │   ├── models.py        # SQLAlchemy entities
│   │   └── main.py          # FastAPI application
│   ├── tests/               # 15 Pytest backend tests
│   └── requirements.txt     # Python dependencies
├── run.bat                  # 1-click Windows CMD runner
└── run.ps1                  # 1-click PowerShell runner
```
