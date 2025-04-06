import 'package:flutter/material.dart';
void main(List<String> args) {
  runApp(Register());
}
class Register extends StatefulWidget{
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Page',
      home: Scaffold(
        backgroundColor: Color(0xFF3C40C6) ,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
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
                    "Register",
                    style: TextStyle(
                      color: Colors.black,
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