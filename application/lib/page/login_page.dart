import 'package:flutter/material.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controller สำหรับรับค่าจาก TextField
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ฟังก์ชันสำหรับตรวจสอบการยืนยันตัวตน
  // Future<void> _login() async {
  //   String username = _usernameController.text;
  //   String password = _passwordController.text;

  //   // ตรวจสอบว่า username หรือ password ว่างหรือไม่
  //   if (username.isEmpty || password.isEmpty) {
  //     _showDialog('กรุณากรอกข้อมูลให้ครบถ้วน');
  //   } else {
  //     try {
  //       // ส่งคำขอ POST ไปยัง API เพื่อตรวจสอบ username และ password
  //       final response = await http.post(
  //         Uri.parse('${AppConfig.baseUrl}/login'), // URL ของ API สำหรับ login
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode({
  //           'username': username, // คีย์ที่ตรงกับ API
  //           'password': password, // คีย์ที่ตรงกับ API
  //         }),
  //       );
  //       print("Response body: ${response.body}");
  //       // ถ้าคำขอสำเร็จ
  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);

  //         if (data['message'] == 'Login successful') {
  //           // ถ้าการเข้าสู่ระบบสำเร็จ
  //           String token = data['token']; // ดึง JWT token ที่ได้รับจาก API

  //           // บันทึก token หรือใช้งาน token ตามที่ต้องการ
  //           _saveToken(token); // เรียกฟังก์ชันบันทึก token
  //           print('Success');
  //           _showDialog('เข้าสู่ระบบสำเร็จ!');
  //         } else {
  //           // ถ้าชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง
  //           _showDialog('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
  //         }
  //       } else {
  //         // ถ้าระบบเกิดข้อผิดพลาดในการเชื่อมต่อกับ API
  //         _showDialog('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์');
  //       }
  //     } catch (e) {
  //       // หากเกิดข้อผิดพลาดในการส่งคำขอ
  //       _showDialog('เกิดข้อผิดพลาด: ${e.toString()}');
  //     }
  //   }
  // }

  // // ฟังก์ชันสำหรับบันทึก JWT Token
  // Future<void> _saveToken(String token) async {
  //   print(
  //       'try to saved token',
  //   );
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     print(
  //       'try to saved token',
  //     ); // เพิ่มข้อความเพื่อยืนยันว่าได้บันทึกแล้ว
  //     await prefs.setString(
  //       'jwt_token',
  //       token,
  //     ); // บันทึก JWT token ลงใน SharedPreferences
  //     print(
  //       'Token saved successfully',
  //     ); // เพิ่มข้อความเพื่อยืนยันว่าได้บันทึกแล้ว
  //   } catch (e) {
  //     print('Error saving token: $e'); // หากเกิดข้อผิดพลาด
  //   }
  // }
  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // ตรวจสอบว่า username หรือ password ว่างหรือไม่
    if (username.isEmpty || password.isEmpty) {
      _showDialog('กรุณากรอกข้อมูลให้ครบถ้วน');
    } else {
      // ตัวอย่างการตรวจสอบการเข้าสู่ระบบโดยใช้ข้อมูลที่ตั้งไว้ภายในแอป
      if (username == 'testuser' && password == 'password123') {
        // ถ้าการเข้าสู่ระบบสำเร็จ
        _showDialog('เข้าสู่ระบบสำเร็จ!', isSuccess: true);
      } else {
        _showDialog('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
      }
    }
  }

  // ฟังก์ชันสำหรับแสดง AlertDialog
  void _showDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('ผลการตรวจสอบ'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด Dialog
                  if (isSuccess) {
                    // ถ้าเข้าสู่ระบบสำเร็จ ไปยังหน้าถัดไป
                    Navigator.pushNamed(context, '/home');
                  }
                },
                child: Text('ตกลง'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF3C40C6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login', style: TextStyle(fontSize: 36, color: Colors.white)),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Enter your username',
                      hintStyle: const TextStyle(
                        color: Color(0xffDDDADA),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(
                        color: Color(0xffDDDADA),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'forget password?',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(' Click', style: TextStyle(color: Color(0xffFFFC3D))),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              width: 182,
              child: ElevatedButton(
                onPressed: _login, // Enable the button
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0BE881),
                  elevation: 8, // <-- this adds the shadow
                  shadowColor: Colors.black.withAlpha(
                    255,
                  ), // optional: control shadow color
                ),
                child: Text(
                  "Log in",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 50,
              width: 182,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 8, // <-- this adds the shadow
                  shadowColor: Colors.black.withAlpha(
                    255,
                  ), // optional: control shadow color
                ),
                // () => Navigator.push(context, '/register')
                child: Text(
                  "Back",
                  style: TextStyle(color: Color(0xFF3C40C6), fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
