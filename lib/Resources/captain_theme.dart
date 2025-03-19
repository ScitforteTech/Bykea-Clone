import 'package:flutter/material.dart';

class CaptainTheme {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryDarkBlue = Color(0xFF1565C0);
  static const Color goldAccent = Color(0xFFD4AF37);

  // Text Colors
  static const Color textPrimary = Color(0xFF323D4F);
  static const Color textSecondary = Color(0xFF6B7280);

  // Background Colors
  static const Color background = Color(0xFFF3F4F6);
  static const Color cardBackground = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryDarkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static TextStyle get headingLarge => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get headingMedium => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );
}
