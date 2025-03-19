import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/custom_size.dart';
import '../../Resources/theme.dart';

class DriverRideHistoryScreen extends StatefulWidget {
  const DriverRideHistoryScreen({super.key});

  @override
  State<DriverRideHistoryScreen> createState() =>
      _DriverRideHistoryScreenState();
}

class _DriverRideHistoryScreenState extends State<DriverRideHistoryScreen> {
  String selectedFilter = 'Today';
  final List<String> filters = [
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days'
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive dimensions
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final titleFontSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 22.0);
    final containerPadding =
        isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final cardRadius = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 16.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 24.0);
    final statIconSize = isSmallScreen ? 32.0 : (isMediumScreen ? 36.0 : 40.0);
    final statLabelSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 12.0);
    final statValueSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 18.0);
    final trendTextSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 12.0);
    final filterHeight = isSmallScreen ? 40.0 : (isMediumScreen ? 50.0 : 50.0);
    final filterFontSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 14.0);
    final rideCardPadding =
        isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final rideNumberSize =
        isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 14.0);
    final rideTimeSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 12.0);
    final rideLocationSize =
        isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 14.0);
    final rideDetailsSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 13.0);
    final rideAmountSize =
        isSmallScreen ? 15.0 : (isMediumScreen ? 16.0 : 16.0);
    final vehicleIconSize =
        isSmallScreen ? 40.0 : (isMediumScreen ? 48.0 : 48.0);
    final statusPadding = isSmallScreen ? 6.0 : (isMediumScreen ? 8.0 : 8.0);
    final statusFontSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 13.0);
    final locationIconSize =
        isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 18.0);
    final timeIconSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final starIconSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 18.0);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        title: Text(
          'Ride History',
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
          _buildDriverStats(context),
          _buildFilterSection(context),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(containerPadding),
              itemCount: 2,
              itemBuilder: (context, index) {
                return _buildDriverRideCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverStats(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final containerPadding =
        isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final cardRadius = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 16.0);
    final statIconSize = isSmallScreen ? 32.0 : (isMediumScreen ? 36.0 : 40.0);
    final statLabelSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 12.0);
    final statValueSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 18.0);
    final trendTextSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 12.0);
    final trendIconSize = isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 20.0);
    final trendPadding = isSmallScreen ? 6.0 : (isMediumScreen ? 8.0 : 8.0);

    return Container(
      margin: EdgeInsets.all(containerPadding),
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Today\'s Rides', '2', 'assets/images/sedan.png',
                  null, statIconSize * 1.5, statLabelSize, statValueSize),
              _buildStatItem('Today\'s Earnings', 'Rs. 1,205', 'pkr', null,
                  statIconSize * 0.8, statLabelSize, statValueSize),
              _buildStatItem('Rating', '4.78', Icons.star, AppTheme.goldAccent,
                  statIconSize * 0.9, statLabelSize, statValueSize),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: containerPadding, vertical: trendPadding),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up,
                    color: Colors.green[300], size: trendIconSize),
                const SizedBox(width: 8),
                Text(
                  '15% more than yesterday',
                  style: GoogleFonts.poppins(
                    fontSize: trendTextSize,
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

  Widget _buildStatItem(String label, String value, dynamic icon,
      [Color? iconColor,
      double? iconSize,
      double? labelSize,
      double? valueSize]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          child: Center(
            child: icon is IconData
                ? Icon(icon,
                    color: iconColor ?? Colors.white, size: iconSize ?? 32)
                : icon is String && icon.contains('pkr')
                    ? Text(
                        'PKR',
                        style: GoogleFonts.poppins(
                          fontSize: iconSize ?? 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    : Image.asset(
                        icon,
                        width: iconSize ?? 60,
                        height: iconSize ?? 60,
                      ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: labelSize ?? 11,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: valueSize ?? 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final filterHeight = isSmallScreen ? 40.0 : (isMediumScreen ? 50.0 : 50.0);
    final filterFontSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 14.0);
    final filterPadding = isSmallScreen ? 6.0 : (isMediumScreen ? 8.0 : 8.0);

    return Container(
      height: filterHeight,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: filterPadding),
            child: FilterChip(
              label: Text(
                filters[index],
                style: GoogleFonts.poppins(
                  fontSize: filterFontSize,
                  fontWeight: FontWeight.w500,
                  color: selectedFilter == filters[index]
                      ? Colors.white
                      : const Color(0xFF323D4F),
                ),
              ),
              selected: selectedFilter == filters[index],
              onSelected: (bool selected) {
                setState(() {
                  selectedFilter = filters[index];
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

  Widget _buildDriverRideCard(BuildContext context, int index) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final rideCardPadding =
        isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final rideNumberSize =
        isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 14.0);
    final rideTimeSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 12.0);
    final rideLocationSize =
        isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 14.0);
    final rideDetailsSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 13.0);
    final rideAmountSize =
        isSmallScreen ? 15.0 : (isMediumScreen ? 16.0 : 16.0);
    final vehicleIconSize =
        isSmallScreen ? 40.0 : (isMediumScreen ? 48.0 : 48.0);
    final statusPadding = isSmallScreen ? 6.0 : (isMediumScreen ? 8.0 : 8.0);
    final statusFontSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 13.0);
    final locationIconSize =
        isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 18.0);
    final timeIconSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final starIconSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 18.0);

    final List<Map<String, String>> rideData = [
      {
        'rideNumber': '1',
        'time': '2:30 PM',
        'pickup': 'Gulshan e Iqbal, Block 13-D',
        'destination': 'Tariq Road, PECHS',
        'duration': '25 mins',
        'rating': '4.8',
        'amount': 'Rs. 650',
      },
      {
        'rideNumber': '2',
        'time': '4:15 PM',
        'pickup': 'Tariq Road, PECHS',
        'destination': 'Gulshan e Iqbal, Block 13-D',
        'duration': '18 mins',
        'rating': '4.9',
        'amount': 'Rs. 555',
      },
    ];

    final data = rideData[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      shadowColor: Colors.grey[300],
      child: Padding(
        padding: EdgeInsets.all(rideCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(rideCardPadding / 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF323D4F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/sedan.png',
                        width: vehicleIconSize,
                        height: vehicleIconSize,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride #${data['rideNumber']}',
                          style: GoogleFonts.poppins(
                            fontSize: rideNumberSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          data['time']!,
                          style: GoogleFonts.poppins(
                            fontSize: rideTimeSize,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: statusPadding, vertical: statusPadding / 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Completed',
                    style: GoogleFonts.poppins(
                      fontSize: statusFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data['pickup']!,
                      style: GoogleFonts.poppins(
                        fontSize: rideLocationSize,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on,
                    color: Colors.red, size: locationIconSize),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data['destination']!,
                    style: GoogleFonts.poppins(
                      fontSize: rideLocationSize,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(Icons.access_time,
                          size: timeIconSize, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data['duration']!,
                      style: GoogleFonts.poppins(
                        fontSize: rideDetailsSize,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.star,
                        size: starIconSize, color: AppTheme.goldAccent),
                    const SizedBox(width: 4),
                    Text(
                      data['rating']!,
                      style: GoogleFonts.poppins(
                        fontSize: rideDetailsSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  data['amount']!,
                  style: GoogleFonts.poppins(
                    fontSize: rideAmountSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF323D4F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
