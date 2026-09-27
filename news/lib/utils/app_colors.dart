import 'package:flutter/material.dart';

/// AppColors encapsulates all color constants used throughout the app for both
/// Light and Dark modes according to Clean Code standards.
class AppColors {
  AppColors._();

  // Splash Screen Colors
  static const Color splashDarkBackground = Color(0xFF171717);
  static const Color splashLightBackground = Color(0xFFFFFFFF);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF171717);
  static const Color darkSurface = Color(0xFF202020);
  static const Color darkCard = Color(0xFF1D1D1D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
  static const Color darkBorder = Color(0xFF333333);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF171717);
  static const Color lightTextSecondary = Color(0xFF757885);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Shared Brand & UI Colors
  static const Color primary = Color(0xFF171717);
  static const Color accent = Color(0xFF5B45FF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF171717);
  static const Color divider = Color(0xFFE0E0E0);

  // View All Button Colors
  static const Color viewAllPill = Color(0xFF8E8E93);
  static const Color viewAllCircleDark = Color(0xFFFFFFFF);
  static const Color viewAllCircleLight = Color(0xFF171717);
}
