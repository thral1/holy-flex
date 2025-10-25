import 'package:flutter/material.dart';

/// Holy Flex App Theme - Based on Figma Design
class AppTheme {
  // Primary Colors from Figma
  static const Color darkBackground = Color(0xFF1E1E1E); // Dark gray/black
  static const Color cyanAccent = Color(0xFF7FE9DE); // Light cyan/turquoise
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color mediumGray = Color(0xFF9E9E9E);

  // Semantic Colors
  static const Color correctAnswer = Color(0xFF4CAF50); // Green
  static const Color wrongAnswer = Color(0xFFE53935); // Red
  static const Color progressBarActive = cyanAccent;
  static const Color progressBarInactive = Color(0xFF424242);

  // Typography
  static const String primaryFont = 'Helvetica';

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: cyanAccent,

      colorScheme: const ColorScheme.dark(
        primary: cyanAccent,
        secondary: cyanAccent,
        surface: darkBackground,
        background: darkBackground,
        error: wrongAnswer,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: cyanAccent,
          letterSpacing: 4,
        ),
        displayMedium: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: white,
          letterSpacing: 2,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: white,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: lightGray,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: white,
          fontStyle: FontStyle.italic,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cyanAccent,
          foregroundColor: darkBackground,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
