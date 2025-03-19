import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';

class DriverPrivacyPolicyScreen extends StatelessWidget {
  const DriverPrivacyPolicyScreen({super.key});

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
    final fieldSpacing = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final titleFontSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);
    final subtitleFontSize =
        isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final bodyFontSize = isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);
    final cardRadius = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final logoSize = isSmallScreen ? 60.0 : (isMediumScreen ? 80.0 : 100.0);
    final buttonHeight = isSmallScreen ? 40.0 : (isMediumScreen ? 48.0 : 56.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: titleFontSize,
          ),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: iconSize,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sectionPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                padding: EdgeInsets.all(sectionPadding),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(cardRadius * 0.5),
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/logo1.png',
                          height: logoSize,
                          width: logoSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: fieldSpacing),
                    Text(
                      "Vroom Captain Privacy Policy",
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Last Updated: March 15, 2024",
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: fieldSpacing * 1.5),

            // Introduction
            _buildSectionTitle("Introduction", titleFontSize),
            _buildParagraph(
              "Welcome to Vroom Captain. We respect your privacy and are committed to protecting your personal data. This Privacy Policy will inform you about how we look after your personal data when you use our driver application and tell you about your privacy rights and how the law protects you.",
              bodyFontSize,
              isIntroduction: true,
            ),
            _buildParagraph(
              "This Privacy Policy aims to give you information on how Vroom Captain collects and processes your personal data through your use of this application, including any data you may provide through this application when you sign up as a driver, accept rides, or use our services.",
              bodyFontSize,
              isIntroduction: true,
            ),

            SizedBox(height: fieldSpacing),

            // Information We Collect
            _buildSectionTitle("1. Information We Collect", titleFontSize),
            _buildParagraph(
              "As a driver on Vroom Captain, we collect various types of information to ensure safe and efficient service delivery:",
              bodyFontSize,
            ),
            _buildBulletPoints([
              "Personal Information: Name, contact details, driver's license information, vehicle registration details, and profile photo",
              "Location Data: Real-time location tracking during rides and when online",
              "Vehicle Information: Make, model, year, color, and registration number",
              "Performance Data: Ratings, trip history, and earnings information",
              "Device Information: Mobile device details, app usage statistics, and technical data",
              "Background Check Information: Criminal record checks and driving history",
            ], bodyFontSize),

            SizedBox(height: fieldSpacing),

            // How We Use Your Information
            _buildSectionTitle("2. How We Use Your Information", titleFontSize),
            _buildParagraph(
              "We use the collected information for the following purposes:",
              bodyFontSize,
            ),
            _buildBulletPoints([
              "Driver Verification: To verify your identity and eligibility to drive",
              "Service Delivery: To connect you with passengers and process payments",
              "Safety & Security: To ensure safe rides and handle emergency situations",
              "Performance Monitoring: To track your ratings and maintain service quality",
              "Payment Processing: To calculate and process your earnings",
              "Communication: To send important updates about your account and the platform",
              "Legal Compliance: To meet regulatory requirements and handle disputes",
            ], bodyFontSize),

            SizedBox(height: fieldSpacing),

            // Sharing Your Information
            _buildSectionTitle("3. Data Sharing & Disclosure", titleFontSize),
            _buildParagraph(
              "We may share your information with:",
              bodyFontSize,
            ),
            _buildBulletPoints([
              "Passengers: Limited information during rides (name, photo, vehicle details)",
              "Payment Processors: For processing your earnings",
              "Insurance Providers: For coverage verification and claims",
              "Law Enforcement: When required by law or for safety reasons",
              "Service Providers: For background checks and verification services",
            ], bodyFontSize),

            SizedBox(height: fieldSpacing),

            // Data Security
            _buildSectionTitle("4. Data Security", titleFontSize),
            _buildParagraph(
              "We implement robust security measures to protect your information:",
              bodyFontSize,
            ),
            _buildBulletPoints([
              "Encryption: All data is encrypted during transmission and storage",
              "Access Controls: Strict access controls for your personal information",
              "Regular Audits: Security assessments and updates",
              "Secure Storage: Protected storage of sensitive driver data",
            ], bodyFontSize),

            SizedBox(height: fieldSpacing),

            // Your Rights
            _buildSectionTitle("5. Your Rights as a Driver", titleFontSize),
            _buildParagraph(
              "You have the right to:",
              bodyFontSize,
            ),
            _buildBulletPoints([
              "Access your personal information",
              "Correct inaccurate data",
              "Request data deletion",
              "Opt-out of marketing communications",
              "Export your data",
              "Object to data processing",
            ], bodyFontSize),

            SizedBox(height: fieldSpacing),

            // Location Services
            _buildSectionTitle("6. Location Services", titleFontSize),
            _buildParagraph(
              "Location tracking is essential for our service:",
              bodyFontSize,
            ),
            _buildBulletPoints([
              "Active tracking during rides and when online",
              "Location history for trip verification",
              "Emergency location sharing for safety",
              "Option to disable location when offline",
            ], bodyFontSize),

            SizedBox(height: fieldSpacing),

            // Data Retention
            _buildSectionTitle("7. Data Retention", titleFontSize),
            _buildParagraph(
              "We retain your information for:",
              bodyFontSize,
            ),
            _buildBulletPoints([
              "Active account period and 7 years after deactivation",
              "Legal compliance requirements",
              "Dispute resolution",
              "Service improvement purposes",
            ], bodyFontSize),

            SizedBox(height: fieldSpacing),

            // Changes to Privacy Policy
            _buildSectionTitle("8. Changes to Privacy Policy", titleFontSize),
            _buildParagraph(
              "We may update this policy periodically. You will be notified of significant changes.",
              bodyFontSize,
            ),

            SizedBox(height: fieldSpacing),

            // Contact Us
            _buildSectionTitle("9. Contact Us", titleFontSize),
            _buildParagraph(
              "For privacy-related queries, contact our driver support team at support@vroomride.com",
              bodyFontSize,
            ),

            SizedBox(height: fieldSpacing * 1.5),

            // Accept Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: fieldSpacing * 2,
                    vertical: fieldSpacing * 0.75,
                  ),
                  minimumSize: Size(0, buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight / 2),
                  ),
                ),
                child: Text(
                  "I Understand",
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: fieldSpacing * 1.5),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF323d4f),
        ),
      ),
    );
  }

  Widget _buildSubsectionTitle(String title, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: fontSize * 0.9,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF323d4f),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, double fontSize,
      {bool isIntroduction = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          color: Colors.grey[600],
          height: 1.5,
        ),
        textAlign: isIntroduction ? TextAlign.justify : TextAlign.left,
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points
          .map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        point,
                        style: GoogleFonts.poppins(
                          fontSize: fontSize,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
