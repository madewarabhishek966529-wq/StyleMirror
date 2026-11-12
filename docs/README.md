# StyleMirror — AI Hairstyle & Beard Virtual Try-On Application

StyleMirror is an AI-powered men's grooming and appearance application built using **Flutter (Dart)** for the cross-platform frontend and **FastAPI (Python)** for the backend AI vision pipeline.

Transform your look while keeping your facial identity 100% authentic.

---

## 📚 Documentation Index

| # | File | Purpose |
|---|---|---|
| 1 | [`01_PRODUCT.md`](01_PRODUCT.md) | Vision, scope, user flow, product requirements & phases |
| 2 | [`02_ARCHITECTURE.md`](02_ARCHITECTURE.md) | Multi-language stack, system design, data flow, auto-launcher |
| 3 | [`03_STYLE_CATALOG.md`](03_STYLE_CATALOG.md) | 25 hairstyles (`H01`–`H25`) + 25 beards (`B01`–`B25`), prompt hints |
| 4 | [`04_AI_PIPELINE.md`](04_AI_PIPELINE.md) | Gemini Vision inpainting, prompt design, identity preservation |
| 5 | [`05_API_SPEC.md`](05_API_SPEC.md) | FastAPI REST endpoints, request/response schemas, error codes |
| 6 | [`06_DATABASE.md`](06_DATABASE.md) | SQLite schema, SQLAlchemy ORM models, 24h TTL cleanup |
| 7 | [`07_FRONTEND.md`](07_FRONTEND.md) | Flutter application architecture, 13 screens, 5-tab navigation, widgets |
| 8 | [`08_SECURITY_PRIVACY.md`](08_SECURITY_PRIVACY.md) | DPDP/GDPR compliance, consent flow, zero AI training, instant wipe |
| 9 | [`09_TESTING_QA.md`](09_TESTING_QA.md) | Automated testing strategy (22 Flutter tests + 15 Pytest tests) |
| 10 | [`10_ROADMAP.md`](10_ROADMAP.md) | Development roadmap, feature milestones & definition of done |
| 11 | [`11_GIT_WORKFLOW.md`](11_GIT_WORKFLOW.md) | Git branching, commit conventions, `.gitignore` & safety checks |
| 12 | [`AGENTS.md`](AGENTS.md) | Engineering instructions for AI coding agents & architects |

---

## ⚡ Quick Technology Summary

* **Frontend**: **Dart 3.x with Flutter 3.x**
  * Android, iOS, Windows, macOS, Linux, and Web support.
  * 5-section navigation (`Home`, `Explore`, `Try On`, `My Styles`, `Profile`).
  * 13 complete application screens.
  * Interactive Before/After split slider, biometric camera guide, and barber consultation card export.
* **Backend**: **Python 3.12+ with FastAPI & Uvicorn**
  * Asynchronous REST architecture.
  * OpenCV single-face validation via Haar cascades with adaptive bounding box filtering.
  * Multi-key rotation (`KeyPool`) for Google Gemini Vision AI.
  * SQLite database with SQLAlchemy ORM (zero container or Docker overhead).
* **AI Engine**: Identity-preserving inpainting pipeline via **Google Gemini Vision** editing models.
* **Storage & Privacy**:
  * Local 24-hour TTL temporary storage.
  * Automated background purge and atomic one-tap instant deletion.
  * Zero AI model training on user photos.
* **Execution**: Automated 1-click startup via `run.bat` or `.\run.ps1` that checks port 8000, starts the backend daemon, and runs the Flutter client.

---

## 🎯 The Golden Rule

> **Never paste the user's face onto a stock photo or swap faces.**  
> Always preserve the user's authentic facial identity (eyes, nose, mouth, skin tone, jawline, and expressions) and inpaint only the hairstyle and facial hair contours.
