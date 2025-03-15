import 'package:flutter/material.dart';
import 'package:vroom_ride_app/Views/main_screen/activity/Active.dart';
import 'package:vroom_ride_app/Views/main_screen/activity/Cancel.dart';
import 'package:vroom_ride_app/Views/main_screen/activity/Complete.dart';
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
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/search.png')),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/settings.png')),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Center(
              child: Text(
                'Activities',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            _buildTab(0, 'Active', Colors.green),
            _buildTab(1, 'Complete', Colors.green),
            _buildTab(2, 'Cancel', Colors.green),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Active(),
          Complete(),
          Cancel(),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String text, Color color) {
    return Tab(
      child: SizedBox(
        width: 230,
        height: 60,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _tabController.index == index ? color : Colors.transparent,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _tabController.index == index ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
