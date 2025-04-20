// main_screen.dart

import 'package:flutter/material.dart';
import '/page/home_page.dart';
// import '/page/search_page.dart';
import '/page/cart_page.dart';
import '/page/list_history.dart';
import '/page/profile_page.dart';
import '/material/bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens =  [
    HomePage(),
    CartPage(),
    ListHistory(),
    // ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
