import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RideHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> rideHistory = [
    {
      "date": "2025-03-09",
      "time": "10:30 AM",
      "from": "DHA Phase 6",
      "to": "Clifton Beach",
      "fare": "PKR 450",
      "status": "Completed",
      "driverName": "Abdullah Khan",
      "carDetails": "Honda City (ABC-123)"
    },
    {
      "date": "2025-03-08",
      "time": "2:15 PM",
      "from": "Gulshan-e-Iqbal",
      "to": "Saddar",
      "fare": "PKR 350",
      "status": "Cancelled",
      "driverName": "Faisal Ahmed",
      "carDetails": "Toyota Corolla (XYZ-789)"
    },
    {
      "date": "2025-03-07",
      "time": "9:00 AM",
      "from": "Nazimabad",
      "to": "North Nazimabad",
      "fare": "PKR 250",
      "status": "Completed",
      "driverName": "Ahmed Raza",
      "carDetails": "Suzuki Cultus (IK-804)"
    },
  ];

  RideHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Ride History",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: MediaQuery.of(context).size.width / 20,
          ),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: rideHistory.length,
        itemBuilder: (context, index) {
          final ride = rideHistory[index];
          return Card(
            elevation: 2,
            color: Colors.white,
            shadowColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.16,
                maxHeight: MediaQuery.of(context).size.height * 0.20,
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date/Time and Status row at top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date and time at top left
                      Text(
                        "${ride['date']} ${ride['time']}",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      // Status badge at top right
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ride['status'] == "Completed"
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ride['status'],
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: ride['status'] == "Completed"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Locations with dots
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
                              height: 16,
                              color: Colors.grey[300],
                              margin: const EdgeInsets.symmetric(vertical: 3),
                            ),
                            const Icon(Icons.circle,
                                color: Color(0xFFD4AF37), size: 8),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                ride['from'],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    ride['to'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  ride['fare'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF323d4f),
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
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ride['driverName'],
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
                          ride['carDetails'],
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
