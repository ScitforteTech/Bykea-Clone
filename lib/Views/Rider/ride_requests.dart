import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';

class RideRequestsPage extends StatefulWidget {
  const RideRequestsPage({super.key});

  @override
  _RideRequestsPageState createState() => _RideRequestsPageState();
}

class _RideRequestsPageState extends State<RideRequestsPage> {
  List<Map<String, dynamic>> rideRequests = List.generate(
    5,
    (index) => {
      "id": index,
      "driverName": [
        "Dua Fatima",
        "Ahmed Hassan",
        "Zainab Ali",
        "Bilal Khan",
        "Ayesha Imran"
      ][index],
      "driverImage":
          "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=150&auto=format&fit=crop",
      "pickup": "DHA Phase 6",
      "dropoff": "Clifton Beach",
      "fare": (index + 1) * 200,
      "time": "10:30 AM",
      "arrival": "5 mins",
      "carDetails": [
        "Honda Civic (LEH-123)",
        "Toyota Corolla (ABC-999)",
        "Suzuki Swift (IK-804)",
        "Honda City (XYZ-456)",
        "Toyota Yaris (KHI-789)"
      ][index],
      "status": null,
    },
  );

  void acceptRide(int id) {
    setState(() {
      // First mark the selected ride as accepted
      for (var ride in rideRequests) {
        if (ride["id"] == id) {
          ride["status"] = "Accepted";
        }
      }

      // Then filter the list to keep only the accepted ride
      rideRequests = rideRequests.where((ride) => ride["id"] == id).toList();
    });
  }

  void rejectRide(int id) {
    setState(() {
      for (var ride in rideRequests) {
        if (ride["id"] == id) {
          ride["status"] = "Rejected";
        }
      }

      // Remove the rejected ride from the list
      rideRequests = rideRequests.where((ride) => ride["id"] != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Ride Requests",
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: CustomSize().customWidth(context) / 20),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: rideRequests.length,
        itemBuilder: (context, index) {
          var ride = rideRequests[index];

          return FractionallySizedBox(
            widthFactor: 0.95,
            child: Card(
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.17,
                  maxHeight: MediaQuery.of(context).size.height * 0.22,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date and Time row at top left
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          "${ride["time"]} • ${ride["arrival"]}",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    // Location section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Location dots and line
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.circle,
                                  color: Color(0xFF323d4f), size: 8),
                              Container(
                                width: 2,
                                height: 18,
                                color: Colors.grey[300],
                                margin: const EdgeInsets.symmetric(vertical: 3),
                              ),
                              const Icon(Icons.circle,
                                  color: Color(0xFFD4AF37), size: 8),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Location texts
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      ride["pickup"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ride["dropoff"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 1), // Add bottom padding here
                                    child: Text(
                                      "PKR ${ride["fare"]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF323d4f),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Driver info row - single line
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.025,
                          backgroundImage: NetworkImage(ride["driverImage"]),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ride["driverName"],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF323d4f),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "•",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ride["carDetails"],
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),

                    // Bottom section with buttons
                    ride["status"] == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.035,
                                  child: ElevatedButton(
                                    onPressed: () => acceptRide(ride["id"]),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF323d4f),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                      ),
                                    ),
                                    child: Text(
                                      "Accept",
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04),
                              Expanded(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.035,
                                  child: ElevatedButton(
                                    onPressed: () => rejectRide(ride["id"]),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF323d4f),
                                      side: const BorderSide(
                                          color: Color(0xFF323d4f)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                      ),
                                    ),
                                    child: Text(
                                      "Reject",
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.035,
                            decoration: BoxDecoration(
                              color: ride["status"] == "Accepted"
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                ride["status"],
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.032,
                                  fontWeight: FontWeight.w600,
                                  color: ride["status"] == "Accepted"
                                      ? Colors.green
                                      : Colors.red,
                                ),
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
    );
  }
}
