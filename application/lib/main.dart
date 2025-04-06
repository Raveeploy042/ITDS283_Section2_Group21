import 'package:flutter/material.dart';
import '/page/Welcome.dart';
import '/page/login_page.dart';
import 'package:application/page/cart_page.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index; // อัปเดตหน้าที่เลือก
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (context) => Welcome(),
        '/login': (context) => LoginPage(),
        // '/register': (context) => null,
        // '/page3': (context) => Page3(),
        // '/page4': (context) => Page4(),
        // '/page5': (context) => Page5(),
      },
    );
  }
}
