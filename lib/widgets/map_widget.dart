import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'location_search.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapWidget extends StatefulWidget {
  final LatLng center;
  final double zoom;
  final Function(bool) onMapInteraction;
  final Function(String) onLocationUpdate;
  final Function(LatLng)? onMapLocationSelected; // Add this line
  final Function(LatLng, String)? onDragLocation; // Add this

  const MapWidget({
    Key? key,
    this.center = const LatLng(24.8607, 67.0011),
    this.zoom = 13,
    required this.onMapInteraction,
    required this.onLocationUpdate,
    this.onMapLocationSelected, // Add this line
    this.onDragLocation,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  bool _isInteracting = false;
  Timer? _interactionTimer;
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStream;
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  bool _shouldUpdateLocationText = true;
  List<LatLng> _routePoints = [];
  bool _isSelectingLocation = false;
  bool _isDragging = false;
  Timer? _dragDebounce;
  final _dragUpdateDelay = const Duration(milliseconds: 150);

  // Add getters to access locations
  LatLng? get pickupLocation => _pickupLocation;
  LatLng? get dropoffLocation => _dropoffLocation;

  // Add public getter for mapController
  MapController get mapController => _mapController;

  // Update the getter to only check if selecting location is active
  bool get _shouldShowSelectionUI => _isSelectingLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _updateLocation(position);
    // Move map to current location on init
    _mapController.move(LatLng(position.latitude, position.longitude), 15);

    _positionStream = Geolocator.getPositionStream().listen(_updateLocation);
  }

  void _updateLocation(Position position) {
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    if (_shouldUpdateLocationText) {
      _getAddressFromLatLng();
    }
  }

  void setShouldUpdateLocationText(bool value) {
    _shouldUpdateLocationText = value;
  }

  Future<void> _getAddressFromLatLng() async {
    if (_currentLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address =
              '${place.street}, ${place.subLocality}, ${place.locality}';
          widget.onLocationUpdate(address);
        }
      } catch (e) {
        debugPrint('Error getting address: $e');
      }
    }
  }

  void centerOnUserLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    }
  }

  void _handleMapInteraction([PointerDownEvent? event, dynamic details]) {
    if (!_isInteracting) {
      setState(() => _isInteracting = true);
      widget.onMapInteraction(true);
    }

    _interactionTimer?.cancel();
    _interactionTimer = Timer(const Duration(milliseconds: 200), () {
      setState(() => _isInteracting = false);
      widget.onMapInteraction(false);
    });
  }

  void setPickupLocation(String address, LatLng location) {
    setState(() => _pickupLocation = location);
    if (_pickupLocation != null) {
      _mapController.move(_pickupLocation!, 15);
    }
  }

  void setDropoffLocation(String address, LatLng location) {
    setState(() => _dropoffLocation = location);
    if (_dropoffLocation != null) {
      _mapController.move(_dropoffLocation!, 15);
    }
  }

  Future<void> setRoute(LatLng start, LatLng end) async {
    try {
      // OpenRouteService API
      final String apiKey =
          '5b3ce3597851110001cf62482968ef0f13f34071899c36bb7b30c69a'; // Get from openrouteservice.org
      final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?'
        'api_key=$apiKey'
        '&start=${start.longitude},${start.latitude}'
        '&end=${end.longitude},${end.latitude}',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coordinates =
            data['features'][0]['geometry']['coordinates'] as List;

        setState(() {
          _routePoints = coordinates.map((point) {
            return LatLng(point[1] as double, point[0] as double);
          }).toList();
        });

        // Fit map bounds to show route with padding
        final bounds = LatLngBounds.fromPoints(_routePoints);
        _mapController.fitBounds(
          bounds,
          options: const FitBoundsOptions(
            padding: EdgeInsets.all(50.0),
            maxZoom: 16,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting route: $e');
      // Fallback to straight line if route fails
      setState(() {
        _routePoints = [start, end];
      });
    }
  }

  void clearRoute() {
    setState(() {
      _routePoints = [];
    });
  }

  void startLocationSelection() {
    setState(() {
      _isSelectingLocation = true;
    });
  }

  void stopLocationSelection() {
    setState(() {
      _isSelectingLocation = false;
    });
  }

  void _handleMapPositionChanged(MapPosition position, bool hasGesture) {
    if (!hasGesture) return;

    if (_isSelectingLocation) {
      _dragDebounce?.cancel();
      _dragDebounce = Timer(_dragUpdateDelay, () async {
        // Get center of map
        final center = _mapController.center;

        try {
          final placemarks =
              await placemarkFromCoordinates(center.latitude, center.longitude);

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            String address =
                '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}';
            address =
                address.replaceAll(RegExp(r'[A-Z0-9]{4}\+[A-Z0-9]{3}'), '');
            widget.onDragLocation?.call(center, address);
          }
        } catch (e) {
          debugPrint('Error getting drag location: $e');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _currentLocation ?? widget.center,
            zoom: widget.zoom,
            onPositionChanged: _handleMapPositionChanged,
            onPointerDown: (event, details) => _handleMapInteraction(),
            onTap: _isSelectingLocation && widget.onMapLocationSelected != null
                ? (tapPosition, latLng) {
                    widget.onMapLocationSelected!(latLng);
                    stopLocationSelection();
                  }
                : null,
            // Ensure all interactions are enabled except rotation
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://mt1.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.app',
              maxZoom: 20,
              tileProvider: NetworkTileProvider(),
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () {},
                ),
              ],
            ),
            if (_routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    strokeWidth: 4,
                    color: Colors.blue.withOpacity(0.8),
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (_currentLocation != null)
                  Marker(
                    point: _currentLocation!,
                    builder: (ctx) => const Icon(
                      Icons.location_history,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                if (_pickupLocation != null)
                  Marker(
                    point: _pickupLocation!,
                    builder: (ctx) => const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 15,
                    ),
                  ),
                if (_dropoffLocation != null)
                  Marker(
                    point: _dropoffLocation!,
                    builder: (ctx) => const Icon(
                      Icons.place,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (_shouldShowSelectionUI)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
                const SizedBox(height: 4),
                /*
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Drag map to set location',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _interactionTimer?.cancel();
    _positionStream?.cancel();
    super.dispose();
  }
}
