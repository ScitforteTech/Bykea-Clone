import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Resources/theme.dart';
import '../../utils/custom_size.dart';

enum RideType {
  mini,
  comfort,
}

class TripRequest {
  final String pickup;
  final String dropoff;
  final String distance;
  final int fare;
  final DateTime time;
  final String passengerName;
  final double passengerRating;
  final bool isExpress;
  final RideType rideType;

  TripRequest({
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
    required this.time,
    required this.passengerName,
    required this.passengerRating,
    required this.isExpress,
    required this.rideType,
  });
}

class DriverTripRequestsScreen extends StatefulWidget {
  const DriverTripRequestsScreen({Key? key}) : super(key: key);

  @override
  State<DriverTripRequestsScreen> createState() =>
      _DriverTripRequestsScreenState();
}

class _DriverTripRequestsScreenState extends State<DriverTripRequestsScreen> {
  final List<TripRequest> tripRequests = [
    TripRequest(
      pickup: 'Gulshan-e-Iqbal, Block 13-D',
      dropoff: 'Tariq Road, PECHS',
      distance: '2.5 km',
      fare: 350,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      passengerName: 'Ahmed',
      passengerRating: 4.8,
      isExpress: false,
      rideType: RideType.mini,
    ),
    TripRequest(
      pickup: 'Clifton, Block 5',
      dropoff: 'Saddar, Karachi',
      distance: '4.2 km',
      fare: 500,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      passengerName: 'Sara',
      passengerRating: 4.9,
      isExpress: true,
      rideType: RideType.comfort,
    ),
    TripRequest(
      pickup: 'DHA Phase 6',
      dropoff: 'Karachi Airport',
      distance: '8.7 km',
      fare: 800,
      time: DateTime.now().subtract(const Duration(minutes: 8)),
      passengerName: 'Mohammed',
      passengerRating: 4.7,
      isExpress: false,
      rideType: RideType.mini,
    ),
  ];

  // Track trips by status
  List<TripRequest> displayedTrips = [];
  TripRequest? acceptedTrip;

  @override
  void initState() {
    super.initState();
    // Initialize the displayed trips
    displayedTrips = List.from(tripRequests);
  }

  void _acceptTrip(TripRequest trip) {
    setState(() {
      // Set this trip as accepted
      acceptedTrip = trip;
      // Clear all other trips
      displayedTrips.clear();
      // Add only the accepted trip to the displayed list
      displayedTrips.add(trip);
    });

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trip accepted! Starting navigation...'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Here you would navigate to trip details
            _showTripDetailsDialog(trip);
          },
        ),
      ),
    );
  }

  void _rejectTrip(TripRequest trip) {
    setState(() {
      // Remove this trip from the displayed list
      displayedTrips.removeWhere((t) =>
          t.passengerName == trip.passengerName &&
          t.pickup == trip.pickup &&
          t.dropoff == trip.dropoff);
    });

    // Show a rejection snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trip rejected'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 1),
      ),
    );

    // Show a message if no more trips
    if (displayedTrips.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more trips available'),
              backgroundColor: Colors.grey,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  void _showTripDetailsDialog(TripRequest trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Trip Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Passenger: ${trip.passengerName}'),
            SizedBox(height: 8),
            Text('Pickup: ${trip.pickup}'),
            SizedBox(height: 8),
            Text('Dropoff: ${trip.dropoff}'),
            SizedBox(height: 8),
            Text('Fare: PKR ${trip.fare}'),
            SizedBox(height: 8),
            Text('Distance: ${trip.distance}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        title: Text(
          'Trip Requests',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: displayedTrips.length,
        itemBuilder: (context, index) {
          return _buildTripRequestCard(displayedTrips[index]);
        },
      ),
    );
  }

  Widget _buildTripRequestCard(TripRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTripHeader(request),
          _buildTripDetails(request),
          _buildTripActions(request),
        ],
      ),
    );
  }

  Widget _buildTripHeader(TripRequest request) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
            child: Text(
              request.passengerName[0],
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      request.passengerName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: request.rideType == RideType.comfort
                            ? AppTheme.goldAccent.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.rideType == RideType.comfort
                            ? 'Comfort'
                            : 'Mini',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: request.rideType == RideType.comfort
                              ? AppTheme.goldAccent
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppTheme.goldAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      request.passengerRating.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${request.distance} away',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails(TripRequest request) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.circle, color: Colors.green, size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  request.pickup,
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
              const Icon(Icons.location_on, color: Colors.red, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  request.dropoff,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 7.5),
                      child: Image.asset(
                        'assets/images/sedan.png',
                        width: 22,
                        height: 22,
                      )),
                  const SizedBox(width: 4),
                  Text(
                    request.distance,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                'Rs. ${request.fare}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripActions(TripRequest request) {
    // If this is the accepted trip, show a different UI
    final isAccepted = acceptedTrip != null &&
        acceptedTrip!.passengerName == request.passengerName &&
        acceptedTrip!.pickup == request.pickup &&
        acceptedTrip!.dropoff == request.dropoff;

    if (isAccepted) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          color: Colors.green.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Trip Accepted',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _showTripDetailsDialog(request);
                  },
                  icon: Icon(Icons.directions, size: 18),
                  label: Text('Navigate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    side: BorderSide(color: AppTheme.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Get ready for pickup at ${request.pickup}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    // Regular action buttons for non-accepted trips
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                _acceptTrip(request);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Accept',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextButton(
              onPressed: () {
                _rejectTrip(request);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Decline',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
