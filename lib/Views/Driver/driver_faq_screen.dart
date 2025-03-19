import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';

class DriverFAQScreen extends StatefulWidget {
  const DriverFAQScreen({super.key});

  @override
  State<DriverFAQScreen> createState() => _DriverFAQScreenState();
}

class _DriverFAQScreenState extends State<DriverFAQScreen> {
  // Track which categories are expanded
  final Map<String, bool> _expandedCategories = {};

  // Track which questions are expanded within each category
  final Map<String, Set<int>> _expandedQuestions = {
    'Getting Started': {},
    'Earnings': {},
    'Ride Management': {},
    'Payments': {},
    'Documents': {},
    'Support': {},
  };

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
    final subtitleFontSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0);
    final headingFontSize =
        isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final bodyFontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 16.0);
    final iconSize = isSmallScreen ? 24.0 : (isMediumScreen ? 28.0 : 32.0);
    final cardRadius = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final logoSize = isSmallScreen ? 50.0 : (isMediumScreen ? 60.0 : 70.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Frequently Asked Questions",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: titleFontSize,
          ),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(
          color: Colors.white,
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
                      borderRadius: BorderRadius.circular(cardRadius * 0.67),
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
                      "How can we help you?",
                      style: GoogleFonts.poppins(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Find answers to common questions",
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: fieldSpacing * 1.5),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search FAQs',
                  prefixIcon: Icon(Icons.search,
                      color: const Color(0xFF323d4f), size: iconSize * 0.75),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: fieldSpacing),
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: subtitleFontSize,
                  ),
                ),
              ),
            ),

            SizedBox(height: fieldSpacing * 1.5),

            // FAQ Categories
            _buildFAQCategory(
              'Getting Started',
              [
                {
                  'question': 'How do I start accepting rides?',
                  'answer':
                      'To start accepting rides, simply go online by tapping the "Go Online" button on your dashboard. Once online, you\'ll receive ride requests from nearby passengers.'
                },
                {
                  'question': 'What documents do I need to start driving?',
                  'answer':
                      'You need a valid driver\'s license, vehicle registration, and insurance documents. All documents must be current and in your name or the vehicle owner\'s name.'
                },
                {
                  'question': 'How do I set up my vehicle information?',
                  'answer':
                      'Go to your profile settings and select "Vehicle Information". Enter your vehicle details including make, model, year, color, and registration number. You\'ll also need to upload photos of your vehicle.'
                },
              ],
              headingFontSize,
              bodyFontSize,
              sectionPadding,
              cardRadius,
              iconSize,
            ),

            _buildFAQCategory(
              'Earnings',
              [
                {
                  'question': 'How are my earnings calculated?',
                  'answer':
                      'Your earnings are calculated based on the base fare, distance traveled, and time spent on the trip. You can view detailed breakdowns in your earnings section.'
                },
                {
                  'question': 'When do I receive my payments?',
                  'answer':
                      'Payments are processed weekly. You can withdraw your earnings through your wallet once they\'re available. Minimum withdrawal amount is Rs. 500.'
                },
                {
                  'question': 'What affects my earnings?',
                  'answer':
                      'Your earnings can be affected by cancellations, low ratings, and service quality issues. Maintaining a high rating and good service quality helps maximize your earnings.'
                },
              ],
              headingFontSize,
              bodyFontSize,
              sectionPadding,
              cardRadius,
              iconSize,
            ),

            _buildFAQCategory(
              'Ride Management',
              [
                {
                  'question': 'What happens if I cancel a ride?',
                  'answer':
                      'Canceling rides may affect your acceptance rate. We recommend only canceling rides in emergency situations. Multiple cancellations may result in temporary suspension.'
                },
                {
                  'question': 'How do I handle difficult passengers?',
                  'answer':
                      'Always maintain professional conduct. If a situation becomes unsafe, use the emergency button in the app. Document any issues and report them to support.'
                },
                {
                  'question': 'Can I choose which rides to accept?',
                  'answer':
                      'Yes, you can choose which rides to accept based on your preferences. However, maintaining a good acceptance rate is important for your account status.'
                },
              ],
              headingFontSize,
              bodyFontSize,
              sectionPadding,
              cardRadius,
              iconSize,
            ),

            _buildFAQCategory(
              'Payments',
              [
                {
                  'question': 'How do I withdraw my earnings?',
                  'answer':
                      'You can withdraw your earnings through your wallet. Minimum withdrawal amount is Rs. 500. Withdrawals are processed within 24-48 hours.'
                },
                {
                  'question': 'What payment methods are available?',
                  'answer':
                      'We support bank transfers and mobile payment services. You can add your preferred payment method in the wallet section.'
                },
                {
                  'question': 'How do I track my payments?',
                  'answer':
                      'You can view your payment history in the earnings section. Each transaction includes a detailed breakdown of the fare components.'
                },
              ],
              headingFontSize,
              bodyFontSize,
              sectionPadding,
              cardRadius,
              iconSize,
            ),

            _buildFAQCategory(
              'Documents',
              [
                {
                  'question': 'What documents do I need to maintain?',
                  'answer':
                      'You need to keep your driver\'s license, vehicle registration, and insurance documents up to date. These documents are required for verification.'
                },
                {
                  'question': 'How often do I need to update my documents?',
                  'answer':
                      'Documents should be updated before they expire. You\'ll receive notifications when documents are approaching expiration.'
                },
                {
                  'question': 'How do I update my documents?',
                  'answer':
                      'Go to your profile settings and select "Documents". Upload clear photos of your updated documents for verification.'
                },
              ],
              headingFontSize,
              bodyFontSize,
              sectionPadding,
              cardRadius,
              iconSize,
            ),

            _buildFAQCategory(
              'Support',
              [
                {
                  'question': 'How do I handle passenger complaints?',
                  'answer':
                      'Always maintain professional conduct. If a passenger files a complaint, our support team will review the situation and contact you for details.'
                },
                {
                  'question': 'How do I contact support?',
                  'answer':
                      'You can contact support through the app\'s help section or call our 24/7 support line. For urgent issues, use the emergency button.'
                },
                {
                  'question': 'What should I do in case of an accident?',
                  'answer':
                      'First, ensure everyone\'s safety and call emergency services if needed. Then, use the emergency button in the app to notify our support team.'
                },
              ],
              headingFontSize,
              bodyFontSize,
              sectionPadding,
              cardRadius,
              iconSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCategory(
      String title,
      List<Map<String, String>> questions,
      double headingSize,
      double textSize,
      double padding,
      double radius,
      double iconSize) {
    final isExpanded = _expandedCategories[title] ?? false;
    final expandedQuestions = _expandedQuestions[title] ?? {};

    return Container(
      margin: EdgeInsets.only(bottom: padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedCategories[title] = !isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: const Color(0xFF323d4f),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                    size: iconSize * 0.75,
                  ),
                ],
              ),
            ),
          ),

          // Questions
          if (isExpanded)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final isQuestionExpanded = expandedQuestions.contains(index);

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isQuestionExpanded) {
                            expandedQuestions.remove(index);
                          } else {
                            expandedQuestions.add(index);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(padding),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                question['question']!,
                                style: GoogleFonts.poppins(
                                  fontSize: textSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              isQuestionExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.grey[600],
                              size: iconSize * 0.75,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isQuestionExpanded)
                      Container(
                        padding: EdgeInsets.all(padding),
                        color: Colors.grey[50],
                        child: Text(
                          question['answer']!,
                          style: GoogleFonts.poppins(
                            fontSize: textSize * 0.93,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
