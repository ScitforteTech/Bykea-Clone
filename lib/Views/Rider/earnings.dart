import 'package:flutter/material.dart';
import 'package:vroom_ride_app/Views/Rider/earning_overview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Earnings Details",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: width / 21, // Responsive
          ),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('assets/images/logo.jpeg',
                    height: height * 0.20),
              ),
              SizedBox(height: height * 0.01),

              // **🔹 Buttons Row**
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _earningsButton("Today", () {}),
                    SizedBox(width: width * 0.15),
                    _earningsButton("This Month", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EarningsOverviewPage()),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),

              // **🔹 Earnings Cards**
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _earningsCard("Daily Earnings", "Rs 120"),
                  SizedBox(width: width * 0.03),
                  _earningsCard("Monthly Earnings", "Rs 3200"),
                ],
              ),
              SizedBox(height: height * 0.02),

              // **🔹 Earnings Details Title**
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Earnings Details",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: width / 21,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),

              // **🔹 Earnings List**
              SizedBox(
                height: height * 0.30, // Fixed height for layout consistency
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading:
                          const Icon(Icons.money, color: Color(0xFF323d4f)),
                      title: Text(
                        "Ride #${index + 1}",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: width / 22,
                        ),
                      ),
                      subtitle: Text(
                        "Earned: Rs ${(index + 1) * 100}",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w300,
                          fontSize: width / 25,
                        ),
                      ),
                      trailing: Text(
                        "Completed",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: width / 25,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: height * 0.02),

              // **🔹 Rider Button**
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF323d4f),
                  elevation: 4,
                  // ignore: deprecated_member_use
                  shadowColor: Colors.grey,
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.10, vertical: height * 0.015),
                ),
                child: Text(
                  "Rider",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: width / 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // **🔹 Button Widget**
  Widget _earningsButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: const Color(0xFF323d4f),
          fontWeight: FontWeight.bold, // Bold text
        ),
      ),
    );
  }

  // **🔹 Earnings Card Widget**
  Widget _earningsCard(String title, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            amount,
            style: GoogleFonts.poppins(
              color: const Color(0xFF323d4f),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
