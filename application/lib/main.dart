import 'package:flutter/material.dart';
import '/page/Welcome.dart';
import '/page/login_page.dart';
import '/page/register_page.dart';
import '/page/cart_page.dart';
import '/page/map_page.dart';


void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Demo',
      home: CartPage(),
    );
  }
}
