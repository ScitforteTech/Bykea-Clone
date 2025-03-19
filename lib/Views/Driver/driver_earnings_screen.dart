import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/custom_size.dart';
import '../../Resources/theme.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({super.key});

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  String selectedPeriod = 'Today';
  final List<String> periods = ['Today', 'Week', 'Month'];

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
    final iconSize = isSmallScreen ? 24.0 : (isMediumScreen ? 28.0 : 32.0);
    final cardPadding = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final cardRadius = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final chipHeight = isSmallScreen ? 40.0 : (isMediumScreen ? 45.0 : 50.0);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        title: Text(
          'Earnings',
          style: GoogleFonts.poppins(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          _buildEarningsSummary(context, iconSize, sectionPadding, cardRadius),
          _buildPeriodSelector(context, chipHeight),
          _buildEarningsBreakdown(context, headingFontSize, subtitleFontSize,
              cardPadding, cardRadius),
          Expanded(
            child: _buildEarningsHistory(context, headingFontSize,
                subtitleFontSize, cardPadding, cardRadius),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSummary(
      BuildContext context, double iconSize, double padding, double radius) {
    return Container(
      margin: EdgeInsets.all(padding),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEarningItem('Total Earnings', 'Rs. 8,450', 'PKR', iconSize),
              _buildEarningItem(
                  'Rides', '12', 'assets/images/sedan.png', iconSize),
              _buildEarningItem('Tips', 'Rs. 450',
                  Icons.volunteer_activism_rounded, iconSize),
            ],
          ),
          SizedBox(height: padding),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: padding, vertical: padding / 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up,
                    color: Colors.green[300], size: iconSize * 0.625),
                SizedBox(width: padding / 2),
                Text(
                  '20% more than last week',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningItem(
      String label, String value, dynamic icon, double iconSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: iconSize * 2,
          child: Center(
            child: icon is IconData
                ? Icon(icon, color: Colors.white, size: iconSize)
                : icon is String && icon.contains('assets/')
                    ? Image.asset(
                        icon,
                        width: iconSize * 1.875,
                        height: iconSize * 1.875,
                      )
                    : Text(
                        icon,
                        style: GoogleFonts.poppins(
                          fontSize: iconSize * 0.75,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(BuildContext context, double height) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: height * 0.32),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: height * 0.16),
            child: FilterChip(
              label: Text(
                periods[index],
                style: GoogleFonts.poppins(
                  fontSize: height * 0.28,
                  fontWeight: FontWeight.w500,
                  color: selectedPeriod == periods[index]
                      ? Colors.white
                      : const Color(0xFF323D4F),
                ),
              ),
              selected: selectedPeriod == periods[index],
              onSelected: (bool selected) {
                setState(() {
                  selectedPeriod = periods[index];
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF323D4F),
              checkmarkColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEarningsBreakdown(BuildContext context, double headingSize,
      double textSize, double padding, double radius) {
    return Container(
      margin: EdgeInsets.all(padding),
      padding: EdgeInsets.all(padding),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earnings Breakdown',
            style: GoogleFonts.poppins(
              fontSize: headingSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF323D4F),
            ),
          ),
          SizedBox(height: padding),
          _buildBreakdownItem('Base Fare', 'Rs. 6,500', textSize),
          _buildBreakdownItem('Tips', 'Rs. 450', textSize),
          _buildBreakdownItem('Bonuses', 'Rs. 1,500', textSize),
          Divider(height: padding * 1.5),
          _buildBreakdownItem('Total', 'Rs. 8,450', headingSize, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, String value, double fontSize,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF323D4F),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF323D4F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsHistory(BuildContext context, double headingSize,
      double textSize, double padding, double radius) {
    final List<Map<String, dynamic>> earningsHistory = [
      {
        'date': 'Today',
        'rides': 3,
        'earnings': 'Rs. 2,150',
        'tips': 'Rs. 150',
      },
      {
        'date': 'Yesterday',
        'rides': 4,
        'earnings': 'Rs. 2,800',
        'tips': 'Rs. 200',
      },
      {
        'date': 'Mar 15',
        'rides': 5,
        'earnings': 'Rs. 3,500',
        'tips': 'Rs. 100',
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: earningsHistory.length,
      itemBuilder: (context, index) {
        final data = earningsHistory[index];
        return Card(
          margin: EdgeInsets.only(bottom: padding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 2,
          shadowColor: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['date'],
                      style: GoogleFonts.poppins(
                        fontSize: headingSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323D4F),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding * 0.75,
                        vertical: padding * 0.25,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(radius * 1.67),
                      ),
                      child: Text(
                        '${data['rides']} rides',
                        style: GoogleFonts.poppins(
                          fontSize: textSize * 0.75,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: padding * 0.75),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earnings',
                          style: GoogleFonts.poppins(
                            fontSize: textSize * 0.75,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: padding * 0.25),
                        Text(
                          data['earnings'],
                          style: GoogleFonts.poppins(
                            fontSize: headingSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF323D4F),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tips',
                          style: GoogleFonts.poppins(
                            fontSize: textSize * 0.75,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: padding * 0.25),
                        Text(
                          data['tips'],
                          style: GoogleFonts.poppins(
                            fontSize: headingSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
