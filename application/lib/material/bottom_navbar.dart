import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(      
      backgroundColor: Color(0xFF3C40C6),
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,        // สีของ tab ที่เลือกอยู่
      unselectedItemColor: Colors.grey,    // สีของ tab ที่ไม่ได้เลือก
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'cart'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      
    );
  }
}
