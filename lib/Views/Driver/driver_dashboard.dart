import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
      // Simulate ride request after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (isOnline && mounted) {
          setState(() {
            showRideRequest = true;
          });
        }
      });
    }
  }

  Widget _buildRideRequestCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_pin_circle,
                  color: AppTheme.primaryBlue,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Ride Request',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '2.5 km away',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF323d4f).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF323d4f).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PKR ',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                    Text(
                      '350',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, color: Colors.green, size: 16),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Gulshan-e-Iqbal, Block 13-D',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tariq Road, PECHS',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showRideRequest = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Decline',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showRideRequest = false;
                      // Add navigation logic here
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                color: const Color(0xFF323d4f),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fahim',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              // Add navigation to edit profile
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Edit Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.edit,
                                  color: Colors.white70,
                                  size: 12,
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
                  // Add navigation logic
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
                  // Add navigation logic
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
                  // Add navigation logic
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
                  // Add navigation logic
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
                  // Add navigation logic
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
                  // Add navigation logic
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
                  // Add navigation logic
                },
              ),
              const Divider(),
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
                  // Add navigation logic
                },
              ),
              const Divider(),
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
                  // Add logout logic
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
      body: Stack(
        children: [
          // Google Map as background
          GoogleMap(
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

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Status Bar
                Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.menu,
                            color: AppTheme.primaryBlue,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: _showImageSourceSheet,
                        child: _buildProfileImage(size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Fahim',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        isOnline ? Colors.green : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  isOnline ? 'Online' : 'Offline',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
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

                // Stats Grid
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Today\'s Earnings',
                        'PKR. 1205',
                        Icons.monetization_on_rounded,
                        AppTheme.goldAccent,
                        imagePath: 'assets/images/pkr.png',
                      ),
                      const SizedBox(width: 12),
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
              ],
            ),
          ),

          // Bottom Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white,
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Message
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isOnline
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isOnline
                            ? Colors.green.withOpacity(0.3)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isOnline ? Icons.check_circle : Icons.info_outline,
                          color: isOnline ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isOnline
                                ? 'You\'re online! Waiting for ride requests...'
                                : 'Go online to start receiving ride requests',
                            style: GoogleFonts.poppins(
                              color: isOnline ? Colors.green : Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Quick Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(
                          'Earnings',
                          Icons.account_balance_wallet_rounded,
                          AppTheme.goldAccent,
                          () {},
                        ),
                        _buildQuickAction(
                          'History',
                          Icons.history_rounded,
                          AppTheme.primaryBlue,
                          () {},
                        ),
                        _buildQuickAction(
                          'Support',
                          Icons.help_outline,
                          Colors.green,
                          () {},
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
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
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color,
      {String? imagePath}) {
    return Expanded(
      child: Container(
        height: 190,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
              width: label == 'Today\'s Earnings' ? 85 : 65,
              height: 65,
              padding: const EdgeInsets.all(4),
              child: label == 'Today\'s Earnings'
                  ? Center(
                      child: Text(
                        'PKR',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    )
                  : imagePath != null
                      ? Image.asset(
                          imagePath,
                          width: 65,
                          height: 65,
                        )
                      : Icon(icon, color: color, size: 50),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
