import 'package:flutter/material.dart';
import '/page/cart_page.dart';
import '/page/home_page.dart';
import '/page/invoice_page.dart';
import '/page/list_history.dart';
import '/page/loading_page.dart'; 
import '/page/login_page.dart';
import '/page/main_screen.dart';
import '/page/map_page.dart';
import '/page/profile_page.dart';
import '/page/register_page.dart';
import '/page/team_page.dart';
import '/page/Welcome.dart';
import '/page/search_page.dart';

void main(List<String> args) async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สมบุญพาณิชย์',
      initialRoute: '/', // ✅ เปลี่ยนเป็น route-based
      routes: {
        '/': (context) => LoadingPage(), // ✅ เริ่มที่ loading page
        '/main' : (context) => MainScreen(),
        '/cart': (context) => CartPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/search' : (context) => SearchPage(),
        '/map': (context) => MapPage(),
        '/invoice': (context) => InvoicePage(),
        '/history': (context) => ListHistory(),
        '/profile': (context) => ProfilePage(),
        '/team': (context) => TeamPage(),
        '/welcome': (context) => Welcome(),
      },
    );
  }
}
