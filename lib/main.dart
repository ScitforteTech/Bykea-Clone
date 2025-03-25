import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vroom_ride_app/Views/Rider/rider_dashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/splashScreen.dart';
import 'package:vroom_ride_app/Views/auth_screen/login_screen.dart';
import 'package:vroom_ride_app/Views/Rider/auth_choice_screen.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAkjDMjkWS-yEryQpfyVC4oZtTb_ZaZesk",
          appId: "1:202483868529:android:64e7ace3888c0bbdcd4cd0",
          messagingSenderId: "202483868529",
          projectId: "vr-r-9e995"),
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );

    // Set default locale
    Get.updateLocale(const Locale('en', 'US'));

    runApp(const MyApp());
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    // Still run the app, but it will show appropriate error UI
    Get.updateLocale(const Locale('en', 'US'));
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vroom Ride',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF323d4f)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: const Color(0xFF323d4f),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF323d4f),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth_choice': (context) => const AuthChoiceScreen(),
        '/login': (context) => const loginScreen(),
      },
    );
  }
}
