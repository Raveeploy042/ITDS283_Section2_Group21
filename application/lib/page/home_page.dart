import 'package:flutter/material.dart';
import '/material/custom_appbar.dart';
import '/material/bottom_navbar.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/page/detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _products = [];
  int? staffId;
  String _statusMessage = "";

  Future<void> _createOrUpdateOrder(int productId, int quantity) async {
    // 1. เช็คว่ามี order ที่สถานะ "still in cart" หรือไม่
    try {
      final url = Uri.parse(
        "${AppConfig.baseUrl}/orders",
      ); // ใช้ API ของคุณในการดึง order ที่ยังค้าง
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> orders = json.decode(response.body);
        // ค้นหา order ที่ยังค้างอยู่ใน cart
        final inCartOrder = orders.firstWhere(
          (order) => order['Status'] == 'still in cart',
          orElse: () => null,
        );
        print(inCartOrder);

        if (inCartOrder != null) {
          // ถ้ามี order ที่ยังค้างอยู่ใน cart, เพิ่ม item ลงใน order
          print('Found existing order, adding item...');
          await _addItemToOrder(inCartOrder['OrderID'], productId, quantity);
        } else {
          // ถ้าไม่มี order ที่ยังค้าง, สร้าง order ใหม่
          print('No existing order found, creating new order...');

          await _createNewOrder(productId, quantity);
        }
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  Future<void> _addItemToOrder(int orderId, int productId, int quantity) async {
    // เพิ่ม product item ลงใน order ที่มีอยู่แล้ว
    final url = Uri.parse("${AppConfig.baseUrl}/order_items");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'OrderID': orderId,
        'ProductID': productId,
        'Quantity': quantity,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _statusMessage = 'Product added to existing order successfully';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เพิ่มสินค้าลงตะกร้าเรียบร้อยแล้ว!'),
            duration: Duration(seconds: 1),
          ),
        );
      });
    } else {
      setState(() {
        _statusMessage = 'Failed to add item to order';
      });
    }
  }

  Future<void> _createNewOrder(int productId, int quantity) async {
    // สร้าง order ใหม่
    final url = Uri.parse("${AppConfig.baseUrl}/orders");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'status':
            'still in cart', // ตั้งสถานะเป็น 'still in cart' สำหรับ order ใหม่
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> newOrder = json.decode(response.body);
      // เพิ่ม product item ลงใน order ใหม่
      await _addItemToOrder(newOrder['OrderID'], productId, quantity);
    } else {
      setState(() {
        _statusMessage = 'Failed to create new order';
      });
    }
  }

  Future<void> _fetchProduct() async {
    final url = Uri.parse("${AppConfig.baseUrl}/products");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data;
          _statusMessage = "Loaded ${data.length} product.";
        });
        print('fetch product success');
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

  // ฟังก์ชันสำหรับดึง JWT token และ decode ข้อมูล
  // Future<void> _loadStaffId() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('jwt_token');

  //   if (token != null) {
  //     // Decode JWT token
  //     Map<String, dynamic> payload = Jwt.parseJwt(token);
  //     setState(() {
  //       staffId = payload['staff_id']; // ดึง staff_id จาก JWT token
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _fetchProduct();
    // _loadStaffId();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                    child: Container(
                      padding: EdgeInsets.all(11),
                      width: 170,
                      height: 74,
                      decoration: BoxDecoration(
                        color: Color(0xFF3C40C6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'รายการสินค้า',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                'ในรถเข็น',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/history'),
                    child: Container(
                      width: 170,
                      height: 74,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF3C40C6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        spacing: 0,
                        children: [
                          Text(
                            'ประวัติคำสั่งซื้อ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'สินค้าแนะนำ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    // ดึงข้อมูลจาก products object
                    var product = _products[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Container(
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(255),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // เงาแนวตั้ง
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // แสดงรูปภาพ
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailPage(
                                          id: product['productID'],
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 100,
                                color: Colors.white,
                                child:
                                    product['ImageURL'] != null
                                        ? Image.network(
                                          product['ImageURL'],
                                        ) // แสดงภาพจาก URL
                                        : const Icon(
                                          Icons.image,
                                          size: 92,
                                        ), // ถ้าไม่มีรูป ให้แสดง icon แทน
                              ),
                            ),
                            const SizedBox(height: 2),
                            // แสดงชื่อสินค้า
                            Text(
                              product['ProductName'],
                              maxLines: 1, // จำกัดให้แสดงแค่ 1 บรรทัด
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            // แสดงราคา
                            Row(
                              spacing: 3,
                              children: [
                                Text(
                                  '${(product['Price'] + '/' + product['Unit']).substring(0, 10)}...',
                                  style: TextStyle(
                                    color: Color(0xFF3700FF),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    int productId = product['productID'];
                                    int quantity = 1;
                                    _createOrUpdateOrder(productId, quantity);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFD9D9D9),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.add_shopping_cart,
                                      color: Color(0xFF3C40C6),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'ประเภทสินค้า',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Column(
                spacing: 15,
                children: [
                  InkWell(
                    onTap: () {
                      print("คลิกที่รูปภาพ!");
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/Cement_type.png',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("คลิกที่รูปภาพ!");
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/Steel_type.png',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: 0, // index ของ 'Home' จาก BottomNavigationBarItem
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              Navigator.pushNamed(context, '/cart');
              break;
            case 3:
              Navigator.pushNamed(context, '/history');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
