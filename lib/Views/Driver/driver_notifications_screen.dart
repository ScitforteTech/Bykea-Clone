import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';

class DriverNotificationsScreen extends StatefulWidget {
  const DriverNotificationsScreen({super.key});

  @override
  State<DriverNotificationsScreen> createState() =>
      _DriverNotificationsScreenState();
}

class _DriverNotificationsScreenState extends State<DriverNotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasUnreadNotifications = true;

  // Sample notification data
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'type': 'trip',
      'title': 'New Trip Request',
      'message':
          'You have received a new trip request from Gulshan-e-Iqbal to DHA Phase 6',
      'time': '2 minutes ago',
      'isRead': false,
    },
    {
      'type': 'rating',
      'title': 'Rating Received',
      'message': 'You received a 5-star rating from your last passenger',
      'time': '1 hour ago',
      'isRead': true,
    },
    {
      'type': 'payment',
      'title': 'Payment Received',
      'message': 'Rs. 450 has been credited to your wallet for your last trip',
      'time': '2 hours ago',
      'isRead': true,
    },
    {
      'type': 'system',
      'title': 'System Update',
      'message':
          'New features and improvements are available in the latest update',
      'time': '1 day ago',
      'isRead': false,
    },
  ];

  List<Map<String, dynamic>> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _filteredNotifications = _allNotifications;
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _filteredNotifications = _allNotifications;
            break;
          case 1:
            _filteredNotifications = _allNotifications
                .where((notification) => notification['type'] == 'trip')
                .toList();
            break;
          case 2:
            _filteredNotifications = _allNotifications
                .where((notification) => notification['type'] == 'rating')
                .toList();
            break;
          case 3:
            _filteredNotifications = _allNotifications
                .where((notification) => notification['type'] == 'system')
                .toList();
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    // Calculate responsive dimensions
    final sectionPadding = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final fieldSpacing = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final titleFontSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);
    final subtitleFontSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 14.0);
    final bodyFontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 16.0);
    final smallTextSize = isSmallScreen ? 10.0 : (isMediumScreen ? 11.0 : 12.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);
    final cardRadius = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final emptyStateIconSize =
        isSmallScreen ? 60.0 : (isMediumScreen ? 80.0 : 100.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF323d4f),
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: titleFontSize,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: iconSize),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: subtitleFontSize,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: subtitleFontSize,
          ),
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Trips"),
            Tab(text: "Ratings"),
            Tab(text: "System"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, size: iconSize),
            onPressed: () {
              _showClearNotificationsDialog(titleFontSize, bodyFontSize);
            },
          ),
        ],
      ),
      body: _filteredNotifications.isEmpty
          ? _buildEmptyState(
              emptyStateIconSize, titleFontSize, subtitleFontSize, fieldSpacing)
          : ListView.builder(
              padding: EdgeInsets.all(sectionPadding),
              itemCount: _filteredNotifications.length,
              itemBuilder: (context, index) {
                final notification = _filteredNotifications[index];
                return _buildNotificationCard(
                  notification,
                  cardRadius,
                  fieldSpacing,
                  iconSize,
                  bodyFontSize,
                  subtitleFontSize,
                  smallTextSize,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(
      double iconSize, double titleSize, double subtitleSize, double spacing) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: iconSize,
            color: Colors.grey[400],
          ),
          SizedBox(height: spacing),
          Text(
            "No notifications yet",
            style: GoogleFonts.poppins(
              fontSize: titleSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: spacing / 2),
          Text(
            "You'll see your notifications here",
            style: GoogleFonts.poppins(
              fontSize: subtitleSize,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> notification,
    double radius,
    double spacing,
    double iconSize,
    double titleSize,
    double messageSize,
    double timeSize,
  ) {
    IconData iconData;
    Color iconColor;

    switch (notification['type']) {
      case 'trip':
        iconData = Icons.local_taxi;
        iconColor = Colors.blue;
        break;
      case 'rating':
        iconData = Icons.star;
        iconColor = const Color(0xFFD4AF37);
        break;
      case 'payment':
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.info_outline;
        iconColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: spacing / 2),
      elevation: notification['isRead'] ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: notification['isRead']
            ? BorderSide.none
            : const BorderSide(color: Color(0xFFD4AF37), width: 1),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            notification['isRead'] = true;
          });
          _showNotificationDetails(notification, titleSize, messageSize);
        },
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.625),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['title'],
                      style: GoogleFonts.poppins(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacing / 4),
                    Text(
                      notification['message'],
                      style: GoogleFonts.poppins(
                        fontSize: messageSize,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: spacing / 2),
                    Text(
                      notification['time'],
                      style: GoogleFonts.poppins(
                        fontSize: timeSize,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification['isRead'])
                Container(
                  width: spacing * 0.5,
                  height: spacing * 0.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF323d4f),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDetails(
      Map<String, dynamic> notification, double titleSize, double messageSize) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          notification['title'],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: titleSize,
          ),
        ),
        content: Text(
          notification['message'],
          style: GoogleFonts.poppins(
            fontSize: messageSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: const Color(0xFF323d4f),
                fontSize: messageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearNotificationsDialog(double titleSize, double messageSize) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: titleSize,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all notifications?',
          style: GoogleFonts.poppins(
            fontSize: messageSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: messageSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _filteredNotifications.clear();
              });
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: messageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
