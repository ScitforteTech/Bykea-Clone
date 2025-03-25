import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'driver_ride_history_screen.dart';
import 'driver_earnings_screen.dart';
import 'driver_wallet_screen.dart';
import 'driver_trip_requests_screen.dart';
import 'driver_notifications_screen.dart';
import 'driver_faq_screen.dart';
import 'driver_privacy_policy_screen.dart';
import 'driver_refer_screen.dart';
import 'driver_support_screen.dart';
import 'package:vroom_ride_app/Views/Driver/driver_edit_profile_screen.dart';
import 'package:vroom_ride_app/Views/auth_screen/login_screen.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(24.8607, 67.0011); // Karachi coordinates
  bool isOnline = false;
  bool isNavigating = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _profileImage;
  bool showRideRequest = false;
  List<Map<String, dynamic>> rideRequests = [];
  Map<String, dynamic>? currentRideRequest;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image == null) return;

      setState(() {
        _profileImage = File(image.path);
      });
      Navigator.pop(context); // Close bottom sheet
    } catch (e) {
      // Handle error
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(
                'Take a photo',
                style: GoogleFonts.poppins(),
              ),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(
                'Choose from gallery',
                style: GoogleFonts.poppins(),
              ),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            if (_profileImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Remove photo',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
                onTap: () {
                  setState(() {
                    _profileImage = null;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage({double size = 24, bool showEditButton = false}) {
    return Stack(
      children: [
        Container(
          width: size * 2,
          height: size * 2,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            shape: BoxShape.circle,
            image: _profileImage != null
                ? DecorationImage(
                    image: FileImage(_profileImage!),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage('assets/images/default_profile.png'),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _showImageSourceSheet,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handleOnlineToggle(bool value) {
    setState(() {
      isOnline = value;
      showRideRequest = false;
    });

    if (value) {
      // Simulate ride requests after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (isOnline && mounted) {
          setState(() {
            // Generate sample ride requests
            rideRequests = List.generate(
              3,
              (index) => {
                "id": "request_$index",
                "distance": "${(index + 2.0).toStringAsFixed(1)} km",
                "fare": (index + 3) * 100,
                "passengerName": "Passenger ${index + 1}",
                "pickup": "Location ${index + 1}",
                "dropoff": "Destination ${index + 1}",
                "rating": (3.5 + index * 0.5),
              },
            );

            if (rideRequests.isNotEmpty) {
              currentRideRequest = rideRequests[0];
              showRideRequest = true;
            }
          });

          // Show notification for new ride request
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New ride request received!'),
              backgroundColor: AppTheme.primaryBlue,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    } else {
      // Clear any pending requests when going offline
      setState(() {
        rideRequests.clear();
        currentRideRequest = null;
      });
    }
  }

  void _acceptRideRequest() {
    // Store the accepted request for later use
    final acceptedRequest = currentRideRequest;

    setState(() {
      // Accept current request and clear all others
      showRideRequest = false;
      rideRequests.clear();

      // Here you would typically navigate to ride details or start trip screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ride accepted! Navigating to pickup...'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'VIEW',
            textColor: Colors.white,
            onPressed: () {
              // Here you would show the accepted ride details
              // or navigate to start trip screen
              if (acceptedRequest != null) {
                _showAcceptedRideDetails(acceptedRequest);
              }
            },
          ),
        ),
      );
    });
  }

  void _showAcceptedRideDetails(Map<String, dynamic> request) {
    // Show dialog with ride details
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Accepted Ride Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Passenger: ${request['passengerName']}'),
            SizedBox(height: 8),
            Text('Pickup: ${request['pickup']}'),
            SizedBox(height: 8),
            Text('Dropoff: ${request['dropoff']}'),
            SizedBox(height: 8),
            Text('Fare: PKR ${request['fare']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _rejectRideRequest() {
    setState(() {
      // Remove current request from the list
      if (currentRideRequest != null) {
        rideRequests.removeWhere(
            (request) => request["id"] == currentRideRequest!["id"]);
      }

      // Show next request if available
      if (rideRequests.isNotEmpty) {
        currentRideRequest = rideRequests[0];
        showRideRequest = true;

        // Show notification for the next request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Showing next request'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        currentRideRequest = null;
        showRideRequest = false;

        // Show notification that there are no more requests
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No more ride requests available'),
            backgroundColor: Colors.grey,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

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
    final iconSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 24.0);
    final buttonHeight = isSmallScreen ? 40.0 : (isMediumScreen ? 45.0 : 50.0);
    final profileImageSize =
        isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);
    final mapHeight = isSmallScreen
        ? screenHeight * 0.6
        : (isMediumScreen ? screenHeight * 0.65 : screenHeight * 0.7);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    sectionPadding, 40, sectionPadding, sectionPadding),
                color: const Color(0xFF323d4f),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: profileImageSize,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                    SizedBox(width: fieldSpacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fahim',
                            style: GoogleFonts.poppins(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DriverEditProfileScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Edit Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(width: fieldSpacing / 2),
                                Icon(
                                  Icons.edit,
                                  color: Colors.white70,
                                  size: iconSize,
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
              ListTile(
                leading: Icon(Icons.local_taxi,
                    color: const Color(0xFFD4AF37), size: iconSize),
                title: Text(
                  'My Trip Requests',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                    fontSize: subtitleFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverTripRequestsScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.history,
                    color: const Color(0xFFD4AF37), size: iconSize),
                title: Text(
                  'My Rides',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                    fontSize: subtitleFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverRideHistoryScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.person_add,
                    color: const Color(0xFFD4AF37), size: iconSize),
                title: Text(
                  'Refer',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                    fontSize: subtitleFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverReferScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.account_balance_wallet,
                    color: const Color(0xFFD4AF37), size: iconSize),
                title: Text(
                  'Wallet',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                    fontSize: subtitleFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverWalletScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.notifications,
                    color: AppTheme.goldAccent, size: iconSize),
                title: Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverNotificationsScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.help,
                    color: AppTheme.goldAccent, size: iconSize),
                title: Text(
                  'FAQs',
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverFAQScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.privacy_tip,
                    color: const Color(0xFFD4AF37), size: iconSize),
                title: Text(
                  'Privacy Policy',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                    fontSize: subtitleFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverPrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.help_outline,
                    color: const Color(0xFFD4AF37), size: iconSize),
                title: Text(
                  'Help & Support',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                    fontSize: subtitleFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverSupportScreen(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red, size: iconSize),
                title: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                    fontSize: subtitleFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to login screen and remove all previous routes
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const loginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text(
                              'Logout',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              SizedBox(height: fieldSpacing),
              Padding(
                padding: EdgeInsets.all(sectionPadding),
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: subtitleFontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Google Map as background
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
            ),
          ),

          // Top Content
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Status Bar
                Container(
                  margin: EdgeInsets.all(sectionPadding),
                  padding: EdgeInsets.symmetric(
                      horizontal: sectionPadding, vertical: fieldSpacing),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(fieldSpacing),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        borderRadius: BorderRadius.circular(30),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: profileImageSize,
                          child: Builder(
                            builder: (context) => IconButton(
                              icon: Icon(Icons.menu,
                                  color: Colors.black, size: iconSize),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: fieldSpacing),
                      InkWell(
                        onTap: _showImageSourceSheet,
                        child: _buildProfileImage(size: profileImageSize),
                      ),
                      SizedBox(width: fieldSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Fahim',
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        isOnline ? Colors.green : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  isOnline ? 'Online' : 'Offline',
                                  style: GoogleFonts.poppins(
                                    fontSize: subtitleFontSize,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: isOnline,
                        onChanged: _handleOnlineToggle,
                        activeColor: AppTheme.goldAccent,
                        activeTrackColor: AppTheme.goldAccent.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats Grid - Positioned below top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 120,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sectionPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    'Today\'s Earnings',
                    'Rs. 1205',
                    Icons.monetization_on_rounded,
                    AppTheme.goldAccent,
                    imagePath: 'assets/images/pkr.png',
                  ),
                  SizedBox(width: fieldSpacing),
                  _buildStatCard(
                    'Completed Rides',
                    '4',
                    Icons.directions_car_rounded,
                    Colors.green,
                    imagePath: 'assets/images/sedan.png',
                  ),
                ],
              ),
            ),
          ),

          // Bottom Panel
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: sectionPadding,
            right: sectionPadding,
            child: SafeArea(
              bottom: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Message
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: fieldSpacing, horizontal: sectionPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(fieldSpacing),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isOnline ? Icons.check_circle : Icons.info_outline,
                          color: isOnline ? Colors.green : Colors.grey,
                          size: iconSize,
                        ),
                        SizedBox(width: fieldSpacing),
                        Expanded(
                          child: Text(
                            isOnline
                                ? 'You\'re online! Waiting for ride requests...'
                                : 'Go online to start receiving ride requests',
                            style: GoogleFonts.poppins(
                              color: isOnline ? Colors.green : Colors.grey[600],
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: fieldSpacing),

                  // Quick Actions
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: fieldSpacing, horizontal: sectionPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(fieldSpacing),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildQuickAction(
                            'Earnings',
                            Icons.account_balance_wallet_rounded,
                            AppTheme.goldAccent,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DriverEarningsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                            width: fieldSpacing *
                                2), // Increase spacing between actions
                        Expanded(
                          child: _buildQuickAction(
                            'History',
                            Icons.history_rounded,
                            AppTheme.primaryBlue,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DriverRideHistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ride Request Overlay
          if (showRideRequest)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(fieldSpacing),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildRideRequestCard(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color,
      {String? imagePath}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    // Adjust card dimensions to prevent overflow
    final cardWidth = (screenWidth -
            (isSmallScreen ? 48.0 : (isMediumScreen ? 64.0 : 80.0))) /
        2;
    final cardHeight = isSmallScreen
        ? 120.0
        : (isMediumScreen ? 140.0 : 160.0); // Reduced height
    final iconSize = isSmallScreen
        ? 40.0
        : (isMediumScreen ? 45.0 : 50.0); // Reduced icon size
    final titleFontSize = isSmallScreen
        ? 12.0
        : (isMediumScreen ? 14.0 : 16.0); // Reduced font size
    final valueFontSize = isSmallScreen
        ? 20.0
        : (isMediumScreen ? 22.0 : 24.0); // Reduced font size
    final sectionPadding =
        isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0); // Reduced padding
    final fieldSpacing =
        isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0); // Reduced spacing

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.symmetric(
          horizontal: fieldSpacing, vertical: sectionPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(fieldSpacing),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: label == 'Today\'s Earnings' ? iconSize * 1.3 : iconSize,
            height: iconSize,
            padding: const EdgeInsets.all(4),
            child: label == 'Today\'s Earnings'
                ? Center(
                    child: Text(
                      'PKR',
                      style: GoogleFonts.poppins(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  )
                : imagePath != null
                    ? Image.asset(
                        imagePath,
                        width: iconSize,
                        height: iconSize,
                      )
                    : Icon(icon, color: color, size: iconSize),
          ),
          SizedBox(height: fieldSpacing / 2), // Reduced spacing
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: fieldSpacing / 2),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
                color: color,
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(height: fieldSpacing / 4), // Reduced spacing
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: fieldSpacing / 2),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: -0.5,
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
      String label, IconData icon, Color color, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 22.0 : 24.0);
    final fontSize = isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0);
    final padding = isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0);
    final fieldSpacing = isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(fieldSpacing),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(fieldSpacing),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: iconSize),
            SizedBox(width: fieldSpacing),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideRequestCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    final sectionPadding =
        isSmallScreen ? 10.0 : (isMediumScreen ? 12.0 : 16.0);
    final fieldSpacing = isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0);
    final titleFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final subtitleFontSize =
        isSmallScreen ? 10.0 : (isMediumScreen ? 12.0 : 14.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);
    final buttonHeight = isSmallScreen ? 36.0 : (isMediumScreen ? 40.0 : 45.0);

    // Check if we have a current request to display
    if (currentRideRequest == null) {
      return const SizedBox.shrink();
    }

    final rating = currentRideRequest!["rating"] ?? 4.5;
    final ratingStars = List.generate(
      5,
      (index) => Icon(
        index < rating.floor()
            ? Icons.star
            : (index < rating && index >= rating.floor())
                ? Icons.star_half
                : Icons.star_border,
        color: Colors.amber,
        size: iconSize * 0.4,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: sectionPadding, vertical: fieldSpacing),
      padding: EdgeInsets.all(fieldSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(fieldSpacing),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(fieldSpacing / 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(fieldSpacing / 2),
            ),
            child: Center(
              child: Text(
                'Ride Request (${rideRequests.length} available)',
                style: GoogleFonts.poppins(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),

          SizedBox(height: fieldSpacing),

          // Passenger info and fare
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(fieldSpacing / 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_pin_circle,
                  color: AppTheme.primaryBlue,
                  size: iconSize,
                ),
              ),
              SizedBox(width: fieldSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Passenger name
                    Text(
                      currentRideRequest!["passengerName"] ?? "Passenger",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Distance and rating
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            currentRideRequest!["distance"] ?? '2.5 km away',
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: fieldSpacing / 2),
                        Row(children: ratingStars),
                      ],
                    ),
                  ],
                ),
              ),
              // Fare amount
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: fieldSpacing, vertical: fieldSpacing / 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF323d4f).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(buttonHeight / 2),
                  border: Border.all(
                    color: const Color(0xFF323d4f).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'PKR',
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize * 0.8,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                    Text(
                      '${currentRideRequest!["fare"] ?? 350}',
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: fieldSpacing),

          // Ride details
          Container(
            padding: EdgeInsets.all(fieldSpacing),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(fieldSpacing / 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pickup location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.my_location,
                          color: Colors.green, size: iconSize * 0.6),
                    ),
                    SizedBox(width: fieldSpacing / 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pickup",
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize * 0.8,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentRideRequest!["pickup"] ?? "Pickup Location",
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: fieldSpacing / 2),
                Divider(height: 1, color: Colors.grey[300]),
                SizedBox(height: fieldSpacing / 2),

                // Dropoff location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.location_on,
                          color: Colors.red, size: iconSize * 0.6),
                    ),
                    SizedBox(width: fieldSpacing / 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dropoff",
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize * 0.8,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentRideRequest!["dropoff"] ??
                                "Dropoff Location",
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: fieldSpacing),

          Text(
            "Request expires in 25 seconds",
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize * 0.9,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: fieldSpacing),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _rejectRideRequest,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonHeight / 2),
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(fieldSpacing),
                    ),
                  ),
                  child: Text(
                    'Decline',
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: fieldSpacing),
              Expanded(
                child: TextButton(
                  onPressed: _acceptRideRequest,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonHeight / 2),
                    backgroundColor: AppTheme.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(fieldSpacing),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
