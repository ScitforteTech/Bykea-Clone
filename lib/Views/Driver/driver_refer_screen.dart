import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';

class DriverReferScreen extends StatelessWidget {
  const DriverReferScreen({super.key});

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
    final smallTextSize = isSmallScreen ? 10.0 : (isMediumScreen ? 11.0 : 12.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);
    final cardRadius = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final logoSize = isSmallScreen ? 60.0 : (isMediumScreen ? 80.0 : 100.0);
    final avatarSize = isSmallScreen ? 32.0 : (isMediumScreen ? 40.0 : 48.0);
    final stepNumberSize =
        isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Refer & Earn",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Referral Banner
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF323d4f),
                    const Color(0xFF323d4f).withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(sectionPadding),
                child: Column(
                  children: [
                    // Illustration
                    Image.asset(
                      'assets/images/logo1.png',
                      height: logoSize,
                      width: logoSize,
                      color: Colors.white,
                    ),
                    SizedBox(height: fieldSpacing),
                    Text(
                      "Invite Drivers & Earn Rewards",
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: fieldSpacing / 2),
                    Text(
                      "Share your referral code with other drivers and earn Rs. 500 for each successful referral!",
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: fieldSpacing * 1.5),
                  ],
                ),
              ),
            ),

            // Referral Code Section
            Padding(
              padding: EdgeInsets.all(sectionPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Referral Code",
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  SizedBox(height: fieldSpacing),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: fieldSpacing,
                        vertical: fieldSpacing * 1.25,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "VR123456",
                              style: GoogleFonts.poppins(
                                fontSize: subtitleFontSize * 1.2,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF323d4f),
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                  const ClipboardData(text: "VR123456"));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Referral code copied to clipboard!',
                                    style: GoogleFonts.poppins(
                                      fontSize: bodyFontSize,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFF323d4f),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              color: const Color(0xFF323d4f),
                              size: iconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: fieldSpacing * 1.5),

                  // Share Options
                  Text(
                    "Share Via",
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  SizedBox(height: fieldSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShareOption(
                        icon: Icons.message,
                        label: "WhatsApp",
                        color: Colors.green,
                        iconSize: iconSize,
                        fontSize: smallTextSize,
                      ),
                      _buildShareOption(
                        icon: Icons.facebook,
                        label: "Facebook",
                        color: Colors.blue,
                        iconSize: iconSize,
                        fontSize: smallTextSize,
                      ),
                      _buildShareOption(
                        icon: Icons.sms,
                        label: "SMS",
                        color: Colors.orange,
                        iconSize: iconSize,
                        fontSize: smallTextSize,
                      ),
                      _buildShareOption(
                        icon: Icons.more_horiz,
                        label: "More",
                        color: Colors.grey,
                        iconSize: iconSize,
                        fontSize: smallTextSize,
                      ),
                    ],
                  ),
                  SizedBox(height: fieldSpacing * 1.5),

                  // How it works
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF323d4f).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(cardRadius),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(fieldSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "How It Works",
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF323d4f),
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          _buildHowItWorksStep(
                            number: "1",
                            title: "Share your code",
                            description:
                                "Share your unique referral code with other drivers who haven't joined Vroom Ride yet.",
                            fontSize: bodyFontSize,
                            stepNumberSize: stepNumberSize,
                          ),
                          _buildHowItWorksStep(
                            number: "2",
                            title: "They join",
                            description:
                                "Your referred driver uses your code during registration and completes the onboarding process.",
                            fontSize: bodyFontSize,
                            stepNumberSize: stepNumberSize,
                          ),
                          _buildHowItWorksStep(
                            number: "3",
                            title: "Complete rides",
                            description:
                                "The referred driver completes 10 rides to qualify for the referral bonus.",
                            fontSize: bodyFontSize,
                            stepNumberSize: stepNumberSize,
                          ),
                          _buildHowItWorksStep(
                            number: "4",
                            title: "Get rewarded",
                            description:
                                "You receive Rs. 500 in your wallet within 24 hours after the referred driver completes 10 rides.",
                            fontSize: bodyFontSize,
                            stepNumberSize: stepNumberSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: fieldSpacing * 1.5),

                  // Referral History
                  Text(
                    "Referral History",
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  SizedBox(height: fieldSpacing),
                  _buildReferralItem(
                    name: "Saqib Khan",
                    date: "March 15, 2024",
                    status: "Completed",
                    amount: "Rs. 500",
                    fontSize: bodyFontSize,
                    avatarSize: avatarSize,
                  ),
                  const Divider(),
                  _buildReferralItem(
                    name: "Afzal Rehman",
                    date: "March 10, 2024",
                    status: "Pending",
                    amount: "Rs. 500",
                    fontSize: bodyFontSize,
                    avatarSize: avatarSize,
                  ),
                  SizedBox(height: fieldSpacing * 1.5),

                  // Terms and Conditions
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(fieldSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Terms & Conditions",
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF323d4f),
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          Text(
                            "• Referral bonus will be credited after the referred driver completes 10 rides\n• Maximum 5 referrals per month\n• Referred driver must use your code during registration\n• Bonus will be credited to your wallet within 24 hours",
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required double iconSize,
    required double fontSize,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(iconSize * 0.5),
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
        SizedBox(height: iconSize * 0.25),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksStep({
    required String number,
    required String title,
    required String description,
    required double fontSize,
    required double stepNumberSize,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: stepNumberSize,
            height: stepNumberSize,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: fontSize * 0.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: stepNumberSize * 0.5),
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
                SizedBox(height: fontSize * 0.25),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize * 0.8,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralItem({
    required String name,
    required String date,
    required String status,
    required String amount,
    required double fontSize,
    required double avatarSize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: fontSize * 0.5),
      child: Row(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0],
                style: GoogleFonts.poppins(
                  fontSize: fontSize * 1.1,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4AF37),
                ),
              ),
            ),
          ),
          SizedBox(width: fontSize * 0.75),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize * 0.8,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4AF37),
                ),
              ),
              Text(
                status,
                style: GoogleFonts.poppins(
                  fontSize: fontSize * 0.8,
                  color: status == "Completed" ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
