import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vroom_ride_app/Views/Driver/driver_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:vroom_ride_app/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAsFcuiK4gVBbdt5tuCXgTSpkJY9OoKKh4",
        appId: "1:465912341384:android:0ebe1ffd8c66db75c2d03d",
        messagingSenderId: "465912341384",
        projectId: "vr-d-b6c10",
        storageBucket: "vr-d-b6c10.firebasestorage.app",
      ),
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
    rethrow; // We should fail if Firebase isn't initialized
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
