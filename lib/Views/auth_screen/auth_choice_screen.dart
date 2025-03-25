import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:vroom_ride_app/Views/auth_screen/login_screen.dart';
import 'package:vroom_ride_app/Views/Driver/driver_registration.dart';
import 'package:vroom_ride_app/Views/Rider/rider_registration.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    // Calculate responsive dimensions
    final sectionPadding =
        isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final fieldSpacing = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final titleFontSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);
    final textFontSize = isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0);
    final iconSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 24.0);
    final buttonHeight = isSmallScreen ? 40.0 : (isMediumScreen ? 45.0 : 50.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sectionPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and Title Section
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Container(
                    width: isSmallScreen ? 80 : (isMediumScreen ? 100 : 120),
                    height: isSmallScreen ? 80 : (isMediumScreen ? 100 : 120),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.directions_car,
                        size: isSmallScreen ? 40 : (isMediumScreen ? 50 : 60),
                        color: AppTheme.goldAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: fieldSpacing * 2),
                Center(
                  child: Text(
                    "Vroom Ride",
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 24 : (isMediumScreen ? 28 : 32),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                ),
                SizedBox(height: fieldSpacing),
                Center(
                  child: Text(
                    "Your trusted ride partner",
                    style: GoogleFonts.poppins(
                      fontSize: textFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),

                // Auth Buttons Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(fieldSpacing),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Choose your account type",
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF323d4f),
                        ),
                      ),
                      SizedBox(height: fieldSpacing * 2),
                      _buildAuthButton(
                        context,
                        "Continue as Driver",
                        "Sign in or register as a driver",
                        Icons.directions_car,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const loginScreen(userType: 'driver'),
                            ),
                          );
                        },
                        iconSize: iconSize,
                        fontSize: textFontSize,
                        buttonHeight: buttonHeight,
                      ),
                      SizedBox(height: fieldSpacing),
                      _buildAuthButton(
                        context,
                        "Continue as Rider",
                        "Sign in or register as a rider",
                        Icons.person,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const loginScreen(userType: 'rider'),
                            ),
                          );
                        },
                        iconSize: iconSize,
                        fontSize: textFontSize,
                        buttonHeight: buttonHeight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    required double iconSize,
    required double fontSize,
    required double buttonHeight,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: buttonHeight * 2,
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(22.0),
              decoration: BoxDecoration(
                color: AppTheme.goldAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.goldAccent,
                size: iconSize,
              ),
            ),
            const SizedBox(width: 22.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: fontSize + 2,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: fontSize - 2,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: fontSize,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
