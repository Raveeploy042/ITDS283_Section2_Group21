import 'package:flutter/material.dart';
import '/material/bottom_navbar.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/page/detail_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> items = ['ปูนซีเมนต์', 'เหล็กเส้น', 'อิฐมวลเบา', 'ทราย'];
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _products = [];
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

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF3C40C6), size: 30),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
          },
        ),
        title: TextField(
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search, color: Color(0xFF3C40C6)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF3C40C6)),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          controller: _searchController,
          onSubmitted: null,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length + 1,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    return ListTile(title: Text(items[index]));
                  } else {
                    return Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'แสดงเพิ่มเติม',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            recommandProduct(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: 1, // index ของ 'Home' จาก BottomNavigationBarItem
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
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

  Padding recommandProduct() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: _products.isEmpty
        ? Center(child: Text('ไม่พบข้อมูลสินค้า'))
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              var product = _products[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // ✅ รูปภาพสินค้า
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                id: product['productID'],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: product['ImageURL'] != null
                                ? Image.network(
                                    product['ImageURL'],
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, size: 64),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ✅ ชื่อสินค้า + ราคา + ปุ่ม
                      Expanded(
                        child: Stack(
                          children: [
                            // ✅ ชื่อสินค้าและราคาอยู่ชิดซ้าย
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['ProductName'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${product['Price']}฿ / ${product['Unit']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF3700FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // ✅ ปุ่มตะกร้าอยู่มุมขวาล่าง
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  int productId = product['productID'];
                                  _createOrUpdateOrder(productId, 1);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product['ProductName']} added to cart!',
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
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
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}
}