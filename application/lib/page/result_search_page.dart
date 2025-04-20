import 'package:flutter/material.dart';

class ResultSearchPage extends StatelessWidget{
  const ResultSearchPage ({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF3C40C6), size: 30),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
          },
        ),
        title: TextField(
          decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF3C40C6),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3C40C6)),
                  borderRadius: BorderRadius.circular(30))),
        ),
        ),
      ),
    );
  }
}