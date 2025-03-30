import 'package:flutter/material.dart';
import 'package:project_mobile/main.dart';
import 'login_page.dart';
import 'register_page.dart';
void main(List<String> args) {
  runApp(Welcome());
}

class Welcome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Page',
      home: Scaffold(
        backgroundColor: Color(0xFF3C40C6) ,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white
                ),),
              SizedBox(height: 30),
              Container(
                height: 70,
                width: 233,
                child: ElevatedButton(
                  onPressed: () {}, // Enable the button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      color: Color(0xFF3C40C6),
                      fontSize:24 ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height:70,
                width: 233,
                child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  // () => Navigator.push(context, '/register')
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Color(0xFF3C40C6),
                      fontSize:24 ),),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}