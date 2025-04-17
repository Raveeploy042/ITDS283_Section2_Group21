import 'dart:async';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String loadingText = "loading";
  int dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // เริ่ม Animation จุด
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // จำนวนจุด: 0, 1, 2, 3 แล้ววน
        loadingText = "loading${"." * dotCount}";
      });
    });

    // หลังจาก 3 วินาที เปลี่ยนหน้าไปที่ WelcomePage
    Timer(Duration(seconds: 3), () {
      // ใช้ pushReplacementNamed เพื่อเปลี่ยนหน้าและไม่ให้กลับไปที่ LoadingPage
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // หยุด timer เมื่อปิดหน้านี้
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C40C6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "สมบุญ",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "พาณิชย์",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 100),
            Align(
              alignment: Alignment.bottomCenter, // จัดตำแหน่งให้ข้อความอยู่ที่ด้านล่าง
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30), // เพิ่มระยะห่างจากขอบล่าง
                child: Text(
                  loadingText,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
