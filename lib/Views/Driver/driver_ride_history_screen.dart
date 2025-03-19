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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        title: Text(
          'Ride History',
          style: GoogleFonts.poppins(
            fontSize: CustomSize().customWidth(context) / 20,
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
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
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
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Today\'s Rides', '2', 'assets/images/sedan.png'),
              _buildStatItem('Today\'s Earnings', 'Rs. 1,205', 'pkr'),
              _buildStatItem('Rating', '4.78', Icons.star, AppTheme.goldAccent),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up, color: Colors.green[300], size: 20),
                const SizedBox(width: 8),
                Text(
                  '15% more than yesterday',
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

  Widget _buildStatItem(String label, String value, dynamic icon,
      [Color? iconColor]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          child: Center(
            child: icon is IconData
                ? Icon(icon, color: iconColor ?? Colors.white, size: 32)
                : icon is String && icon.contains('pkr')
                    ? Text(
                        'PKR',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    : Image.asset(
                        icon,
                        width: 60,
                        height: 60,
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

  Widget _buildFilterSection(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filters[index],
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.028,
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
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF323D4F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/sedan.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride #${data['rideNumber']}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          data['time']!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Completed',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
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
                        fontSize: 13,
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
                const Icon(Icons.location_on, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data['destination']!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
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
                          size: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data['duration']!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.star, size: 18, color: AppTheme.goldAccent),
                    const SizedBox(width: 4),
                    Text(
                      data['rating']!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  data['amount']!,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
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
