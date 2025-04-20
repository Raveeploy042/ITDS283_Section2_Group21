import 'package:flutter/material.dart';
import '/material/custom_appbar.dart';
import '/material/bottom_navbar.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final int id ;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;

  void increaseQty() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQty() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }
  
  List<dynamic> _products = [];
  String _statusMessage = "";

  Future<void> _fetchProducts(int productid) async {
    final id = productid;
    print(id);
    final url = Uri.parse("${AppConfig.baseUrl}/products/$id");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data;
          _statusMessage = "Loaded ${data.length} products.";
        });
      } else {
        setState(() {
          _statusMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Exception: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts(widget.id);  // เรียกใช้ _fetchProducts เมื่อเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(Icons.arrow_back, color: Color(0xFF3C40C6), size: 32),
          title: const Text(
            'รายละเอียดสินค้า',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ถ้า _products ว่างให้แสดง CircularProgressIndicator
              _products.isEmpty
                  ? Center(child: CircularProgressIndicator())  // แสดง loader
                  : Column(
                      children: [
                        SizedBox(height: 30),
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(4, 6),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _products[0]['ImageURL'] != null
                                  ? Image.network(_products[0]['ImageURL']) // แสดงภาพจาก URL
                                  : const Icon(Icons.image, size: 100, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 363,
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(4, 6),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8, right: 12),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'รหัสสินค้า : ${_products[0]['productID']}',
                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                color: Color(0xFF3C40C6),
                                child: Text(
                                  'ชื่อ :  ${_products[0]['ProductName']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ประเภท : ${_products[0]['Type']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'ยี่ห้อ : ${_products[0]['Brand']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 20),
                                        SizedBox(width: 6),
                                        Text(
                                          'Location : ${_products[0]['Location']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        'ราคา ${_products[0]['Price']}฿ / ${_products[0]['Unit']}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'จำนวน',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    // ปุ่มลบ
                    GestureDetector(
                      onTap: decreaseQty,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.remove, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$quantity',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: increaseQty,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[400],
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'เพิ่มลงในรถเข็น',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavBar(
          currentIndex: 0, // index ของ 'Home' จาก BottomNavigationBarItem
          onTap: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/search');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/cart');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          },
        ),
      ),
    );
  }
}
