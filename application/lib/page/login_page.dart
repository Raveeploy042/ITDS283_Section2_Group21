import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        backgroundColor: Color(0xFF3C40C6) ,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
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
                    backgroundColor: Color(0xFF0BE881),
                    elevation: 8, // <-- this adds the shadow
                    shadowColor: Colors.black.withAlpha(255), // optional: control shadow color
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
                    elevation: 8, // <-- this adds the shadow
                    shadowColor: Colors.black.withAlpha(255), // optional: control shadow color
                  ),
                  // () => Navigator.push(context, '/register')
                  child: Text(
                    "Back",
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
