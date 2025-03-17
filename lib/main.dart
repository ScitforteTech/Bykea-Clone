import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vroom_ride_app/Views/Driver/driver_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:vroom_ride_app/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    // Continue without Firebase for now
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vroom Driver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(context),
      home: const SplashScreen(), // Show splash screen first
    );
  }
}
