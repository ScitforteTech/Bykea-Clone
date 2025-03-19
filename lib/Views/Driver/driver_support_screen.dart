import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';

class DriverSupportScreen extends StatelessWidget {
  const DriverSupportScreen({super.key});

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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSmallScreen ? 48 : 56),
        child: AppBar(
          title: Text(
            "Support",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: isSmallScreen ? 18 : (isMediumScreen ? 20 : 22),
            ),
          ),
          backgroundColor: const Color(0xFF323d4f),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Support Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: sectionPadding, vertical: fieldSpacing * 1.5),
              decoration: const BoxDecoration(
                color: Color(0xFF323d4f),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Support Center Pill
                  Container(
                    margin: EdgeInsets.only(bottom: fieldSpacing),
                    padding: EdgeInsets.symmetric(
                        horizontal: fieldSpacing, vertical: fieldSpacing / 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Driver Support Center",
                      style: GoogleFonts.poppins(
                        fontSize: textFontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                  ),
                  Text(
                    "How can we help you?",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize + 4,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  SizedBox(height: fieldSpacing / 2),
                  Text(
                    "Our support team is here to assist you",
                    style: GoogleFonts.poppins(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: fieldSpacing * 1.5),
                ],
              ),
            ),

            // Search Bar - Positioned on the boundary
            Transform.translate(
              offset: Offset(0, -fieldSpacing * 1.5),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sectionPadding),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for help",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: textFontSize,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: iconSize,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: fieldSpacing,
                        vertical: fieldSpacing,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Quick Help Section
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: sectionPadding,
                right: sectionPadding,
                bottom: fieldSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Help",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  SizedBox(height: fieldSpacing),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: fieldSpacing,
                    mainAxisSpacing: fieldSpacing,
                    children: [
                      _buildQuickHelpCard(
                        context,
                        "Account Issues",
                        Icons.person,
                        AppTheme.goldAccent,
                        iconSize: iconSize,
                        fontSize: textFontSize,
                      ),
                      _buildQuickHelpCard(
                        context,
                        "Payment Problems",
                        Icons.payment,
                        const Color(0xFF323d4f),
                        iconSize: iconSize,
                        fontSize: textFontSize,
                      ),
                      _buildQuickHelpCard(
                        context,
                        "Ride Issues",
                        Icons.directions_car,
                        AppTheme.goldAccent,
                        iconSize: iconSize,
                        fontSize: textFontSize,
                      ),
                      _buildQuickHelpCard(
                        context,
                        "App Problems",
                        Icons.smartphone,
                        const Color(0xFF323d4f),
                        iconSize: iconSize,
                        fontSize: textFontSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // FAQ Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sectionPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Frequently Asked Questions",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  SizedBox(height: fieldSpacing),
                  _buildFaqItem(
                    "How do I update my vehicle information?",
                    "Go to your profile settings and select 'Vehicle Information' to update your details.",
                    fontSize: textFontSize,
                  ),
                  _buildFaqItem(
                    "What documents do I need to submit?",
                    "You need to submit your driver's license, vehicle registration, and insurance documents.",
                    fontSize: textFontSize,
                  ),
                  _buildFaqItem(
                    "How are payments processed?",
                    "Payments are processed weekly and transferred directly to your registered bank account.",
                    fontSize: textFontSize,
                  ),
                  _buildFaqItem(
                    "How do I report an issue with a passenger?",
                    "Go to your ride history, select the specific ride, and tap 'Report an Issue'. Follow the prompts to provide details.",
                    fontSize: textFontSize,
                  ),
                ],
              ),
            ),

            // Contact Support Section
            Padding(
              padding: EdgeInsets.all(sectionPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact Support",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  SizedBox(height: fieldSpacing),
                  Container(
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
                        _buildContactOption(
                          "Chat with Support",
                          "Get help from our support team",
                          Icons.chat_bubble_outline,
                          () {
                            // Add chat functionality
                          },
                          iconSize: iconSize,
                          fontSize: textFontSize,
                        ),
                        Divider(height: fieldSpacing * 1.5),
                        _buildContactOption(
                          "Call Support",
                          "24/7 Emergency Support",
                          Icons.phone_in_talk,
                          () {
                            // Add call functionality
                          },
                          iconSize: iconSize,
                          fontSize: textFontSize,
                        ),
                        Divider(height: fieldSpacing * 1.5),
                        _buildContactOption(
                          "Email Support",
                          "support@vroomride.com",
                          Icons.email_outlined,
                          () {
                            // Add email functionality
                          },
                          iconSize: iconSize,
                          fontSize: textFontSize,
                        ),
                        Divider(height: fieldSpacing * 1.5),
                        _buildContactOption(
                          "Visit Center",
                          "Find nearest office",
                          Icons.location_on_outlined,
                          () {
                            // Add location functionality
                          },
                          iconSize: iconSize,
                          fontSize: textFontSize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    required double iconSize,
    required double fontSize,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Add navigation
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(fontSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(fontSize),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: iconSize,
                ),
              ),
              SizedBox(height: fontSize),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323d4f),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(
    String question,
    String answer, {
    required double fontSize,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF323d4f),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(fontSize, 0, fontSize, fontSize),
            child: Text(
              answer,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    required double iconSize,
    required double fontSize,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(fontSize),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: iconSize,
            ),
          ),
          SizedBox(width: fontSize),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF323d4f),
                  ),
                ),
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
    );
  }
}
