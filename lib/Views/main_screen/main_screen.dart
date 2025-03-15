import 'package:flutter/material.dart';
import 'package:vroom_ride_app/Views/main_screen/activity/main_activity.dart';
import 'package:vroom_ride_app/Views/main_screen/home/main_home.dart';
import 'package:vroom_ride_app/Views/main_screen/profile/main_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MainHome(),
    const MainActivity(),
    const MainProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png', height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/activity.png', height: 24),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/user.png', height: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
