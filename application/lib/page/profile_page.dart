import 'package:flutter/material.dart';
import '/material/custom_appbar.dart';
import '/material/bottom_navbar.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget{

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<dynamic> _staff = [];
  String _statusMessage = "";

  // Future<void> _fetchStaff(staffId) async {
  //   final id = staffId;
  //   final url = Uri.parse("${AppConfig.baseUrl}/products/$id");

  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //         _staff = data;
  //         _statusMessage = "Loaded ${data.length} staff.";
  //       });
  //     } else {
  //       setState(() {
  //         _statusMessage = "Error: ${response.statusCode}";
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _statusMessage = "Exception: $e";
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // _fetchStaff(widget.id);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8 , 30 ,8 ,8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Color(0xFF3C40C6),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 120,
                    )
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'คุณพนักงาน ดีเด่น',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    color: Color(0xFFD9D9D9),
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'username: Panakngan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xFFD9D9D9),
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        Text(
                          'password: ************',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xFFD9D9D9),
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'ตำแหน่ง: พนักงานขาย',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: Size(228,35),
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFFD9D9D9),
                      side: BorderSide(
                        color: Color(0xFFD9D9D9)),
                    ),
                    child: 
                    Text(
                      'กลับสู่หน้าหลัก',
                      style: 
                      TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/team');
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(228,35),
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFFD9D9D9),
                      side: BorderSide(
                        color: Color(0xFFD9D9D9)),
                    ),
                    child: Text(
                        'ติดต่อผู้พัฒนา',
                        style: 
                        TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  SizedBox(height: 40),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/welcome');
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(228,35),
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFFFF0000),
                      side: BorderSide(
                        color: Color(0xFFFF0000)),
                    ),
                    child: 
                    Text(
                      'Log out',
                      style: 
                      TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),bottomNavigationBar: MyBottomNavBar(
        currentIndex: 4, // index ของ 'Home' จาก BottomNavigationBarItem
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/search');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/history');
              break;
            case 4:
              break;
          }
        },
      ),
    );
  }
}