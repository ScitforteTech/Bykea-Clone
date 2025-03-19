import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Views/auth_screen/login_screen.dart';
import 'package:vroom_ride_app/Views/auth_screen/signUp_screen.dart';
import 'driver_registration.dart';

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
    final titleFontSize = isSmallScreen ? 24.0 : (isMediumScreen ? 28.0 : 32.0);
    final subtitleFontSize =
        isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final buttonHeight = isSmallScreen ? 50.0 : (isMediumScreen ? 55.0 : 60.0);
    final buttonFontSize =
        isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 22.0 : 24.0);
    final logoSize = isSmallScreen ? 150.0 : (isMediumScreen ? 180.0 : 200.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Logo and Welcome Text
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    "assets/images/logo1.png",
                    height: logoSize,
                    width: logoSize,
                  ),
                  SizedBox(height: fieldSpacing * 2),

                  // Welcome Text
                  Text(
                    'Welcome to Vroom',
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  SizedBox(height: fieldSpacing),

                  // Subtitle
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sectionPadding * 2),
                    child: Text(
                      'Your safe and reliable ride service',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Buttons Section
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(sectionPadding * 1.5),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(sectionPadding * 2),
                    topRight: Radius.circular(sectionPadding * 2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login Button
                    _buildButton(
                      context: context,
                      title: 'Login',
                      icon: Icons.login,
                      color: const Color(0xFF323d4f),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const loginScreen(),
                          ),
                        );
                      },
                      buttonHeight: buttonHeight,
                      buttonFontSize: buttonFontSize,
                      iconSize: iconSize,
                    ),

                    SizedBox(height: fieldSpacing),

                    // Sign Up Button
                    _buildButton(
                      context: context,
                      title: 'Sign Up',
                      icon: Icons.person_add,
                      color: const Color(0xFFD4AF37),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DriverRegistrationScreen(),
                          ),
                        );
                      },
                      buttonHeight: buttonHeight,
                      buttonFontSize: buttonFontSize,
                      iconSize: iconSize,
                    ),

                    SizedBox(height: fieldSpacing * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required double buttonHeight,
    required double buttonFontSize,
    required double iconSize,
  }) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonHeight / 2),
          ),
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: buttonHeight / 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.white),
            SizedBox(width: buttonHeight / 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
