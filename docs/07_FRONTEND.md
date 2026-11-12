# 07 — Frontend Architecture (Flutter & Dart)

StyleMirror is built as a cross-platform mobile and desktop application using **Flutter 3.x and Dart 3.x**. It delivers a high-performance native user experience across Android, iOS, Windows, macOS, Linux, and Web.

---

## 🧭 Navigation Architecture

The application is structured around a persistent 5-destination bottom navigation bar:

```
[ 🏠 Home ]  [ 🧭 Explore ]  [ ✨ Try On ]  [ 🔖 My Styles ]  [ 👤 Profile ]
```

1. **Home (`DashboardScreen`)**: Hero dashboard with personalized greeting, My Face Profile card, quick try-on action banner, recommended hairstyles and beards by face shape, trending cuts, daily barber tip, and recent history.
2. **Explore (`ExplorerScreen`)**: Dual-tab discovery hub featuring 25 Hairstyles across 10 categories and 25 Beard Styles across 11 categories, real-time search, face shape chips, and barber specs modal.
3. **Try On (`HomeScreen`)**: AI Virtual Try-On studio with OpenCV face check, styling target selector (Hair, Beard, Both), customization controls, and tactile split comparison slider.
4. **My Styles (`MyStylesScreen`)**: Saved look vault with 4 filter tabs (Virtual Previews, Hairstyles, Beard Styles, Favorites), compatibility badges, and exportable Barber Consultation Card.
5. **Profile (`ProfileScreen`)**: Face analysis profile calibration, embedded Men's Grooming Knowledge Hub (4 barber articles), dynamic Dark/Light theme toggle, grooming reminders, and privacy commitments.

---

## 📱 Complete 13 Application Screens

| Screen # | Screen Name | Implementation File | Key Features & User Interactions |
|---|---|---|---|
| **Screen 1** | **Splash Screen** | `lib/main.dart` | Obsidian background, glowing branding, initialization checks. |
| **Screen 2** | **Onboarding Carousel** | `lib/widgets/onboarding_dialog.dart` | 3-step carousel: *Discover Hairstyles*, *Find Your Beard*, *Try Before You Choose*. |
| **Screen 3** | **Authentication** | `lib/widgets/auth_dialog.dart` | Email/password login & registration, password visibility toggle, Google auth. |
| **Screen 4** | **Home Dashboard** | `lib/screens/dashboard_screen.dart` | My Face Profile card, recommended haircuts & beards, trending cuts, daily tip. |
| **Screen 5** | **Face Analysis** | `lib/widgets/face_analysis_dialog.dart`| Frontal camera reticle, lighting rules, 6 face shapes biometric detection. |
| **Screen 6** | **Hairstyle Explorer** | `lib/screens/explorer_screen.dart` (Tab 1) | 25 hairstyles, 10 categories, search, face shape filter chips, barber specs. |
| **Screen 7** | **Beard Style Explorer**| `lib/screens/explorer_screen.dart` (Tab 2) | 25 beards, 11 categories, search, trimming guidelines, try-on dispatch. |
| **Screen 8** | **Try-On Studio** | `lib/screens/home_screen.dart` | OpenCV single face verification, styling target selector, preset models. |
| **Screen 9** | **Visual Comparison** | `lib/widgets/before_after_slider.dart` | Dual-layer interactive split slider, side-by-side mode, original vs. styled. |
| **Screen 10**| **My Styles Vault** | `lib/screens/my_styles_screen.dart` | 4 categorization tabs, compatibility percentages, favorite bookmarks. |
| **Screen 11**| **Grooming Knowledge Hub**| `lib/screens/profile_screen.dart` | 4 barber-authored guides: hair routine, beard neckline, clay vs. pomade, beard itch. |
| **Screen 12**| **Barber Consultation Card**| `lib/screens/my_styles_screen.dart` | Clipper guard numbers (#1.5 fade), scissor lengths, neckline contour specs. |
| **Screen 13**| **Profile & Settings** | `lib/screens/profile_screen.dart` | Account info, dynamic Dark/Light theme switch, notifications, instant wipe. |

---

## 🎨 Visual Design System (`AppTheme`)

The visual identity is defined in [`lib/core/theme/app_theme.dart`](../lib/core/theme/app_theme.dart):

```dart
// Master Palette Tokens
static const Color background          = Color(0xFF101114); // Primary Obsidian
static const Color secondaryBackground = Color(0xFF191B20); // Secondary Dark
static const Color cardBackground      = Color(0xFF22252B); // Elevated Cards
static const Color primaryAccent       = Color(0xFFB9A0FF); // Electric Lavender
static const Color secondaryAccent     = Color(0xFFD4C5A5); // Champagne Gold
static const Color primaryText         = Color(0xFFFFFFFF); // Pure White
static const Color secondaryText       = Color(0xFFA1A1AA); // Muted Cool Grey
static const Color success             = Color(0xFF4ADE80); // Emerald Green
static const Color error               = Color(0xFFF87171); // Coral Red
```

Both **Dark Theme** (default obsidian) and **Light Theme** variations are fully supported via the theme toggle in `ProfileScreen`.

---

## 🧩 Core Widgets & UI Components

### 1. `BeforeAfterSlider` (`lib/widgets/before_after_slider.dart`)
* Interactive split-screen touch slider using `GestureDetector`.
* Renders before and after layers with a central tactile drag divider.
* Supports 4 comparison modes:
  * `Split Slider`: Draggable divider revealing after layer over before layer.
  * `Side-by-Side`: Dual adjacent card preview.
  * `Original`: Full original selfie view.
  * `Styled`: Full AI-transformed view.

### 2. `FaceAnalysisDialog` (`lib/widgets/face_analysis_dialog.dart`)
* Frontal camera capture and gallery upload guide.
* Oval biometric positioning reticle.
* Biometric scanning animation.
* Real-time calculation and presentation of face shape (Oval, Round, Square, Rectangle, Diamond, Heart), jawline contours, proportions, and hairstyle compatibility.

### 3. `StyleCard` (`lib/widgets/style_card.dart`)
* Displays style thumbnail, name, barber ID (e.g. `H03`), and compatibility chip.
* Elevated hover and selection animations with electric lavender borders.

---

## 🔄 State Management & API Integration

* **Service Layer (`StyleMirrorApiService`)**: Manages HTTP calls to the Python backend with automatic offline fallback to built-in presets when the backend is offline.
* **Navigation State Synchronization**: Selecting "Try This Style" anywhere in the app (Dashboard, Explorer, or My Styles) triggers `onStyleSelected`, automatically switching the active tab to the Try-On studio with the target look pre-loaded.
* **Theme Switching**: Managed reactively at the root `StyleMirrorApp` level with `isDarkMode` state propagation.
