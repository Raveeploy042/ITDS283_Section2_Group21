import 'package:flutter/material.dart';

class ResultSearchPage extends StatelessWidget {
  const ResultSearchPage({super.key});

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
              suffixIcon: Icon(Icons.filter, color: Color(0xFF3C40C6)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3C40C6)),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 87,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF3C40C6)
                  ),
                  child: Text(
                    'เกี่ยวข้อง',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 87,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF3C40C6)
                  ),
                  child: Text(
                    'แนะนำ',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 87,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF3C40C6)
                  ),
                  child: Text(
                    'สินค้าล่าสุด',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 87,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF3C40C6)
                  ),
                  child: Text(
                    'ราคา',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
