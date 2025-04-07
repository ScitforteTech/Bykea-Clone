import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:vroom_ride_app/Models/ride_status.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard>
    with WidgetsBindingObserver {
  late MapController mapController;
  final LatLng _center = LatLng(24.8607, 67.0011); // Karachi coordinates
  List<LatLng> _routePoints = [];
  Polyline? _routePolyline;
  final String openRouteServiceApiKey =
      '5b3ce3597851110001cf62482968ef0f13f34071899c36bb7b30c69a'; // Replace with your API key
  bool isOnline = false;
  bool isNavigating = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _profileImage;
  bool showRideRequest = false;
  List<Map<String, dynamic>> rideRequests = [];
  Map<String, dynamic>? currentRideRequest;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  double _maxRequestRadius = 5000; // 5km radius for ride requests

  // Add Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add user data variables
  String _driverName = '';
  String _profileImageUrl = '';
  Map<String, dynamic>? _driverData;

  // Add these variables to the state
  Marker? pickupMarker;
  Marker? dropoffMarker;
  bool isNavigatingToPickup = false;

  // Add these variables
  bool isRideAccepted = false;
  String estimatedTime = '0 min';
  String estimatedDistance = '0 km';
  double bottomSheetHeight = 0.4;

  // Add these variables
  RideStatus rideStatus = RideStatus.initial;
  bool showNavigationInstructions = false;
  String currentInstruction = "";
  List<String> navigationSteps = [];
  String passengerPhone = "+923001234567"; // Example number

  bool _locationPermissionGranted = false;
  bool _locationInitialized = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    WidgetsBinding.instance.addObserver(this);
    _loadDriverData();
    // Initialize location after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocationServices();
    });
  }

  Future<void> _initializeLocationServices() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show dialog to enable location services
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Location Services Disabled'),
                content:
                    Text('Please enable location services to use this app.'),
                actions: [
                  TextButton(
                    child: Text('Open Settings'),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Geolocator.openLocationSettings();
                      // Check location service status after settings are opened
                      bool enabled =
                          await Geolocator.isLocationServiceEnabled();
                      if (enabled) {
                        _initializeLocationServices();
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location permissions are required')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Location Permissions Required'),
                content: Text(
                    'Location permissions are permanently denied. Please enable them in your settings.'),
                actions: [
                  TextButton(
                    child: Text('Open Settings'),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Geolocator.openAppSettings();
                      // Check permission status after settings are opened
                      LocationPermission newPermission =
                          await Geolocator.checkPermission();
                      if (newPermission != LocationPermission.deniedForever) {
                        _initializeLocationServices();
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
        return;
      }

      // Only proceed if we have the required permissions
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // Get current position with timeout
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ).catchError((error) async {
          // If timeout occurs, try with lower accuracy
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
          );
        });

        if (mounted) {
          setState(() {
            _currentPosition = position;
            _locationPermissionGranted = true;
            _locationInitialized = true;
          });

          // Center map to driver's location
          mapController.move(
            LatLng(position.latitude, position.longitude),
            15.0,
          );

          // Start location updates stream
          _startLocationUpdates();
        }
      }
    } catch (e) {
      print('Error initializing location services: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing location services')),
        );
      }
    }
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      (Position position) {
        setState(() {
          _currentPosition = position;
        });
        _updateDriverLocation(position);
      },
      onError: (error) {
        print('Location stream error: $error');
        // Try to restart location updates if there's an error
        Future.delayed(Duration(seconds: 5), _startLocationUpdates);
      },
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadDriverData();
      // Re-check location permissions when app resumes
      _initializeLocationServices();
    }
  }

  void _showAcceptedRideDetails(Map<String, dynamic> acceptedRequest) {
    // Implement the logic to display accepted ride details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ride Details'),
          content: Text(
              'Details for the accepted ride: ${acceptedRequest.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadDriverData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final driverDoc =
            await _firestore.collection('drivers').doc(user.uid).get();

        if (driverDoc.exists) {
          setState(() {
            _driverData = driverDoc.data();
            _driverName = _driverData?['personalInfo']['name'] ?? 'Driver';
            _profileImageUrl =
                _driverData?['personalInfo']['profileImage'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading driver data: $e');
    }
  }

  Future<void> getRoute(LatLng start, LatLng end) async {
    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': openRouteServiceApiKey,
        },
        body: json.encode({
          'coordinates': [
            [start.longitude, start.latitude],
            [end.longitude, end.latitude],
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> coordinates =
            data['features'][0]['geometry']['coordinates'];

        setState(() {
          _routePoints =
              coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
        });
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end) async {
    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': openRouteServiceApiKey,
        },
        body: json.encode({
          'coordinates': [
            [start.longitude, start.latitude],
            [end.longitude, end.latitude],
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> coordinates =
            data['features'][0]['geometry']['coordinates'];
        return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      }
      return [];
    } catch (e) {
      print('Error getting route: $e');
      return [];
    }
  }

  void _onMapCreated(MapController controller) {
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
            image: _profileImageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(_profileImageUrl),
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

  Future<void> _updateDriverLocation(Position position) async {
    if (!isOnline) return;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('drivers').doc(user.uid).update({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'heading': position.heading,
            'timestamp': FieldValue.serverTimestamp(),
          }
        });
      }
    } catch (e) {
      print('Error updating driver location: $e');
    }
  }

  void _handleOnlineToggle(bool value) {
    if (!_locationInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait for location initialization...'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isOnline = value;
      showRideRequest = false;
    });

    if (value) {
      // Start listening for nearby ride requests
      _startListeningForRideRequests();
    } else {
      // Stop listening and clear requests
      setState(() {
        rideRequests.clear();
        currentRideRequest = null;
      });
    }
  }

  void _centerMapOnDriver() {
    if (!_locationInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Waiting for location...'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentPosition != null) {
      mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        15.0,
      );
    }
  }

  void _startListeningForRideRequests() {
    if (!_locationInitialized || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait for location initialization...'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Add test ride near driver's location with delay
    Future.delayed(Duration(seconds: 2), () {
      if (isOnline && mounted) {
        final testRideRequest = {
          'id': 'test_ride_${DateTime.now().millisecondsSinceEpoch}',
          'status': 'pending',
          'pickup_location': GeoPoint(
            _currentPosition!.latitude + 0.003,
            _currentPosition!.longitude + 0.002,
          ),
          'dropoff_location': GeoPoint(
            _currentPosition!.latitude + 0.008,
            _currentPosition!.longitude + 0.006,
          ),
          'passengerName': 'Test Passenger',
          'fare': 350,
          'rating': 4.5,
          'pickup': 'Near Your Location (~300m)',
          'dropoff': 'Test Destination',
          'distance': '0.3 km',
        };

        setState(() {
          rideRequests = [testRideRequest];
          currentRideRequest = testRideRequest;
          showRideRequest = true;
        });
      }
    });

    // Create a geopoint from current position
    final GeoPoint driverLocation = GeoPoint(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    // Listen for new ride requests within radius
    _firestore
        .collection('ride_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      if (!isOnline) return;

      final List<Map<String, dynamic>> newRequests = [
        // testRideRequest
      ]; // Add test ride first

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final GeoPoint pickupLocation = data['pickup_location'];

        // Calculate distance between driver and pickup
        final double distance = Geolocator.distanceBetween(
          driverLocation.latitude,
          driverLocation.longitude,
          pickupLocation.latitude,
          pickupLocation.longitude,
        );

        // Only add requests within max radius
        if (distance <= _maxRequestRadius) {
          newRequests.add({
            ...data,
            'id': doc.id,
            'distance': '${(distance / 1000).toStringAsFixed(1)} km',
          });
        }
      }

      // Sort requests by distance
      newRequests.sort((a, b) {
        final distanceA = double.parse(a['distance'].replaceAll(' km', ''));
        final distanceB = double.parse(b['distance'].replaceAll(' km', ''));
        return distanceA.compareTo(distanceB);
      });

      setState(() {
        rideRequests = newRequests;
        if (rideRequests.isNotEmpty && currentRideRequest == null) {
          currentRideRequest = rideRequests[0];
          showRideRequest = true;
        }
      });
    });
  }

  void _acceptRideRequest() async {
    if (currentRideRequest == null || _currentPosition == null) return;

    // Don't process test rides through Firestore
    if (currentRideRequest!['id'].toString().startsWith('test_ride_')) {
      final pickup = LatLng(
        currentRideRequest!['pickup_location'].latitude,
        currentRideRequest!['pickup_location'].longitude,
      );

      final driverPosition = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      try {
        final routePoints = await getRoutePoints(driverPosition, pickup);

        setState(() {
          _routePoints = routePoints;
          isNavigatingToPickup = true;
          isRideAccepted = true;

          // Set pickup marker
          pickupMarker = Marker(
            point: pickup,
            builder: (ctx) => const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 32,
            ),
          );

          _routePolyline = Polyline(
            points: routePoints,
            strokeWidth: 4.0,
            color: Colors.blue,
            isDotted: false,
            borderColor: Colors.white,
            borderStrokeWidth: 1.0,
          );

          // Calculate estimated time and distance
          final distance =
              (routePoints.length * 0.1).toStringAsFixed(1); // Rough estimation
          final time = (routePoints.length * 0.2).toStringAsFixed(0);
          estimatedDistance = '$distance km';
          estimatedTime = '$time min';

          showRideRequest = false;
          rideRequests.clear();
        });

        _handleRideAccepted();
      } catch (e) {
        print('Error getting route: $e');
      }
      return;
    }

    // Handle real ride requests
    try {
      await _firestore
          .collection('ride_requests')
          .doc(currentRideRequest!['id'])
          .update({
        'status': 'accepted',
        'driver_id': _auth.currentUser?.uid,
        'driver_location': {
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
        },
        'accepted_at': FieldValue.serverTimestamp(),
      });

      // Calculate route to pickup location
      final pickup = LatLng(
        currentRideRequest!['pickup_location'].latitude,
        currentRideRequest!['pickup_location'].longitude,
      );

      final dropoff = LatLng(
        currentRideRequest!['dropoff_location'].latitude,
        currentRideRequest!['dropoff_location'].longitude,
      );

      await getRoute(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        pickup,
      );

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
    } catch (e) {
      print('Error accepting ride request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept ride request')),
      );
    }
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

  void _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DriverEditProfileScreen(),
      ),
    );
    // Reload data when returning from edit profile
    _loadDriverData();
  }

  void _handleRideAccepted() {
    setState(() {
      isNavigatingToPickup = true;
      isRideAccepted = true;
      rideStatus = RideStatus.accepted;
      showRideRequest = false;
      rideRequests.clear();
    });
  }

  Widget _buildDragHandle() => Container(
        margin: const EdgeInsets.all(8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildNavigationInfo() => Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  estimatedTime,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Time'),
              ],
            ),
            Container(width: 1, height: 40, color: Colors.grey[300]),
            Column(
              children: [
                Text(
                  estimatedDistance,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Distance'),
              ],
            ),
            if (rideStatus != RideStatus.initial) ...[
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Column(
                children: [
                  Text(
                    'PKR ${currentRideRequest?["fare"] ?? "0"}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Fare'),
                ],
              ),
            ],
          ],
        ),
      );

  Widget _buildPassengerInfo() => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.grey[400], size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentRideRequest?["passengerName"] ?? "Passenger",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentRideRequest?["pickup"] ?? "Pickup location",
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _callPassenger(passengerPhone),
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Colors.blue),
              onPressed: () => _messagePassenger(passengerPhone),
            ),
          ],
        ),
      );

  Widget _buildNavigationSteps() => Expanded(
        child: showNavigationInstructions
            ? ListView.builder(
                itemCount: navigationSteps.length,
                itemBuilder: (context, index) {
                  final isActive = index == 0;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isActive ? Colors.blue : Colors.grey[200],
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      navigationSteps[index],
                      style: TextStyle(
                        color: isActive ? Colors.black : Colors.grey,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              )
            : const SizedBox(),
      );

  Widget _buildActionButtons(StateSetter setState) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (rideStatus == RideStatus.accepted)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () =>
                      _updateRideStatus(RideStatus.arrivedAtPickup, setState),
                  child: const Text('Arrived at Pickup'),
                ),
              )
            else if (rideStatus == RideStatus.arrivedAtPickup)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () =>
                      _updateRideStatus(RideStatus.started, setState),
                  child: const Text('Start Trip'),
                ),
              )
            else if (rideStatus == RideStatus.started)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () =>
                      _updateRideStatus(RideStatus.completed, setState),
                  child: const Text('Complete Trip'),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _showCancellationDialog(setState),
                child: const Text('Cancel Ride'),
              ),
            ),
          ],
        ),
      );

  void _updateRideStatus(RideStatus newStatus, StateSetter setState) {
    setState(() {
      rideStatus = newStatus;
      if (newStatus == RideStatus.arrivedAtPickup) {
        bottomSheetHeight = 0.6;
        showNavigationInstructions = true;
      } else if (newStatus == RideStatus.completed) {
        Navigator.pop(context);
        _showTripSummary();
      }
    });
  }

  Future<void> _callPassenger(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> _messagePassenger(String phone) async {
    final url = 'sms:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _showCancellationDialog(StateSetter bottomSheetState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride'),
        content: const Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // First close the dialog
              Navigator.pop(context);

              // Update the state
              setState(() {
                rideStatus = RideStatus.cancelled;
                isRideAccepted = false;
                _routePolyline = null;
                pickupMarker = null;
                showNavigationInstructions = false;
                showRideRequest = false; // Make sure to reset this
              });
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTripSummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trip Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fare: PKR ${currentRideRequest?["fare"] ?? "0"}'),
            const Text('Distance: 2.5 km'),
            const Text('Duration: 15 minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                rideStatus = RideStatus.initial;
                isRideAccepted = false;
                _routePolyline = null;
                pickupMarker = null;
                showNavigationInstructions = false;
              });
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
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
                      backgroundImage: _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
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
                            _driverName,
                            style: GoogleFonts.poppins(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              _navigateToEditProfile();
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
          // OpenStreetMap as background
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: _center,
                zoom: 15.0,
                minZoom: 5,
                maxZoom: 18,
                rotation: 0, // Prevent map rotation
                interactiveFlags: InteractiveFlag.all &
                    ~InteractiveFlag.rotate, // Disable rotation
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}', // Terrain tiles
                  subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                  userAgentPackageName: 'com.example.app',
                ),
                CurrentLocationLayer(
                  positionStream: const LocationMarkerDataStreamFactory()
                      .geolocatorPositionStream(),
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    ),
                    markerSize: Size(40, 40),
                    accuracyCircleColor: Colors.blue,
                    headingSectorColor: Colors.blue,
                    showHeadingSector: true,
                    showAccuracyCircle: true,
                  ),
                ),
                // Draw route if available
                PolylineLayer(
                  polylines: [
                    if (_routePolyline != null) _routePolyline!,
                  ],
                ),
                // Add markers layer
                MarkerLayer(
                  markers: [
                    if (pickupMarker != null) pickupMarker!,
                    if (dropoffMarker != null) dropoffMarker!,
                  ],
                ),
                // Add center button here
                Positioned(
                  right: 20,
                  bottom: 200,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: _centerMapOnDriver,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.my_location,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Conditional UI Elements
          if (!isRideAccepted) ...[
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
                          onTap: () => _navigateToEditProfile(),
                          child: _buildProfileImage(size: profileImageSize),
                        ),
                        SizedBox(width: fieldSpacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _driverName,
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
                          activeTrackColor:
                              AppTheme.goldAccent.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats Grid
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
            if (!showRideRequest)
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
                              isOnline
                                  ? Icons.check_circle
                                  : Icons.info_outline,
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
                                  color: isOnline
                                      ? Colors.green
                                      : Colors.grey[600],
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

          // Always show this when ride is accepted
          if (isRideAccepted)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Minimalist header with ride info
                  Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.flag, color: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Heading to pickup',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${estimatedTime} • ${estimatedDistance}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'PKR ${currentRideRequest?["fare"] ?? "0"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expandable bottom sheet
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDragHandle(),
                        if (showNavigationInstructions) ...[
                          _buildNavigationInfo(),
                          _buildPassengerInfo(),
                          _buildNavigationSteps(),
                        ],
                        _buildActionButtons(setState),
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Map controls (always visible, REMOVE the old one)
          // Update the ride acceptance UI
          if (isRideAccepted)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ride phase indicator
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              rideStatus == RideStatus.accepted
                                  ? Icons.flag
                                  : Icons.directions_car,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rideStatus == RideStatus.accepted
                                        ? 'Heading to pickup'
                                        : rideStatus == RideStatus.started
                                            ? 'Trip in progress'
                                            : 'Arrived at pickup',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${estimatedTime} • ${estimatedDistance}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'PKR ${currentRideRequest?["fare"] ?? "0"}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (rideStatus == RideStatus.arrivedAtPickup) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => _updateRideStatus(
                                  RideStatus.started, setState),
                              child: const Text('START TRIP'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Bottom sheet content
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDragHandle(),
                        _buildPassengerInfo(),
                        if (showNavigationInstructions) _buildNavigationSteps(),
                        _buildActionButtons(setState),
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                ],
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
                      child: Icon(Icons.circle,
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
                      padding: EdgeInsets.only(top: 2, left: 0.5),
                      child: Icon(Icons.location_on,
                          color: Colors.red, size: iconSize * 0.7),
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
