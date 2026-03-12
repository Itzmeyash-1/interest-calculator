// lib/utils/app_theme.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDeep = Color(0xFF0D47A1);      // Deep Blue
  static const Color primary = Color(0xFF1565C0);           // Blue
  static const Color primaryLight = Color(0xFF1976D2);      // Medium Blue
  static const Color skyBlue = Color(0xFF29B6F6);           // Sky Blue
  static const Color skyBlueLight = Color(0xFF81D4FA);      // Light Sky Blue
  static const Color accentTeal = Color(0xFF00ACC1);        // Teal accent
  static const Color backgroundGradientStart = Color(0xFFE3F2FD); // Very Light Blue
  static const Color backgroundGradientEnd = Color(0xFFEFF8FF);   // Near White Blue
  static const Color cardBackground = Colors.white;
  static const Color inputBackground = Color(0xFFF0F7FF);
  static const Color inputBorder = Color(0xFFBBDEFB);
  static const Color labelText = Color(0xFF5C7A99);
  static const Color valueText = Color(0xFF0D1B2A);
  static const Color positiveGreen = Color(0xFF00897B);
  static const Color negativeRed = Color(0xFFE53935);
  static const Color divider = Color(0xFFDCEEFD);
  static const Color shadowBlue = Color(0x1A1565C0);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.skyBlue, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.labelText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
