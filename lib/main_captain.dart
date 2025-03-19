import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Resources/theme.dart';
import 'Views/Driver/driver_ride_history_screen.dart';

void main() {
  runApp(const VroomCaptainApp());
}

class VroomCaptainApp extends StatelessWidget {
  const VroomCaptainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vroom Captain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.primaryBlue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const DriverRideHistoryScreen(),
    );
  }
}
