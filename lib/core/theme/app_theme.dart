import 'package:flutter/material.dart';

/// StyleMirror Premium AI Men's Grooming Theme
/// Exact Palette specified in Master Design System:
/// - Primary background: #101114
/// - Secondary background: #191B20
/// - Card background: #22252B
/// - Primary accent: #B9A0FF (Electric Lavender)
/// - Secondary accent: #D4C5A5 (Champagne Barber Gold)
/// - Primary text: #FFFFFF
/// - Secondary text: #A1A1AA
/// - Success: #4ADE80
/// - Error: #F87171
class AppTheme {
  // Master Color Palette
  static const Color background = Color(0xFF101114);
  static const Color secondaryBackground = Color(0xFF191B20);
  static const Color cardBackground = Color(0xFF22252B);
  static const Color primaryAccent = Color(0xFFB9A0FF);
  static const Color secondaryAccent = Color(0xFFD4C5A5);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFA1A1AA);
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFF87171);

  // Surface & Border aliases for backward compatibility and design harmony
  static const Color surface = Color(0xFF191B20);
  static const Color surfaceElevated = Color(0xFF22252B);
  static const Color border = Color(0xFF2A2E37);
  static const Color borderHighlight = Color(0xFFB9A0FF);

  // Brand aliases
  static const Color primary = Color(0xFFB9A0FF);
  static const Color primaryLight = Color(0xFFD4C5A5);
  static const Color accentGold = Color(0xFFD4C5A5);
  static const Color accentCyan = Color(0xFF67E8F9);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFF87171);
  static const Color warning = Color(0xFFFB923C);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFFA1A1AA);

  // --- DARK THEME (PRIMARY) ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        secondary: secondaryAccent,
        surface: surface,
        error: error,
        onPrimary: Color(0xFF101114),
        onSecondary: Color(0xFF101114),
        onSurface: primaryText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: const Color(0xFF101114),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryText,
          side: const BorderSide(color: border, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevated,
        selectedColor: primaryAccent.withOpacity(0.25),
        secondarySelectedColor: primaryAccent,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border, width: 1),
        ),
        labelStyle: const TextStyle(fontSize: 13, color: secondaryText),
        secondaryLabelStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        hintStyle: const TextStyle(color: secondaryText, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 1.5),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryAccent,
        unselectedLabelColor: secondaryText,
        indicatorColor: primaryAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  // --- LIGHT THEME VARIATION ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      primaryColor: const Color(0xFF7C3AED),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF7C3AED),
        secondary: Color(0xFF92400E),
        surface: Colors.white,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF18181B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFF18181B),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: Color(0xFF18181B)),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE4E4E7), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
