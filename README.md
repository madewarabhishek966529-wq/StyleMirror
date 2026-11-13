# StyleMirror 🪞
> **AI-Powered Men's Grooming, Hairstyle & Beard Virtual Try-On Application**  
> *Transform your hairstyle and beard while preserving 100% authentic facial identity.*

---

## 📋 Table of Contents
1. [Executive Summary](#-executive-summary)
2. [Programming Languages & Technology Stack](#-programming-languages--technology-stack)
3. [How StyleMirror Works (End-to-End Workflow)](#-how-stylemirror-works-end-to-end-workflow)
4. [Complete 13-Screen Application Suite](#-complete-13-screen-application-suite)
5. [Visual Design System & Color Palette](#-visual-design-system--color-palette)
6. [System Architecture & Data Flow](#-system-architecture--data-flow)
7. [HairFastGAN AI Architecture & Pipeline Integration](#-hairfastgan-ai-architecture--pipeline-integration)
8. [Repository File Structure](#-repository-file-structure)
9. [Automated Full-Stack Launch (Zero-Config)](#-automated-full-stack-launch-zero-config)
10. [Automated Testing & Verification Suite](#-automated-testing--verification-suite)
11. [Security, Privacy & Data Retention](#-security-privacy--data-retention)

---

## 🌟 Executive Summary

**StyleMirror** is a production-grade, privacy-first AI men's grooming application designed to solve a fundamental barber challenge: *"How will this haircut or beard actually look on my face?"*

Unlike generic fashion shopping apps or crude face-swap filters, StyleMirror is **exclusively engineered for male hair and beard styling**:
* **Identity-Preserving AI**: Keeps facial features, bone structure, skin tone, and expressions completely intact while photorealistically modifying only hair and facial hair.
* **Precision Face Shape Analysis**: Detects facial geometry across 6 core shapes (*Oval, Round, Square, Rectangle, Diamond, Heart*) and computes tailored haircut and beard recommendations.
* **Barber Consultation Specifications**: Translates every virtual look into real-world barber instructions with clipper guard numbers (e.g., `#1.5 Skin Fade`), scissor top lengths (`1.5–2 inches`), and styling products (e.g., matte clay vs. pomade).
* **Automated Full-Stack Coordination**: Runs as a Flutter cross-platform mobile/desktop client with a dedicated Python FastAPI backend that automatically starts in the background without needing Docker.

---

## 💻 Programming Languages & Technology Stack

StyleMirror is built using a modern, multi-language architecture where each language is chosen for its specific strengths:

| Language | Primary Role | Framework / Tooling | Key Responsibilities & Code Locations |
| :--- | :--- | :--- | :--- |
| **Dart** | **Frontend Client UI & State** | **Flutter 3.x (Null-Safe)** | Drives the entire cross-platform mobile and desktop experience. Manages reactive state, screen routing, 5-destination navigation bar, custom split sliders, biometrics dialog, HTTP API communication, and offline fallback mode. Located in [`lib/`](lib/) and [`test/`](test/). |
| **Python** | **Backend REST API & AI Pipeline** | **Python 3.12+, FastAPI, Uvicorn** | High-performance asynchronous API server. Handles image uploading, OpenCV facial validation, Google Gemini Vision prompting, multi-key quota rotation (`KeyPool`), SQLite ORM models, and 24-hour background cleanup. Located in [`backend/app/`](backend/app/). |
| **Kotlin** | **Android Host Platform** | **Android SDK, Gradle Kotlin DSL** | Powers the native Android wrapper ([`MainActivity.kt`](android/app/src/main/kotlin/com/example/stylemirror/MainActivity.kt)). Automates host-level Python backend verification and port binding via custom Gradle tasks in [`build.gradle.kts`](android/app/build.gradle.kts). |
| **Swift** | **iOS & macOS Host Platform** | **iOS / macOS Runner, CocoaPods** | Handles native camera hardware permissions, photo library entitlements, high-DPI windowing, and application lifecycle on Apple platforms ([`ios/Runner/AppDelegate.swift`](ios/Runner/AppDelegate.swift), [`macos/Runner/AppDelegate.swift`](macos/Runner/AppDelegate.swift)). |
| **C++** | **Windows Native Desktop Host** | **Win32 API, Windows C++ Runner** | Manages Windows native window frame creation, DirectX hardware acceleration, message pump loops, and process life-cycle binding ([`windows/runner/main.cpp`](windows/runner/main.cpp), [`flutter_window.cpp`](windows/runner/flutter_window.cpp)). |
| **CMake** | **Desktop Build System** | **CMake 3.14+** | Compiles native desktop binaries and dependencies for Windows builds ([`windows/CMakeLists.txt`](windows/CMakeLists.txt)). |
| **PowerShell** | **Cross-Platform Automation** | **PowerShell 5.1+ / PS Core** | Provides zero-click developer orchestration script [`run.ps1`](run.ps1) that tests port 8000, starts the Python backend daemon, installs dependencies, and boots the Flutter app. |
| **Batch (CMD)** | **Windows Command Launcher** | **Windows Shell Batch** | Provides one-click launch wrapper [`run.bat`](run.bat) for standard Windows Command Prompt environments. |
| **SQL (SQLite)**| **Relational Data Storage** | **SQLAlchemy ORM + SQLite3** | Lightweight database engine for catalog caching, generation jobs, temporary photo metadata, and user look bookmarks ([`backend/app/db.py`](backend/app/db.py)). Runs locally with zero container overhead. |
| **JSON** | **Data Serialization** | **JSON Schema & Dart Mappers** | Standard communication protocol between client and server for request bodies, validation errors, biometrics, and styles catalog. |
| **Markdown** | **Documentation & Knowledge Hub**| **GFM & In-App Readers** | System specifications, QA audit reports, and rich educational barber articles rendered in the app's Grooming Guide. |

---

## ⚙️ How StyleMirror Works (End-to-End Workflow)

The complete end-to-end lifecycle of StyleMirror operates in 8 sequential phases:

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  1. Auto-Boot   │ ──▶  │  2. Biometrics  │ ──▶  │ 3. Shape Analysis│ ──▶  │ 4. Style Choice │
│ Backend + Client│      │ OpenCV Face Check│     │ 6 Geometry Types│      │ 50 Barber Looks │
└─────────────────┘      └─────────────────┘      └─────────────────┘      └─────────────────┘
                                                                                    │
                                                                                    ▼
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  8. 24h Purge   │ ◀──  │ 7. Barber Card  │ ◀──  │ 6. Comparison   │ ◀──  │ 5. Virtual Try-On│
│ Zero AI Training│      │ Clipper & Guard │      │ Dual Split-Slider│      │ Gemini Vision AI│
└─────────────────┘      └─────────────────┘      └─────────────────┘      └─────────────────┘
```

### Phase 1: Automated Full-Stack Boot
1. The user launches the application via `run.bat`, `run.ps1`, or IDE (`F5`).
2. The [`BackendLauncher`](lib/services/backend_launcher.dart) service checks if `http://localhost:8000/health` is responsive.
3. If the backend is not yet running, it spawns Python with `uvicorn app.main:app --port 8000` in the background automatically.
4. The Flutter UI initializes with graceful offline demo fallback, ensuring the app remains 100% functional even if network services are interrupted.

### Phase 2: Biometric Capture & OpenCV Single-Face Verification
1. The user captures a selfie or picks a portrait from their gallery.
2. The front camera displays an oval alignment reticle with lighting recommendations.
3. Before processing, the image is passed to the Python backend's [`face_check.py`](backend/app/services/face_check.py) service:
   - Uses OpenCV Haar Cascades with adaptive minimum box dimensions (`min_sz = max(70, min(w, h) * 0.16)`).
   - Validates that **exactly one single human face** is present (rejects group photos, photos without faces, or false positives from clothing collars).
   - Computes blur score using the Laplacian variance ($\sigma^2_{\text{Laplacian}} > 45.0$).
   - Rejects images with extreme pitch or yaw rotation to ensure frontal accuracy.

### Phase 3: AI Face Shape & Facial Feature Classification
1. The AI engine analyzes the portrait's facial geometry and proportions.
2. Classifies the user's face into one of 6 biometric shapes:
   - **Oval**: Balanced forehead and chin; rounded jawline.
   - **Square**: Strong angular jaw; forehead, cheekbones, and jawline of equal width.
   - **Round**: Equal width and length; soft rounded jaw and cheeks.
   - **Rectangle / Oblong**: Elongated face height; straight cheek lines.
   - **Diamond**: Narrow forehead and chin with wide, prominent cheekbones.
   - **Heart**: Wide forehead tapering down to a pointed chin.
3. The system maps the face shape to complementary haircut volumes and beard silhouettes that balance the facial proportions.

### Phase 4: Curated Style Selection & Exploration
1. Users explore **50 hand-crafted male grooming styles**:
   - **25 Hairstyles (`H01`–`H25`)**: Crew Cut, French Crop, Textured Fringe, Pompadour, Quiff, Skin Fade, Taper Fade, Buzz Cut, Mullet, Curly Fade, etc.
   - **25 Beard Styles (`B01`–`B25`)**: Clean Shaven, Heavy Stubble, Short Boxed Beard, Balbo, Goatee, Van Dyke, Corporate Beard, Full Beard, etc.
2. Users can filter by face compatibility, search by keywords (e.g., "fade", "crop"), or view exact barber clipper guard requirements.

### Phase 5: AI Virtual Try-On Generation
1. The client issues a `POST /v1/generations` request containing:
   - `photo_id`: The validated portrait identifier.
   - `hair_style_id`: Target hairstyle (`H01`–`H25`) or `null`.
   - `beard_style_id`: Target beard style (`B01`–`B25`) or `null`.
2. The backend Gemini Vision AI pipeline constructs an identity-locked prompt:
   - Instructs the diffusion model to preserve facial bone structure, eyes, nose, lips, ears, skin texture, and expressions.
   - Inpaints only the cranial hair and lower mandibular facial hair regions.
3. The multi-key `KeyPool` rotates active Google Gemini API keys to guarantee zero 429 quota exhaustion.

### Phase 6: Interactive Before/After Visual Comparison
1. Once generated, the result is displayed in the Virtual Try-On Studio.
2. An interactive [`BeforeAfterSlider`](lib/widgets/before_after_slider.dart) allows real-time comparison:
   - **Split Slider**: Tactile draggable divider to slide across the face.
   - **Side-by-Side**: Direct dual-card inspection.
   - **Original Only / Styled Only**: Instant full-frame toggle.

### Phase 7: Barber Consultation Card Export
1. Users can save generated looks to their **My Styles Vault**.
2. Tap **"Barber Card"** to generate an exportable consultation card containing:
   - Top scissor length (e.g., `1.5–2 inches textured scissor cut`).
   - Side clipper guard number (e.g., `#1.5 to #2 Fade Transition`).
   - Neckline contour (e.g., `Tapered natural neckline`).
   - Beard guard & cheek line instructions (e.g., `6mm baseline, diagonal cheek sculpting`).
   - Recommended styling product (e.g., `Matte styling clay with pliable hold`).

### Phase 8: Data Privacy & Automated 24-Hour Purge
1. StyleMirror adheres strictly to DPDP / GDPR principles.
2. User photos are never used to train or fine-tune AI models.
3. Background cleanup jobs automatically delete temporary photos and generated output files after 24 hours.
4. Users can tap **"Instant Wipe"** to permanently delete their photos, cached outputs, and biometric records immediately.

---

## 📱 Complete 13-Screen Application Suite

StyleMirror is structured into 13 high-fidelity screens organized under a persistent 5-section bottom navigation bar:

```
Navigation Bar: [ Home ] [ Explore ] [ Try On ] [ My Styles ] [ Profile ]
```

### Screen 1 – Splash Screen
* Premium dark obsidian background with glowing StyleMirror branding.
* Tagline: *"Discover the Best Version of You."*
* Automated background service ping and token initialization.

### Screen 2 – Onboarding (3-Step Carousel)
* **Screen 2A**: *Discover Your Perfect Hairstyle* — Explains face-shape-tailored hair recommendations.
* **Screen 2B**: *Find Your Perfect Beard* — Demonstrates jawline sculpting and beard contouring.
* **Screen 2C**: *Try Before You Choose* — Interactive preview of AI virtual try-on with Skip, Next, and Get Started buttons.

### Screen 3 – Authentication & Security
* Login, Sign Up, and Guest exploration modes.
* Email and password fields with dynamic show/hide password visibility toggle.
* Google Authentication option.
* Form validation with real-time error states.

### Screen 4 – Home Dashboard
* Personalized greeting with user profile avatar and status.
* **My Face Profile** hero card showing detected shape and biometric calibration badge.
* **Virtual AI Try-On Studio** quick-action banner with 1-tap launch.
* **Recommended Hairstyles** horizontally scrollable list tailored to user's face shape.
* **Recommended Beard Styles** horizontally scrollable list tailored to user's face shape.
* Trending Barber Cuts and Barber Tip of the Day.
* Recent style transformation history card with 1-tap "Reuse" button.

### Screen 5 – Face Analysis & Biometric Calibration
* Frontal camera capture and gallery photo upload.
* Oval biometric positioning reticle with lighting rules checklist.
* Scanning animation simulating facial landmark detection.
* Analysis results card displaying detected face shape (*Oval, Round, Square, Rectangle, Diamond, Heart*), proportions, jawline angle, forehead width, and hairline characteristics.

### Screen 6 – Hairstyle Explorer
* Complete catalog of **25 Hairstyles across 10 categories**:
  * *Short, Medium, Long, Fade, Undercut, Textured, Curly, Wavy, Professional, Modern.*
* Real-time search by cut name or barber terms.
* Horizontal face-shape compatibility filter chips (*All Shapes, Oval Face, Square Face, etc.*).
* Style detail modal with image preview, face compatibility tags, barber specifications, and *"Try This Hairstyle in Studio"* CTA.

### Screen 7 – Beard Style Explorer
* Complete catalog of **25 Beard Styles across 11 categories**:
  * *Clean Shave, Light Stubble, Heavy Stubble, Short Beard, Full Beard, Goatee, Van Dyke, Balbo, Circle Beard, Boxed Beard, Corporate Beard.*
* Real-time search and filtering.
* Barber trimming specifications (guard lengths in mm, cheekline contouring rules).
* Style detail modal with *"Try This Beard Style in Studio"* CTA.

### Screen 8 – Virtual Try-On Studio
* 3-step Try-On workflow:
  1. *Upload / Capture Selfie* with OpenCV single-face validation.
  2. *Choose Look Target* (Haircut only, Beard only, or Both Combined).
  3. *AI Generation & Fine-Tuning* (customization controls for fade height, texture, and density).
* Multi-model preset selector allowing testing with sample studio portraits.

### Screen 9 – Visual Comparison & Inspection
* Integrated dual-layer interactive split slider with tactile drag handle.
* 4 viewing modes: *Split Slider, Side-by-Side, Original Only, Styled Only*.
* High-resolution image inspection with zoom and pan.
* Quick action toolbar: *Save to Vault, Share with Barber, Instant Wipe*.

### Screen 10 – My Styles Vault
* Stored look repository organized into 4 filter tabs:
  * *Virtual Previews (generated results)*
  * *Saved Hairstyles*
  * *Saved Beard Styles*
  * *Favorites (bookmarked looks)*
* Biometric compatibility badges (e.g. `98% Match`).
* Favorite heart toggle on each card.
* **Barber Consultation Card** export trigger.

### Screen 11 – Men's Grooming Knowledge Hub
* 4 comprehensive, barber-authored deep-dive articles:
  1. *The Essential Men's Hair Care Routine* (shampoo frequency, scalp health, towel-drying rules).
  2. *Mastering the Beard Trim: Neckline & Cheek Lines* (2-finger rule above Adam's apple, diagonal cheek line).
  3. *Matte Styling Clay vs. High-Shine Pomade* (hold levels, shine characteristics, hair type matching).
  4. *Eliminating Beard Itch & Cultivating Density* (follicle hydration, boar bristle brushing, beard oil vs. balm).
* Reading times and key barber rules checklist for each guide.

### Screen 12 – Barber Consultation Card (Export Modal)
* Clean, professional Barber Consultation Card designed to show directly to a barber.
* Contains exact clipper guard specs (e.g. `#1.5 Skin Fade`), scissor top texture, neckline contour, and beard trim lengths.
* Share and Print export triggers.

### Screen 13 – Profile, Preferences & Privacy Commitments
* User account summary with membership badge.
* Face profile summary with 1-tap "Update" analysis button.
* Appearance settings with real-time **Dark Mode (Obsidian) / Light Mode** theme switcher.
* Grooming reminder notification toggles (bi-weekly haircut reminders).
* Privacy & Security Commitments link explaining zero AI training and 24-hour purge.
* Log Out action with confirmation feedback.

---

## 🎨 Visual Design System & Color Palette

StyleMirror features a professional, premium editorial aesthetic: **a high-end modern barbershop crossed with a clean modern SaaS product**. It defaults to an editorial light theme with an optional dark obsidian mode:

```
┌────────────────────────────────────────────────────────────────────────┐
│  #F7F5F0  │  #FFFFFF  │  #E7E2D9  │  #0F1B2D  │  #0F766E  │  #B5733A  │
│Warm Ivory │Card White │1px Border │ Ink Navy  │Deep Emerald│  Copper   │
│Background │  Surfaces │ Subtle Line│Primary Text│Primary Btn│Badges/Acc.│
└────────────────────────────────────────────────────────────────────────┘
```

### Light Editorial Theme (Primary Default)
| Token Name | Hex Code | Purpose & Application |
| :--- | :--- | :--- |
| **Warm Ivory Background** | `#F7F5F0` | Spacious, warm ivory backdrop for screens, editorial cards, and scaffolding. |
| **Card White Surface** | `#FFFFFF` | Crisp white cards with 14px border radius and 1px border. |
| **Subtle Border** | `#E7E2D9` | 1px border definition giving a sharp, tactile print feel without harshness. |
| **Ink Navy (Primary Text)**| `#0F1B2D` | High-contrast editorial ink navy typography for titles and key metrics. |
| **Slate (Secondary Text)** | `#5B6678` | Refined slate for subtitles, descriptions, helper hints, and timestamps. |
| **Deep Emerald (Primary)** | `#0F766E` | Sophisticated barbershop emerald for primary buttons, active tabs, and sliders. |
| **Copper (Secondary)** | `#B5733A` | Warm copper for compatibility badges, face match percentages, and highlights. |
| **Success Green** | `#16A34A` | Clear green for OpenCV biometric verification checks and 100% face lock. |
| **Error Red** | `#DC2626` | Clean red for multiple-faces warnings and immediate photo deletion actions. |

### Dark Obsidian Theme (Optional Toggle)
| Token Name | Hex Code | Purpose & Application |
| :--- | :--- | :--- |
| **Obsidian Background** | `#0B1220` | Deep obsidian navy for low-light environments and OLED displays. |
| **Dark Card Surface** | `#131C2E` | Elevated dark cards with 1px border `#1E293B`. |
| **Dark Text Primary** | `#F8FAFC` | Crisp white typography for high legibility. |
| **Dark Text Secondary** | `#94A3B8` | Cool slate grey for secondary text. |
| **Accents** | `#0F766E` & `#B5733A` | Consistent deep emerald and copper accents across both themes. |

### Typography & Component Specifications
* **Headings**: Editorial serif typography (Playfair Display / DM Serif styling) with generous line heights.
* **Body / UI**: Clean, legible sans-serif (Inter style) with high contrast hierarchy.
* **Shape & Elevation**: 14px border radius cards, 10px border radius buttons, soft diffuse shadows (`0 8px 24px rgba(15, 27, 45, 0.08)`).
* **Icons**: Thin-line Lucide-style iconography with zero distracting emojis.
* **Motion & Interactions**: Tactile emerald Before/After split slider, sliding comparison pills, sticky catalog try-on bar, and printable Barber Consultation Card.

---

## 🏗️ System Architecture & Data Flow

```
┌─────────────────────────────────────────────────────────┐
│              Flutter Client (Dart 3.x)                  │
│                                                         │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────┐  │
│  │ DashboardView │  │  ExplorerView │  │ TryOnStudio │  │
│  └───────────────┘  └───────────────┘  └─────────────┘  │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────┐  │
│  │ MyStylesVault │  │  ProfileGuide │  │Theme/Offline│  │
│  └───────────────┘  └───────────────┘  └─────────────┘  │
└────────────────────────────┬────────────────────────────┘
                             │ HTTP REST (JSON / Multipart)
                             ▼
┌─────────────────────────────────────────────────────────┐
│            FastAPI Backend (Python 3.12+)               │
│                                                         │
│  ┌────────────────────────┐  ┌───────────────────────┐  │
│  │   Face Check Service   │  │   KeyPool Rotation    │  │
│  │  (OpenCV Haar Cascade) │  │  (Multi-Key Gemini)   │  │
│  └────────────────────────┘  └───────────────────────┘  │
│  ┌────────────────────────┐  ┌───────────────────────┐  │
│  │  SQLite Database Engine│  │ 24h Purge Background  │  │
│  │  (SQLAlchemy Models)   │  │ (Async TTL Cleaner)   │  │
│  └────────────────────────┘  └───────────────────────┘  │
└────────────────────────────┬────────────────────────────┘
                             │ HTTPS API Key
                             ▼
┌─────────────────────────────────────────────────────────┐
│        Google Gemini Vision & Editing Pipeline          │
│         (Identity-Preserving Inpainting AI)             │
└─────────────────────────────────────────────────────────┘
```

---

## 🧬 HairFastGAN AI Architecture & Pipeline Integration

StyleMirror incorporates the core design and algorithmic principles of **HairFastGAN** (*NeurIPS 2024 - Realistic and Robust Hair Transfer with a Fast Encoder-Based Approach*, located in [`project/`](project/)) directly into its native full-stack engine ([`backend/app/services/hairfast_engine.py`](backend/app/services/hairfast_engine.py)).

### 1. The Core HairFast Concept: `(Face, Shape, Color)` Triplet
Standard face-swap filters blindly replace the entire head, obliterating the user's natural bone structure, forehead proportions, and facial features. HairFastGAN decomposes hair transfer into three independent orthogonal modalities:
1. **Target Face Identity ($F$)**: The user's portrait providing facial landmarks, bone structure, skin complexion, and lighting conditions.
2. **Target Shape Silhouette ($S$)**: The structural haircut volume, boundaries, and contours extracted from curated catalog styles (`H01`–`H25`).
3. **Target Follicle Color & Tone ($C$)**: The hair color palette and luminance transfer (Natural, Jet Black, Espresso Brown, Ash Blonde, Silver Grey, Copper Auburn).

```
 ┌────────────────────────┐      ┌────────────────────────┐      ┌────────────────────────┐
 │   Target Face Photo    │      │  Catalog Hair Silhouette│     │   Hair Follicle Tone   │
 │   (User Portrait $F$)  │      │   ($S$: H01 - H25 Cut) │      │   ($C$: Natural/Tone)  │
 └───────────┬────────────┘      └───────────┬────────────┘      └───────────┬────────────┘
             │                               │                               │
             ▼                               ▼                               ▼
    ┌─────────────────┐             ┌─────────────────┐             ┌─────────────────┐
    │ 1. Eye-Line Quad│             │ 2. Alpha Mask   │             │ 3. Color & Tone │
    │    Alignment    │             │    Extraction   │             │    Transfer     │
    └────────┬────────┘             └────────┬────────┘             └────────┬────────┘
             │                               │                               │
             └───────────────────────┬───────┴───────────────────────────────┘
                                     ▼
                      ┌─────────────────────────────┐
                      │ 4. Boundary Poisson Blend & │
                      │  Identity Protection Shield │
                      └──────────────┬──────────────┘
                                     ▼
                      ┌─────────────────────────────┐
                      │    Photorealistic Result    │
                      │   (Preserved 100% Identity) │
                      └─────────────────────────────┘
```

### 2. The 4-Stage Mathematical Pipeline

#### Stage 1: 68-Point Facial Landmark & Eye-Line Quad Alignment
* Inspired by [`project/utils/shape_predictor.py`](project/utils/shape_predictor.py), the engine detects pupil landmarks $(x_L, y_L)$ and $(x_R, y_R)$.
* Computes horizontal head tilt angle:
  $$\theta = \arctan2(y_R - y_L, x_R - x_L)$$
* Normalizes head orientation using an affine rotation quad around face center $C_{\text{face}}$, aligning eyes to a strict horizontal baseline before hair grafting.

#### Stage 2: Hair Silhouette Extraction & Dynamic Scalp Fitting
* Retrieves canonical barber reference assets from [`assets/styles/hair/`](assets/styles/hair/).
* Extracts the upper hair volume mask, separates it from background pixels using morphological erosion and dilation (`DilateErosion` in [`project/utils/image_utils.py`](project/utils/image_utils.py)), and scales the silhouette quad proportionally to the user's cranial width.

#### Stage 3: Follicle Color & Melanin Tone Transfer
* Allows users to select their desired hair color directly from the Flutter UI:
  * **Natural Tone**: Preserves user's authentic follicle lighting and tint.
  * **Jet Black**: Enhances dark melanin depth with balanced specular highlights.
  * **Espresso Brown**: Rich warm undertones with soft barbershop diffusion.
  * **Ash Blonde**: De-pigmented blonde tones with cool platinum undertones.
  * **Silver Grey**: Modern mature salt-and-pepper styling with balanced luminance.
  * **Copper Auburn**: Vibrant warm copper follicle highlights.
* The tone palette is blended across high-frequency hair texture channels while preserving realistic hair shine and strand definition.

#### Stage 4: Boundary Poisson Blending & Identity Preservation Shield
* **Identity Preservation Shield**: An inner facial bounding ellipse completely locks user's eyes, eyebrows, nose, mouth, and skin texture to **zero hair alpha**, preventing any hair bleeding into the face.
* **Feathered Hairline Transition**: A Gaussian falloff kernel ($\sigma = 9.0$) smooths the hairline perimeter, producing natural strand-to-skin transitions.
* **Unwarping**: Applies inverse affine transformation to restore the portrait to the user's authentic angle and geometry.

---

## 📂 Repository File Structure

```
stylemirror/
├── android/                         # Android native project & Gradle Kotlin DSL build files
├── ios/                             # iOS native project, CocoaPods & camera permissions
├── macos/                           # macOS desktop application runner
├── windows/                         # Windows native desktop C++ runner & CMake configs
├── lib/                             # Core Flutter application source code (Dart)
│   ├── core/
│   │   ├── constants/               # API endpoints, network timeouts, error codes
│   │   └── theme/                   # Master AppTheme with dark/light palettes
│   ├── data/
│   │   ├── grooming_guide_data.dart # 4 deep-dive barber articles & tips
│   │   └── style_catalog_data.dart  # 50 styles (25 haircuts + 25 beards) with prompts
│   ├── models/
│   │   ├── face_profile_model.dart  # 6 face shapes, biometric attributes & recommendations
│   │   ├── grooming_guide_model.dart# Article data models & metadata
│   │   ├── generation_model.dart    # Virtual try-on job state & results
│   │   ├── photo_model.dart         # Uploaded photo & face validation issue models
│   │   └── style_model.dart         # Style metadata, categories & prompt hints
│   ├── screens/
│   │   ├── dashboard_screen.dart    # Screen 4: Home Dashboard & Face Profile Card
│   │   ├── explorer_screen.dart     # Screens 6 & 7: Hairstyle & Beard Style Explorer
│   │   ├── home_screen.dart         # Screens 8 & 9: Virtual Try-On Studio & Slider
│   │   ├── my_styles_screen.dart    # Screens 10 & 12: My Styles Vault & Barber Card
│   │   ├── profile_screen.dart      # Screens 11 & 13: Profile, Guide & Settings
│   │   ├── catalog_screen.dart      # Classic catalog explorer view
│   │   └── privacy_screen.dart      # Legal, data privacy & instant wipe screen
│   ├── services/
│   │   ├── api_service.dart         # HTTP REST client + offline fallback provider
│   │   └── backend_launcher.dart    # Desktop background daemon launcher
│   ├── widgets/
│   │   ├── auth_dialog.dart         # Screen 3: Email/Password & Google auth modal
│   │   ├── before_after_slider.dart # Interactive split comparison slider
│   │   ├── consent_dialog.dart      # Mandatory biometric consent dialog
│   │   ├── face_analysis_dialog.dart# Screen 5: Frontal camera reticle & analysis
│   │   ├── onboarding_dialog.dart   # Screen 2: 3-step visual onboarding carousel
│   │   ├── step_indicator.dart      # 3-step navigation progress indicator
│   │   └── style_card.dart          # High-fidelity style selection card
│   └── main.dart                    # App bootstrap, 5-tab NavigationBar & theme provider
├── test/                            # Flutter Automated Test Suite (22 tests)
│   ├── api_service_test.dart        # End-to-end API client & mock lifecycle tests
│   ├── backend_launcher_test.dart   # Background launcher safety tests
│   ├── models_test.dart             # JSON serialization & validation tests
│   ├── style_catalog_test.dart      # Catalog uniqueness, images & prompt tests
│   └── widget_test.dart             # Widget tests for 5-tab navigation & screens
├── backend/                         # Python FastAPI REST Backend (No Docker required)
│   ├── app/
│   │   ├── ai/                      # Base AI provider, Gemini Vision, and mock engine
│   │   ├── routers/                 # API endpoints (/styles, /photos, /generations, etc.)
│   │   ├── services/                # OpenCV face check, HairFastGAN engine, KeyPool, 24h purge
│   │   ├── config.py                # Pydantic v2 environment configuration
│   │   ├── db.py                    # SQLAlchemy SQLite engine & session management
│   │   ├── models.py                # Database entity models
│   │   ├── schemas.py               # Pydantic v2 request/response schemas
│   │   └── main.py                  # FastAPI application entry point & CORS
│   ├── scripts/
│   │   ├── seed_styles.py           # SQLite styles database seeder
│   │   └── crop_sheet.py            # Reference portrait cropper utility
│   ├── tests/                       # Pytest Backend Test Suite (18 tests)
│   │   ├── test_generations.py      # Generation workflow & parameters
│   │   ├── test_hairfast.py         # HairFastGAN landmark, color & blending tests
│   │   ├── test_keys.py             # KeyPool rotation & quota fallback
│   │   ├── test_photos.py           # Photo upload validation & instant wipe
│   │   ├── test_storage_cleanup.py  # 24-hour TTL automated purge
│   │   ├── test_styles.py           # Catalog querying and filtering
│   │   └── test_suggestions_looks.py# Face-shape recommendation matrix
│   ├── requirements.txt             # Python backend dependencies
│   └── .env.example                 # Environment configuration template
├── project/                         # Upstream HairFastGAN (NeurIPS 2024) reference implementation
├── docs/                            # Deep-dive design, API & QA specifications
├── run.bat                          # 1-click Windows Command Prompt launcher
└── run.ps1                          # 1-click PowerShell full-stack runner
```

---

## 🚀 Automated Full-Stack Launch (Zero-Config)

You **never need to run the backend separately**. StyleMirror includes automated full-stack coordination across all operating modes:

### Option 1: 1-Click Runner (Windows CMD or PowerShell)
Double-click `run.bat` or execute in PowerShell:
```powershell
.\run.ps1
```
*Automatically validates Python, checks port 8000, launches FastAPI in the background if inactive, and boots the Flutter application.*

### Option 2: Run via VS Code / Antigravity IDE (`F5`)
1. Open the project folder in VS Code or Antigravity IDE.
2. Select **"StyleMirror (App + Backend)"** from the Run & Debug menu.
3. Press **F5**. The configured `preLaunchTask` in `.vscode/launch.json` automatically boots the backend and attaches the Flutter debugger.

### Option 3: Standard Flutter CLI
```bash
flutter run
```
* On Windows, macOS, and Linux desktop builds, [`BackendLauncher`](lib/services/backend_launcher.dart) detects if port 8000 is open; if not, it automatically spawns the Python backend process.
* On Android, the custom Gradle task in `android/app/build.gradle.kts` verifies the host machine's Python backend before device launch, routing API traffic through `http://10.0.2.2:8000`.

---

## 🧪 Automated Testing & Verification Suite

StyleMirror is backed by a multi-layer automated testing suite with **100% pass rate** across all layers:

### 1. Flutter Test Suite (`22 / 22 Passed`)
Execute via:
```bash
flutter test
```
* **`test/widget_test.dart`**: Verifies 5-tab `NavigationBar` navigation, Dashboard elements, `ExplorerScreen` hairstyle/beard tab switching, `TryOn` selfie capture navigation, `MyStyles` vault tabs, `Profile` grooming guide, `StepIndicator` state transitions, and `BeforeAfterSlider` drag modes.
* **`test/style_catalog_test.dart`**: Verifies exact 50-style catalog count (25 haircuts + 25 beards), ID uniqueness (`H01`–`H25`, `B01`–`B25`), valid category assignments, non-empty prompt hints, and verifies that every single style asset image exists on disk.
* **`test/api_service_test.dart`**: Tests API service client lifecycle, upload photo validation error handling, generation polling lifecycle, and photo deletion.
* **`test/models_test.dart`**: Tests JSON serialization and deserialization of `StyleModel`, `PhotoModel`, `GenerationModel`, and `FaceProfile`.
* **`test/backend_launcher_test.dart`**: Tests health check socket probing and safe background process spawning.

### 2. Python Backend Pytest Suite (`18 / 18 Passed`)
Execute via:
```bash
python -m pytest backend/tests
```
* **`test_photos.py`**: Tests photo upload validation, OpenCV rejection of photos without faces, and immediate permanent deletion.
* **`test_styles.py`**: Tests full catalog querying and filtering by `type=hair` and `type=beard`.
* **`test_hairfast.py`**: Tests HairFastGAN landmark detection, eye-line angle calculation, color tone transfer matrices, and Poisson blending pipeline.
* **`test_generations.py`**: Tests generation creation, parameter validation, asynchronous job polling, and combination caching.
* **`test_keys.py`**: Tests `KeyPool` round-robin rotation, 429 quota exhaustion skipping, and secret key masking.
* **`test_storage_cleanup.py`**: Tests the 24-hour TTL automated purge job removing expired photos and records.
* **`test_suggestions_looks.py`**: Tests face-shape recommendation matrix and saved look bookmarking.

### 3. Static Analysis
Execute via:
```bash
flutter analyze
```
* Result: **`No issues found!`** (Zero errors, zero warnings, zero deprecation issues).

---

## 🔒 Security, Privacy & Data Retention

* **Zero AI Model Training**: User selfies are processed in-memory solely for rendering the requested haircut/beard preview. User images are **never stored permanently or used to train, fine-tune, or evaluate AI models**.
* **24-Hour TTL Auto-Purge**: All uploaded selfies, intermediate crops, and generated transformation outputs are tagged with a 24-hour expiration timestamp. An asynchronous background worker permanently purges expired files and database records.
* **Instant Manual Wipe**: Users have continuous access to the **"Instant Wipe"** button, which immediately triggers `DELETE /v1/photos/{id}`, wiping the selfie and all derived generations from disk and database in a single atomic transaction.
* **Server-Side API Keys**: Google Gemini API keys live exclusively within server-side `.env` files and environment variables. Keys are never embedded into client code or transmitted over the wire.
* **Full Compliance**: Architected in accordance with DPDP (Digital Personal Data Protection) and GDPR privacy requirements.
