import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand colors ──────────────────────────────────────
  static const primaryColor    = Color(0xFF6C63FF); // purple
  static const secondaryColor  = Color(0xFF03DAC6); // teal accent
  static const darkBg          = Color(0xFF0F0F1A); // near black
  static const darkSurface     = Color(0xFF1A1A2E); // card bg dark
  static const lightBg         = Color(0xFFF8F8FF); // near white
  static const lightSurface    = Color(0xFFFFFFFF);

  // ── Light theme ───────────────────────────────────────
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: lightSurface,
      background: lightBg,
    ),
    scaffoldBackgroundColor: lightBg,
    textTheme: _buildTextTheme(Brightness.light),
    elevatedButtonTheme: _buttonTheme(),
  );

  // ── Dark theme ────────────────────────────────────────
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: darkSurface,
      background: darkBg,
    ),
    scaffoldBackgroundColor: darkBg,
    textTheme: _buildTextTheme(Brightness.dark),
    elevatedButtonTheme: _buttonTheme(),
  );

  // ── Text theme ────────────────────────────────────────
  static TextTheme _buildTextTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final baseColor = isLight ? const Color(0xFF1A1A2E) : Colors.white;
    final mutedColor = isLight ? const Color(0xFF6B7280) : const Color(0xFFB0B0C3);

    return TextTheme(
      // Big hero heading
      displayLarge: GoogleFonts.poppins(
        fontSize: 56, fontWeight: FontWeight.w700, color: baseColor, height: 1.1,
      ),
      // Section headings
      displayMedium: GoogleFonts.poppins(
        fontSize: 40, fontWeight: FontWeight.w700, color: baseColor, height: 1.2,
      ),
      // Card titles
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24, fontWeight: FontWeight.w600, color: baseColor,
      ),
      // Body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: mutedColor, height: 1.7,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: mutedColor, height: 1.6,
      ),
      // Nav items, labels
      labelLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w500, color: baseColor,
      ),
    );
  }

  // ── Button theme ──────────────────────────────────────
  static ElevatedButtonThemeData _buttonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}