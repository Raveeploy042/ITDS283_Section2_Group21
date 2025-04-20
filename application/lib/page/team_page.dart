import 'package:flutter/material.dart';
import '/material/custom_appbar.dart';
import '/material/bottom_navbar.dart';

void main(List<String> args) {
  runApp(TeamPage());
}

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Our Team',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                )
              ),
              SizedBox(height: 20),
              CircleAvatar(
                backgroundImage: AssetImage('assets/Team01.jpg'),
                radius: 95,
              ),
              SizedBox(height: 10),
              Text(
                'Raveeploy Charoenchaiprakij',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black
                )
              ),
              Text(
                'Email: raveeploy.cha@student.mahidol.edu',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black
                )
              ),
              SizedBox(height: 30),
              CircleAvatar(
                backgroundImage: AssetImage('assets/Team02.jpg'),
                radius: 95,
              ),
              SizedBox(height: 10),
              Text(
                'Arisa Asavadechvudthikul',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              Text(
                'Email: arisa.asa@student.mahidol.edu',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black
                )
              ),
              SizedBox(height: 40),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFFD9D9D9),
                  side: BorderSide(
                    color: Color(0xFFD9D9D9)),
                ),
                child:
                 
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text(
                    'กลับสู่หน้าหลัก',
                    style: 
                    TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              )
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavBar(
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
      )
    );
  }
}