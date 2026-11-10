# StyleMirror 🪞

> **AI-Powered Hair & Beard Virtual Try-On Application**
> Transform your look while keeping your facial identity 100% authentic.

---

## 🌟 Overview

**StyleMirror** enables men to preview hairstyles and beard cuts before visiting the barber. By leveraging identity-preserving AI models, users can visualize themselves with any of **25 hairstyles** and **25 beard styles** individually or combined.

- **Frontend**: Flutter Cross-Platform Mobile Application (Android, iOS, macOS, Windows).
- **Backend**: Python 3.12+ with FastAPI + Uvicorn (No Docker needed).
- **AI Engine**: Gemini Vision/Editing image pipeline with automated `KeyPool` rotation and fallback.
- **Privacy & Safety**: 24-hour TTL automated purge, zero AI model training on user data, and one-tap instant deletion.

---

## 📸 Core Features

1. **Selfie Capture & Face Validation**:
   - Camera & Gallery integration with real-time pose and lighting alignment guides.
   - Server-side pre-validation checking face proportion, blur score (Laplacian variance), illumination, and frontal orientation.
2. **Style Catalog (50 Distinct Styles)**:
   - **25 Hairstyles (`H01`–`H25`)**: Crew Cut, Buzz Cut, French Crop, Ivy League, Side Part, Mid Fade, High Fade, Low Fade, Taper Fade, Skin Fade, Undercut, Quiff, Pompadour, Slick Back, Comb Over, Curtain Hair, Bro Flow, Textured Crop, Messy Hair, Spiky Hair, Man Bun, Top Knot, Long Hair, Mullet, Curly Hair.
   - **25 Beard Styles (`B01`–`B25`)**: Clean Shaven, Stubble, Short Boxed Beard, Medium Beard, Full Beard, Goatee, Extended Goatee, Van Dyke, Circle Beard, Anchor Beard, Balbo Beard, Soul Patch, Mutton Chops, Friendly Mutton Chops, Verdi Beard, Garibaldi, Dutch Beard, Bandholz, Corporate Beard, Hollywoodian, Designer Stubble, Chin Strap, Neck Beard, Imperial, Horseshoe.
3. **Interactive Before/After Comparison Slider**:
   - Dual-layer interactive split slider with tactile drag handle.
   - Mode switching: Split Slider, Side-by-Side Comparison, Original Only, Styled Only.
4. **"Suggest for Me" by Face Shape**:
   - Recommends optimal hairstyles and beard geometries based on facial shape (Oval, Round, Square, Heart, Diamond, Oblong).
5. **Saved Looks ("My Looks")**:
   - Bookmark favorite generated looks with unique sharing IDs for barber consultation.
6. **24-Hour TTL Auto-Purge & Immediate Wipe**:
   - User photos and generated assets are automatically purged after 24 hours.
   - One-tap "Delete My Photo Now" permanently purges files and database records immediately.

---

## 📁 Project Structure

```
stylemirror/
├── android/                   # Android native platform configuration & permissions
├── ios/                       # iOS native configuration & camera entitlements
├── macos/                     # macOS desktop configuration & network entitlements
├── windows/                   # Windows desktop configuration
├── lib/                       # Flutter Application
│   ├── core/
│   │   ├── constants/         # API endpoints & timeout settings
│   │   └── theme/             # Dark luxury barber theme
│   ├── data/                  # Built-in 50 style catalog data
│   ├── models/                # Style, Photo, and Generation data models
│   ├── screens/
│   │   ├── home_screen.dart   # 3-step Try-On flow (Selfie -> Choose -> Result)
│   │   ├── catalog_screen.dart# 50 styles explorer with barber prompt details
│   │   └── privacy_screen.dart# Data privacy & security commitments
│   ├── services/
│   │   └── api_service.dart   # HTTP client + offline demo fallback
│   ├── widgets/
│   │   ├── before_after_slider.dart # Interactive comparison slider
│   │   ├── consent_dialog.dart      # Mandatory legal & processing consent
│   │   ├── step_indicator.dart      # 3-step navigation indicator
│   │   └── style_card.dart          # Luminous style selector card
│   └── main.dart              # App entry point & navigation scaffold
├── test/                      # Flutter Unit & Widget Test Suite (15 tests)
├── backend/                   # FastAPI Backend (No Docker)
│   ├── app/
│   │   ├── ai/                # Base provider, Gemini, and Mock implementations
│   │   ├── routers/           # /v1/styles, /photos, /generations, /files, /suggestions, /looks
│   │   ├── services/          # KeyPool, Face check, Storage, and 24h Cleanup
│   │   ├── config.py          # Environment settings
│   │   ├── db.py              # SQLite engine & session
│   │   ├── models.py          # SQLAlchemy models
│   │   └── main.py            # FastAPI entry point
│   ├── scripts/
│   │   ├── seed_styles.py     # SQLite catalog seeder script
│   │   └── crop_sheet.py      # Reference collage cropper script
│   ├── tests/                 # Backend Pytest Suite (15 tests)
│   ├── requirements.txt       # Python dependencies
│   └── .env.example           # Environment template
└── docs/                      # Complete specifications & architectural design
```

---

## 🛠️ Quickstart Guide (Zero-Configuration All-In-One Execution)

You **do not need to start the backend separately**! StyleMirror includes automated full-stack coordination across all run modes:

### Option 1: 1-Click All-in-One Runner (Recommended)

Simply run `run.bat` or `run.ps1`:
```bash
# Windows Command Prompt
run.bat

# Or PowerShell
.\run.ps1
```
*Automatically checks port 8000, starts the FastAPI backend in the background if needed, and launches the Flutter application.*

### Option 2: Run via VS Code / IDE (Press `F5`)
Open the project in VS Code / Antigravity IDE, select **"StyleMirror (App + Backend)"**, and press **F5**.
The configured `preLaunchTask` in `.vscode/launch.json` automatically boots the backend and attaches the Flutter debugger.

### Option 3: Standard `flutter run`
```bash
# Launch on Windows Desktop, Android, iOS, or macOS:
flutter run
```
- **On Desktop (Windows/macOS/Linux)**: [`BackendLauncher`](lib/services/backend_launcher.dart) in `main.dart` detects if port 8000 is open; if not, it automatically spawns the Python backend in the background.
- **On Android**: The host Gradle build task in `android/app/build.gradle.kts` automatically verifies and spawns the Python backend on the host machine before launching the emulator/device, accessible via `http://10.0.2.2:8000`.

---

### Manual Backend Launch (Optional)

If you ever wish to inspect FastAPI interactive documentation (`/docs`) or run backend tests directly:

```bash
cd backend
python -m pip install -r requirements.txt
python scripts/seed_styles.py
python -m uvicorn app.main:app --reload --port 8000
```
- Interactive API Docs: `http://localhost:8000/docs`
- Healthcheck: `http://localhost:8000/health`

---

## 🧪 Automated Testing

### Flutter Test Suite (`15 passed`):
```bash
flutter test --no-pub
```
- `test/style_catalog_test.dart`: Validates all 25 hairstyles + 25 beards, uniqueness of IDs, categories, and prompt hints.
- `test/models_test.dart`: Serialization/deserialization for Style, Photo, and Generation models, plus issue message formatting.
- `test/api_service_test.dart`: End-to-end service mock/network flow, error simulation, generation lifecycle, and deletion.
- `test/widget_test.dart`: UI widget test for `StyleMirrorApp`, `StepIndicator`, and interactive `BeforeAfterSlider`.

### Backend Pytest Suite (`15 passed`):
```bash
python -m pytest backend/tests
```
- `test_styles.py`: Full catalog and filtered queries (`type=hair`, `type=beard`).
- `test_photos.py`: Upload validation, error rejection (too small, invalid format), and immediate permanent deletion.
- `test_generations.py`: Generation creation, combination caching, polling status, and parameter validation.
- `test_keys.py`: `KeyPool` rotation, 429 quota skipping, and invalid key masking.
- `test_storage_cleanup.py`: 24-hour TTL automated purge.
- `test_suggestions_looks.py`: Face-shape recommendation matrix and saved look bookmarking.

---

## 🔒 Security & Privacy Commitments
- **Zero AI Training**: Raw selfies are processed in-memory solely for rendering the preview and are never used to train or fine-tune models.
- **24-Hour TTL**: Automated purge removes all expired records and assets.
- **Server-Side Secrets**: Gemini API keys live exclusively in server-side environment variables and are never transmitted to clients.
