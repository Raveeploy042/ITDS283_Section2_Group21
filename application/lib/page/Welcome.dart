import 'package:flutter/material.dart';

class Welcome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  }, // Enable the button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
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
                  onPressed: (){
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 8, // <-- this adds the shadow
                    shadowColor: Colors.black.withAlpha(255), // optional: control shadow color
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
    );
  }
}