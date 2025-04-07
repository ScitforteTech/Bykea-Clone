import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:vroom_ride_app/Views/auth_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vroom_ride_app/widgets/map_widget.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart'; // Add this import
import 'dart:ui'; // Import for PointerDeviceKind

class RiderDashboard extends StatefulWidget {
  const RiderDashboard({super.key});

  @override
  State<RiderDashboard> createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard>
    with SingleTickerProviderStateMixin {
  String selectedVehicle = 'Moto';
  String userName = '';
  String profilePicUrl = '';
  bool _isDashboardVisible = true;
  final TextEditingController _pickupLocationController =
      TextEditingController();
  final TextEditingController _dropoffLocationController =
      TextEditingController();
  final GlobalKey<MapWidgetState> mapKey = GlobalKey<MapWidgetState>();
  double _bottomSheetSize = 0.4;
  List<Placemark> _pickupSuggestions = [];
  List<Placemark> _dropoffSuggestions = [];
  Timer? _debounceTimer;

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

  final Duration _animationDuration = const Duration(milliseconds: 300);

  // Add these constants after other class variables
  final double _karachiNorthLat = 25.0700;
  final double _karachiSouthLat = 24.7700;
  final double _karachiEastLng = 67.3650;
  final double _karachiWestLng = 66.6750;

  // Add these variables after other declarations
  bool _isPickupSelected = false;
  bool _isDropoffSelected = false;
  bool _isSelectingFromMap = false;
  bool _isSelectingPickup = true;
  String _draggedLocationText = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupLocationControllers();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            userName = userData.data()?['name'] ?? 'User';
            profilePicUrl = userData.data()?['profilePicture'] ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  void _setupLocationControllers() {
    _pickupLocationController.addListener(() {
      if (_pickupLocationController.text.isNotEmpty && !_isPickupSelected) {
        _debounceLocationSearch(_pickupLocationController.text, true);
      } else {
        setState(() => _pickupSuggestions = []);
      }
    });

    _dropoffLocationController.addListener(() {
      if (_dropoffLocationController.text.isNotEmpty && !_isDropoffSelected) {
        _debounceLocationSearch(_dropoffLocationController.text, false);
      } else {
        setState(() => _dropoffSuggestions = []);
      }
    });
  }

  void _debounceLocationSearch(String query, bool isPickup) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      // Increased debounce time
      _searchLocation(query, isPickup);
    });
  }

  Future<void> _searchLocation(String query, bool isPickup) async {
    if (query.isEmpty) return;

    try {
      // First try geocoding with partial query
      final searchQuery = "$query, Karachi, Pakistan";
      List<Location> locations = [];

      try {
        locations = await locationFromAddress(searchQuery);
      } catch (_) {
        // If exact match fails, try with common areas
        final commonAreas = [
          "North Karachi",
          "North Nazimabad",
          "Gulshan",
          "Clifton",
          "DHA",
          "Saddar",
          "Malir",
        ];

        for (var area in commonAreas) {
          if (area.toLowerCase().contains(query.toLowerCase())) {
            try {
              final areaLocations =
                  await locationFromAddress("$area, Karachi, Pakistan");
              locations.addAll(areaLocations);
            } catch (_) {}
          }
        }
      }

      if (locations.isNotEmpty) {
        final List<Placemark> nearbyPlaces = [];

        // Get placemarks for each location
        for (var location in locations) {
          try {
            final placemarks = await placemarkFromCoordinates(
              location.latitude,
              location.longitude,
            );

            // Filter relevant results
            for (var place in placemarks) {
              if (_isRelevantLocation(place, query)) {
                nearbyPlaces.add(place);
              }
            }
          } catch (_) {}
        }

        setState(() {
          if (isPickup) {
            _pickupSuggestions = nearbyPlaces;
          } else {
            _dropoffSuggestions = nearbyPlaces;
          }
        });
      }
    } catch (e) {
      debugPrint('Error searching location: $e');
    }
  }

  bool _isRelevantLocation(Placemark place, String query) {
    final searchTerms = query.toLowerCase().split(' ');
    final addressComponents = [
      place.street,
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
    ].where((component) => component != null).map((e) => e!.toLowerCase());

    // Check if any search term is contained in any address component
    return searchTerms.any((term) =>
        addressComponents.any((component) => component.contains(term)));
  }

  String _formatAddress(Placemark place) {
    // Format address without plus codes and clean up components
    List<String> components = [];

    // Helper function to clean and validate address component
    bool isValidComponent(String? component) {
      if (component == null || component.isEmpty) return false;
      // Remove plus codes (they typically follow the pattern of XXXX+XXX)
      if (RegExp(r'[A-Z0-9]{4}\+[A-Z0-9]{3}').hasMatch(component)) return false;
      return true;
    }

    String? streetName =
        place.street?.split(',')[0]; // Take only first part before comma
    if (isValidComponent(streetName)) components.add(streetName!);

    if (isValidComponent(place.subLocality)) components.add(place.subLocality!);
    if (isValidComponent(place.locality)) components.add(place.locality!);

    return components.join(', ');
  }

  void _updateMapRoute() {
    if (_isPickupSelected && _isDropoffSelected) {
      final mapState = mapKey.currentState;
      if (mapState != null) {
        // Get locations from the map widget
        final pickup = mapState.pickupLocation;
        final dropoff = mapState.dropoffLocation;

        if (pickup != null && dropoff != null) {
          mapState.setRoute(pickup, dropoff);
        }
      }
    }
  }

  Future<void> _handleLocationSelection(
      bool isPickup, String address, LatLng location) async {
    setState(() {
      if (isPickup) {
        _isPickupSelected = true;
        _pickupSuggestions = [];
        mapKey.currentState?.setPickupLocation(address, location);
      } else {
        _isDropoffSelected = true;
        _dropoffSuggestions = [];
        mapKey.currentState?.setDropoffLocation(address, location);
      }
      _isSelectingFromMap = false;
      // Make sure to stop location selection mode in map widget
      mapKey.currentState?.stopLocationSelection();
    });

    // Update route if both locations are selected
    if (_isPickupSelected && _isDropoffSelected) {
      _updateMapRoute();
    }
  }

  Future<void> _selectLocationFromMap(bool isPickup) async {
    setState(() {
      _isSelectingFromMap = true;
      _isSelectingPickup = isPickup;
      _draggedLocationText = '';
      _isDashboardVisible = false; // Hide dashboard elements
      _bottomSheetSize = 0.0; // Collapse bottom sheet completely
    });

    final mapState = mapKey.currentState;
    if (mapState != null) {
      mapState.startLocationSelection();
      mapState.centerOnUserLocation();
    }

    showOverlay(context);
  }

  void showOverlay(BuildContext context) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Remove the top gesture detector that was blocking interactions
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                final mapState = mapKey.currentState;
                if (mapState != null) {
                  final location = mapState.mapController.center;
                  await _handleLocationSelection(
                    _isSelectingPickup,
                    _draggedLocationText,
                    location,
                  );
                  overlayEntry?.remove();
                  setState(() {
                    _isSelectingFromMap = false;
                    _bottomSheetSize = 0.4;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF323d4f),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check),
                  const SizedBox(width: 8),
                  Text(
                    'Confirm Location',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  Future<void> _handleMapLocationSelected(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        String address = _formatAddress(placemarks[0]);
        await _handleLocationSelection(
          _isSelectingPickup,
          address,
          location,
        );

        setState(() {
          if (_isSelectingPickup) {
            _pickupLocationController.text = address;
          } else {
            _dropoffLocationController.text = address;
          }
          _isSelectingFromMap = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting address for selected location: $e');
      setState(() {
        _isSelectingFromMap = false;
      });
    }
  }

  Widget _buildLocationInput({
    required TextEditingController controller,
    required String label,
    required Icon icon,
    required List<Placemark> suggestions,
    required bool isPickup,
  }) {
    bool isSelected = isPickup ? _isPickupSelected : _isDropoffSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF323d4f),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    icon,
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        enabled: !isSelected, // Disable when selected
                        onTap: () {
                          if (isPickup) {
                            mapKey.currentState
                                ?.setShouldUpdateLocationText(false);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: isSelected
                              ? 'Location selected'
                              : 'Enter ${isPickup ? "pickup" : "drop-off"} location',
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    if (isSelected)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            if (isPickup) {
                              _isPickupSelected = false;
                              mapKey.currentState?.setPickupLocation(
                                  '',
                                  // Use Karachi coordinates instead of 0,0
                                  const LatLng(24.8607, 67.0011));
                            } else {
                              _isDropoffSelected = false;
                              mapKey.currentState?.setDropoffLocation(
                                  '',
                                  // Use Karachi coordinates instead of 0,0
                                  const LatLng(24.8607, 67.0011));
                            }
                            controller.clear();
                            mapKey.currentState?.clearRoute();
                          });
                        },
                      ),
                  ],
                ),
              ),
              if (!isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: double.infinity,
                  child: TextButton.icon(
                    icon: const Icon(Icons.map),
                    label: Text('Choose from map'),
                    onPressed: () => _selectLocationFromMap(isPickup),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF323d4f),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              if (suggestions.isNotEmpty && !isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: suggestions.take(3).map((place) {
                      String address = _formatAddress(place);
                      return ListTile(
                        title: Text(address),
                        onTap: () async {
                          try {
                            List<Location> locations =
                                await locationFromAddress(
                              "${place.street}, ${place.subLocality}, Karachi, Pakistan",
                            );

                            if (locations.isNotEmpty) {
                              LatLng selectedLocation = LatLng(
                                locations[0].latitude,
                                locations[0].longitude,
                              );
                              await _handleLocationSelection(
                                isPickup,
                                address,
                                selectedLocation,
                              );
                            }
                          } catch (e) {
                            debugPrint(
                                'Error getting location coordinates: $e');
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Add this method to check if both locations are selected
  bool get _areLocationsSelected => _isPickupSelected && _isDropoffSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: mapKey,
            onMapInteraction: (isInteracting) {
              if (!_isSelectingFromMap) {
                // Only update when not selecting location
                setState(() {
                  _isDashboardVisible = !isInteracting;
                  _bottomSheetSize = isInteracting ? 0.2 : 0.4;
                });
              }
            },
            onLocationUpdate: (address) {
              setState(() {
                _pickupLocationController.text = address;
              });
            },
            onMapLocationSelected:
                _isSelectingFromMap ? _handleMapLocationSelected : null,
            onDragLocation: (location, address) {
              setState(() => _draggedLocationText = address);
            },
          ),

          // Only show UI elements when not selecting from map
          if (!_isSelectingFromMap) ...[
            // Menu button
            AnimatedPositioned(
              duration: _animationDuration,
              curve: Curves.easeInOut,
              top: 40,
              left: _isDashboardVisible ? 16 : -80,
              child: AnimatedOpacity(
                duration: _animationDuration,
                opacity: _isDashboardVisible ? 1.0 : 0.0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Location button
            AnimatedPositioned(
              duration: _animationDuration,
              curve: Curves.easeInOut,
              top: 40,
              right: _isDashboardVisible ? 16 : -80,
              child: AnimatedOpacity(
                duration: _animationDuration,
                opacity: _isDashboardVisible ? 1.0 : 0.0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: IconButton(
                    icon: const Icon(Icons.my_location, color: Colors.black),
                    onPressed: () {
                      final mapState = mapKey.currentState;
                      if (mapState != null) {
                        mapState.centerOnUserLocation();
                      }
                    },
                  ),
                ),
              ),
            ),

            // Stats card
            AnimatedPositioned(
              duration: _animationDuration,
              curve: Curves.easeInOut,
              top: _isDashboardVisible ? 100 : -100,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                duration: _animationDuration,
                opacity: _isDashboardVisible ? 1.0 : 0.0,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ride more — help more',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rides: 0/4',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF323d4f),
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'assets/images/logo1.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom sheet
            AnimatedPositioned(
              duration: _animationDuration,
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height,
              child: SizedBox.expand(
                child: DraggableScrollableSheet(
                  initialChildSize: _bottomSheetSize,
                  minChildSize: 0.1,
                  maxChildSize: 0.7,
                  snapSizes: const [0.1, 0.4, 0.7],
                  snap: true,
                  snapAnimationDuration: const Duration(milliseconds: 200),
                  controller: DraggableScrollableController(),
                  builder: (context, scrollController) {
                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        physics:
                            const BouncingScrollPhysics(), // Smoother scrolling
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child:
                          NotificationListener<DraggableScrollableNotification>(
                        onNotification: (notification) {
                          setState(() {
                            _bottomSheetSize = notification.extent;
                          });
                          return true;
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListView(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            children: [
                              // Drag handle
                              Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              // Vehicle type selection
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  top: 16,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'Select Vehicle Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF323d4f),
                                  ),
                                ),
                              ),
                              Container(
                                height: 120,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                                        width: 90,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF323d4f)
                                                  .withOpacity(0.1)
                                              : Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: isSelected
                                              ? Border.all(
                                                  color:
                                                      const Color(0xFF323d4f),
                                                  width: 2,
                                                )
                                              : null,
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF323d4f)
                                                            .withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            type == 'Ride A/C'
                                                ? Image.asset(
                                                    data['image'] as String,
                                                    height: 60,
                                                    width: 60,
                                                  )
                                                : Image.asset(
                                                    data['image'] as String,
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                            const SizedBox(height: 4),
                                            Text(
                                              type,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: isSelected
                                                    ? const Color(0xFF323d4f)
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 14,
                                                  color: Colors.grey[700],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${data['seats']}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
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
                              const SizedBox(height: 16),
                              _buildLocationInput(
                                controller: _pickupLocationController,
                                label: 'Pickup Location',
                                icon: const Icon(Icons.circle,
                                    color: Colors.green, size: 16),
                                suggestions: _pickupSuggestions,
                                isPickup: true,
                              ),
                              const SizedBox(height: 16),
                              _buildLocationInput(
                                controller: _dropoffLocationController,
                                label: 'Drop-off Location',
                                icon: const Icon(Icons.location_on,
                                    color: Colors.red),
                                suggestions: _dropoffSuggestions,
                                isPickup: false,
                              ),
                              const SizedBox(height: 16),

                              // Fare input
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, bottom: 8),
                                child: Text(
                                  'Your Fare Offer',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF323d4f),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        'PKR',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter your fare',
                                            border: InputBorder.none,
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Find driver button
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF323d4f),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.monetization_on,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Find a driver',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.tune, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
      drawer: _isSelectingFromMap
          ? null
          : Drawer(
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
                            backgroundImage: profilePicUrl.isNotEmpty
                                ? NetworkImage(profilePicUrl)
                                : const AssetImage(
                                        'assets/images/profile_pic.jpeg')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName.isNotEmpty ? userName : 'Loading...',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    // Close drawer first
                                    Navigator.pop(context);
                                    // Navigate to edit profile page and wait for result
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfilePage(),
                                      ),
                                    );
                                    // If returned with true, refresh the user data
                                    if (result == true) {
                                      await _loadUserData();
                                    }
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
                      leading: const Icon(Icons.local_taxi,
                          color: Color(0xFFD4AF37)),
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
                            builder: (context) => const RideRequestsPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.history, color: Color(0xFFD4AF37)),
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
                          MaterialPageRoute(
                              builder: (context) => RideHistoryPage()),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.share, color: Color(0xFFD4AF37)),
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
                          MaterialPageRoute(
                              builder: (context) => const ReferPage()),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.account_balance_wallet,
                        color: Color(0xFFD4AF37),
                      ),
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
                          MaterialPageRoute(
                              builder: (context) => const WalletPage()),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: Color(0xFFD4AF37),
                      ),
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
                            builder: (context) => const NotificationPage(),
                          ),
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
                          MaterialPageRoute(
                              builder: (context) => const FAQsPage()),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.privacy_tip,
                        color: Color(0xFFD4AF37),
                      ),
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
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    // Help & Support Item
                    ListTile(
                      leading: const Icon(
                        Icons.help_outline,
                        color: Color(0xFFD4AF37),
                      ),
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
                            builder: (context) => const SupportPage(),
                          ),
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
                                  child: Text('Cancel',
                                      style: GoogleFonts.poppins()),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to login screen and remove all previous routes
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const loginScreen(),
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
                    const Divider(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Version 1.0.0',
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _pickupLocationController.dispose();
    _dropoffLocationController.dispose();
    super.dispose();
  }
}
