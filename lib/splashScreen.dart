import 'package:flutter/material.dart';
import 'package:vroom_ride_app/Views/Rider/rider_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((val) =>
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const RiderDashboardScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/SPLASH SCREEN.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
