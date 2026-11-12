import 'package:flutter/material.dart';

/// StyleMirror Editorial Barbershop & Clean Modern SaaS Theme
/// Design System Specifications:
/// - Light, editorial, spacious with optional dark mode toggle.
/// - Colors (Light Mode):
///   - Background: warm ivory #F7F5F0
///   - Surface/cards: #FFFFFF with 1px border #E7E2D9
///   - Primary text: ink navy #0F1B2D
///   - Secondary text: slate #5B6678
///   - Primary accent: deep emerald #0F766E (buttons, active states, links)
///   - Secondary accent: copper #B5733A (badges, highlights, small details only)
///   - Success: #16A34A
///   - Error: #DC2626
/// - Colors (Dark Mode):
///   - Background: #0B1220
///   - Cards: #131C2E with 1px border #1E293B
///   - Primary text: #F8FAFC
///   - Secondary text: #94A3B8
///   - Accents: Deep emerald #0F766E & Copper #B5733A
/// - Typography: Headings in Serif (Playfair / DM Serif style), UI in Sans-Serif (Inter)
/// - Shapes: 14px radius cards, 10px radius buttons, soft shadows (0 8px 24px rgba(15,27,45,0.08))
class AppTheme {
  // Light Palette Tokens
  static const Color ivoryBackground = Color(0xFFF7F5F0); // Warm Ivory
  static const Color cardWhite = Color(0xFFFFFFFF);       // Clean Card Surface
  static const Color borderIvory = Color(0xFFE7E2D9);     // Subtle 1px Border
  static const Color inkNavy = Color(0xFF0F1B2D);         // High Contrast Ink Navy
  static const Color slate = Color(0xFF5B6678);           // Refined Slate
  static const Color deepEmerald = Color(0xFF0F766E);     // Deep Emerald Accent
  static const Color copper = Color(0xFFB5733A);          // Copper Accent (Badges/Details)
  static const Color successGreen = Color(0xFF16A34A);    // Success
  static const Color errorRed = Color(0xFFDC2626);        // Error

  // Dark Palette Tokens
  static const Color darkBackground = Color(0xFF0B1220);  // Dark Obsidian Navy
  static const Color darkCard = Color(0xFF131C2E);        // Dark Card Surface
  static const Color darkBorder = Color(0xFF1E293B);      // Dark 1px Border
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // High Contrast White
  static const Color darkTextSecondary = Color(0xFF94A3B8);// Slate Grey

  // Primary Canonical References (Default Light Theme)
  static const Color background = ivoryBackground;
  static const Color secondaryBackground = Color(0xFFEFECE5);
  static const Color cardBackground = cardWhite;
  static const Color primaryAccent = deepEmerald;
  static const Color secondaryAccent = copper;
  static const Color primaryText = inkNavy;
  static const Color secondaryText = slate;
  static const Color success = successGreen;
  static const Color error = errorRed;
  static const Color danger = errorRed;
  static const Color border = borderIvory;

  // Backward-compatible Brand Aliases
  static const Color surface = cardWhite;
  static const Color surfaceElevated = cardWhite;
  static const Color borderHighlight = deepEmerald;
  static const Color primary = deepEmerald;
  static const Color primaryLight = copper;
  static const Color accentGold = copper;
  static const Color accentCyan = deepEmerald;
  static const Color textPrimary = inkNavy;
  static const Color textSecondary = slate;
  static const Color textMuted = slate;

  // Elevation & Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x140F1B2D), // rgba(15, 27, 45, 0.08)
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static const BoxShadow subtleShadow = BoxShadow(
    color: Color(0x0A0F1B2D),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  // Border Radii
  static final BorderRadius cardRadius = BorderRadius.circular(14);
  static final BorderRadius buttonRadius = BorderRadius.circular(10);
  static final BorderRadius chipRadius = BorderRadius.circular(20);

  // --- LIGHT THEME (PRIMARY DEFAULT) ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ivoryBackground,
      primaryColor: deepEmerald,
      colorScheme: const ColorScheme.light(
        primary: deepEmerald,
        secondary: copper,
        surface: cardWhite,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: inkNavy,
      ),
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: ivoryBackground,
        foregroundColor: inkNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'serif',
          color: inkNavy,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: inkNavy),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: borderIvory, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepEmerald,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: inkNavy,
          side: const BorderSide(color: borderIvory, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: deepEmerald,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardWhite,
        selectedColor: deepEmerald.withOpacity(0.12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderIvory, width: 1),
        ),
        labelStyle: const TextStyle(fontSize: 12, color: slate, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(fontSize: 12, color: deepEmerald, fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardWhite,
        hintStyle: const TextStyle(color: slate, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderIvory),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderIvory),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: deepEmerald, width: 1.5),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: deepEmerald,
        unselectedLabelColor: slate,
        indicatorColor: deepEmerald,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardWhite,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderIvory),
        ),
      ),
    );
  }

  // --- DARK THEME (OPTIONAL TOGGLE) ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: deepEmerald,
      colorScheme: const ColorScheme.dark(
        primary: deepEmerald,
        secondary: copper,
        surface: darkCard,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'serif',
          color: darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepEmerald,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkBorder, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        selectedColor: deepEmerald.withOpacity(0.25),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        labelStyle: const TextStyle(fontSize: 12, color: darkTextSecondary),
        secondaryLabelStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        hintStyle: const TextStyle(color: darkTextSecondary, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: deepEmerald, width: 1.5),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: deepEmerald,
        unselectedLabelColor: darkTextSecondary,
        indicatorColor: deepEmerald,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorder),
        ),
      ),
    );
  }
}
