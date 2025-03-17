import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryBlue = Color(0xFF323D4F);
  static const goldAccent = Color(0xFFD4AF37);

  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      // App Bar Title
      titleLarge: GoogleFonts.poppins(
        fontSize: MediaQuery.of(context).size.width / 20,
        fontWeight: FontWeight.w300,
        color: Colors.black87,
      ),
      // Headings
      headlineMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      // Primary Body Text
      bodyLarge: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
      // Secondary Body Text
      bodyMedium: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Colors.grey[600],
      ),
      // Small Text
      bodySmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Colors.grey[600],
      ),
      // Button Text
      labelLarge: GoogleFonts.poppins(
        fontSize: MediaQuery.of(context).size.width * 0.028,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  static ThemeData theme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: goldAccent,
      ),
      textTheme: textTheme(context),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.grey[300],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
          ),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(
        color: goldAccent,
        size: 24, // Default navigation icon size
      ),
    );
  }

  // Custom spacing constants
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 12.0;
  static const double largeSpacing = 16.0;

  // Custom icon sizes
  static const double smallIconSize = 14.0;
  static const double locationDotSize = 8.0;
  static const double navigationIconSize = 24.0;

  // Custom text styles for specific use cases
  static TextStyle fareAmountStyle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle boldTextStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );
}
