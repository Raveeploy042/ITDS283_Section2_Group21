import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
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
        backgroundColor: Color(0xFF3C40C6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 36, color: Colors.white),
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: TextField(
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
                  onPressed: () {}, // Enable the button
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
                  onPressed: () {},
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
      ),
    );
  }
}
