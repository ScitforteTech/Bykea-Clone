import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vroom_ride_app/Views/Rider/earnings.dart';
import 'package:vroom_ride_app/Views/Rider/edit_profile_page.dart';
import 'package:vroom_ride_app/Views/Rider/faqs_page.dart';
import 'package:vroom_ride_app/Views/Rider/refer_page.dart';
import 'package:vroom_ride_app/Views/Rider/ride_history.dart';
import 'package:vroom_ride_app/Views/Rider/support_page.dart';
import 'package:vroom_ride_app/Views/Rider/privacy_policy.dart';
import 'package:vroom_ride_app/Views/Rider/ride_requests.dart';
import 'package:vroom_ride_app/Views/Rider/wallet.dart';
import 'package:vroom_ride_app/Views/Rider/notification_page.dart';
import 'package:vroom_ride_app/Views/Rider/auth_choice_screen.dart';

class RiderDashboard extends StatefulWidget {
  const RiderDashboard({super.key});

  @override
  State<RiderDashboard> createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(24.8607, 67.0011); // Karachi coordinates
  String selectedVehicle = 'Moto';

  final Map<String, Map<String, dynamic>> vehicleTypes = {
    'Moto': {
      'image': 'assets/images/bike.png',
      'seats': 1,
      'color': Colors.blue.shade100,
    },
    'Ride Mini': {
      'image': 'assets/images/alto.png',
      'seats': 4,
      'color': Colors.white,
    },
    'Ride A/C': {
      'image': 'assets/images/sedan.png',
      'seats': 4,
      'color': Colors.white,
    },
    'Auto': {
      'image': 'assets/images/rickshaw.png',
      'seats': 3,
      'color': Colors.green.shade100,
    },
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

    // Calculate bottom sheet height based on screen size
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomSheetHeight =
        (screenHeight * 0.5).clamp(200.0, screenHeight - 100.0) +
            keyboardHeight;

    //Calculate map height
    final mapHeight = screenHeight -
        bottomSheetHeight -
        (MediaQuery.of(context).padding.top +
            2 * sectionPadding +
            2 * fieldSpacing +
            2 * profileImageSize);

    //Drawer width
    final drawerWidth = (screenWidth * 0.8).clamp(280.0, 350.0);

    return Scaffold(
      body: Stack(
        children: [
          // Google Map as background
          SizedBox(
            height: mapHeight,
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
                        onTap: () => Scaffold.of(context).openDrawer(),
                        borderRadius: BorderRadius.circular(30),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: profileImageSize,
                          child: Icon(Icons.menu,
                              color: Colors.black, size: iconSize),
                        ),
                      ),
                      SizedBox(width: fieldSpacing),
                      CircleAvatar(
                        radius: profileImageSize,
                        backgroundImage:
                            const AssetImage('assets/images/profile_pic.jpeg'),
                      ),
                      SizedBox(width: fieldSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Abdullah',
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '+92 300 1234567',
                              style: GoogleFonts.poppins(
                                fontSize: subtitleFontSize,
                                color: Colors.grey[600],
                              ),
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

          // Bottom sheet for ride booking
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: bottomSheetHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(fieldSpacing * 2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: EdgeInsets.symmetric(vertical: fieldSpacing),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: sectionPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Vehicle type selection
                            Text(
                              'Select Vehicle Type',
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF323d4f),
                              ),
                            ),
                            SizedBox(height: fieldSpacing),
                            SizedBox(
                              height: screenHeight * 0.15,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                children: vehicleTypes.entries.map((entry) {
                                  final type = entry.key;
                                  final data = entry.value;
                                  final isSelected = selectedVehicle == type;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedVehicle = type;
                                      });
                                    },
                                    child: Container(
                                      width: screenWidth * 0.22,
                                      margin:
                                          EdgeInsets.only(right: fieldSpacing),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF323d4f)
                                                .withOpacity(0.1)
                                            : Colors.grey[100],
                                        borderRadius: BorderRadius.circular(16),
                                        border: isSelected
                                            ? Border.all(
                                                color: const Color(0xFF323d4f),
                                                width: 2)
                                            : null,
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: const Color(0xFF323d4f)
                                                      .withOpacity(0.2),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                )
                                              ]
                                            : null,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            data['image'] as String,
                                            height: screenWidth * 0.12,
                                            width: screenWidth * 0.12,
                                          ),
                                          SizedBox(height: fieldSpacing / 4),
                                          Text(
                                            type,
                                            style: GoogleFonts.poppins(
                                              fontSize: subtitleFontSize,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isSelected
                                                  ? const Color(0xFF323d4f)
                                                  : Colors.grey[700],
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: iconSize * 0.7,
                                                color: Colors.grey[700],
                                              ),
                                              SizedBox(width: fieldSpacing / 4),
                                              Text(
                                                '${data['seats']}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: subtitleFontSize,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: fieldSpacing),

                            // Location inputs
                            _buildLocationInput(
                              'Pickup Location',
                              Icons.circle,
                              Colors.green,
                              'Enter pickup location',
                              sectionPadding,
                              fieldSpacing,
                              subtitleFontSize,
                              iconSize,
                            ),
                            SizedBox(height: fieldSpacing),
                            _buildLocationInput(
                              'Drop-off Location',
                              Icons.location_on,
                              Colors.red,
                              'Enter drop-off location',
                              sectionPadding,
                              fieldSpacing,
                              subtitleFontSize,
                              iconSize,
                            ),
                            SizedBox(height: fieldSpacing),

                            // Fare input
                            Text(
                              'Your Fare Offer',
                              style: GoogleFonts.poppins(
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF323d4f),
                              ),
                            ),
                            SizedBox(height: fieldSpacing / 2),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: sectionPadding),
                              child: Row(
                                children: [
                                  Text(
                                    'PKR',
                                    style: GoogleFonts.poppins(
                                      fontSize: subtitleFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: fieldSpacing / 2),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Enter your fare',
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: subtitleFontSize,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                      size: iconSize * 0.8,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(sectionPadding),
                    child: SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF323d4f),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monetization_on, size: iconSize * 0.8),
                            SizedBox(width: fieldSpacing / 2),
                            Text(
                              'Find a driver',
                              style: GoogleFonts.poppins(
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: fieldSpacing / 2),
                            Icon(Icons.tune, size: iconSize * 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: drawerWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  sectionPadding,
                  MediaQuery.of(context).padding.top + sectionPadding,
                  sectionPadding,
                  sectionPadding,
                ),
                color: const Color(0xFF323d4f),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: isSmallScreen ? 25 : (isMediumScreen ? 30 : 35),
                      backgroundImage: const AssetImage(
                        'assets/images/profile_pic.jpeg',
                      ),
                    ),
                    SizedBox(width: fieldSpacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Abdullah',
                            style: GoogleFonts.poppins(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '+92 300 1234567',
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: const Color(0xFFD4AF37),
                  size: iconSize,
                ),
                title: Text(
                  'Edit Profile',
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.local_taxi, color: Color(0xFFD4AF37)),
                title: Text(
                  'My Trip Requests',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RideRequestsPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.history, color: Color(0xFFD4AF37)),
                title: Text(
                  'My Rides',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RideHistoryPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFFD4AF37)),
                title: Text(
                  'Refer',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to refer page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReferPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet,
                    color: Color(0xFFD4AF37)),
                title: Text(
                  'Wallet',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WalletPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.notifications, color: Color(0xFFD4AF37)),
                title: Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to notifications page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help, color: Color(0xFFD4AF37)),
                title: Text(
                  'FAQs',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to FAQs page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQsPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.privacy_tip, color: Color(0xFFD4AF37)),
                title: Text(
                  'Privacy Policy',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to privacy policy page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage()),
                  );
                },
              ),
              const Divider(),
              // Help & Support Item
              ListTile(
                leading:
                    const Icon(Icons.help_outline, color: Color(0xFFD4AF37)),
                title: Text(
                  'Help & Support',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to support page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportPage()),
                  );
                },
              ),
              const Divider(),
              // Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Logout and navigate to auth choice screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthChoiceScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const Divider(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInput(
    String label,
    IconData icon,
    Color iconColor,
    String hintText,
    double sectionPadding,
    double fieldSpacing,
    double subtitleFontSize,
    double iconSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: subtitleFontSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF323d4f),
          ),
        ),
        SizedBox(height: fieldSpacing / 2),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              SizedBox(width: sectionPadding),
              Icon(
                icon,
                color: iconColor,
                size: iconSize * 0.8,
              ),
              SizedBox(width: fieldSpacing / 2),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
