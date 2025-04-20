import 'package:flutter/material.dart';
import '/page/map_page.dart';
import '/page/invoice_page.dart';
import '/material/bottom_navbar.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _customerNameController = TextEditingController();
  String? _deliveryAddress;
  String _deliveryOption = 'pickup';

  List<dynamic> orderItems = [];
  String _statusMessage = "";
  Map<String, dynamic>? orderInCart;

  Future<void> _deleteOrderItem(int itemId) async {
    final url = Uri.parse("${AppConfig.baseUrl}/order_items/$itemId");
    await http.delete(url);
  }

  Future<void> _confirmOrder() async {
    String customer = _customerNameController.text;
    if (customer.isEmpty) {
      customer = "ชื่อลูกค้า";
    }
    if (orderInCart == null) return;

    final url = Uri.parse(
      "${AppConfig.baseUrl}/orders/${orderInCart!['OrderID']}",
    );

    final Map<String, dynamic> updatedOrder = {
      'CustomerName': customer,
      'Status': 'confirmed',
      'transport': _deliveryOption,
      'Address': _deliveryAddress ?? '',
    };
    print('----------------------------------');
    print('updatedOrder : $updatedOrder');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedOrder),
      );

      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ยืนยันคำสั่งซื้อเรียบร้อยแล้ว')),
          );
        });
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InvoicePage(orderId: orderInCart!['OrderID'])),
        );
        }
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: ${response.statusCode}')),
          );
        });
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Exception: $e')));
      });
    }
  }

  Future<void> _cancelOrder() async {
    if (orderInCart == null) return;

    final url = Uri.parse(
      "${AppConfig.baseUrl}/orders/${orderInCart!['OrderID']}",
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          orderInCart = null;
          orderItems.clear();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('ยกเลิกรายการสำเร็จ')));
        });
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ลบไม่สำเร็จ: ${response.statusCode}')),
          );
        });
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Exception: $e')));
      });
    }
  }

  Future<void> _fetchOrderItems() async {
    try {
      // ส่งคำขอ GET เพื่อดึงรายการสินค้าใน order
      final url = Uri.parse("${AppConfig.baseUrl}/orders");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> orders = json.decode(response.body);
        print('Response body: ${response.body}');
        // ค้นหา order ที่มีสถานะ still in cart
        final inCartOrder = orders.firstWhere(
          (order) => order['Status'] == 'still in cart',
          orElse: () => null,
        );
        print(inCartOrder);
        setState(() {
          orderInCart = inCartOrder;
          if (inCartOrder != null && inCartOrder['CustomerName'] != null) {
            _customerNameController.text = inCartOrder['CustomerName'];
          }
        });
        if (inCartOrder != null) {
          // ดึง order items จาก order ที่มีสถานะ still in cart
          final orderItemsResponse = await http.get(
            Uri.parse(
              "${AppConfig.baseUrl}/order_items/${inCartOrder['OrderID']}",
            ),
          );
          print(inCartOrder);

          if (orderItemsResponse.statusCode == 200) {
            setState(() {
              orderItems = json.decode(orderItemsResponse.body);
            });
            print(orderItems);
          } else {
            setState(() {
              _statusMessage = "Error: ${orderItemsResponse.statusCode}";
            });
          }
        } else {
          setState(() {
            _statusMessage = "No order in cart";
          });
        }
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
    print(_statusMessage);
  }

  double itemPrice(dynamic inputPrice, dynamic inputQuantity) {
    double price = double.tryParse(inputPrice) ?? 0.0;
    int quantity = inputQuantity ?? 0;
    return price * quantity;
  }

  double get _totalPrice {
    return orderItems.fold(0, (sum, item) {
      double price = double.tryParse(item['Price'].toString()) ?? 0.0;
      double quantity = double.tryParse(item['Quantity'].toString()) ?? 0;
      return sum + (price * quantity);
    });
  }

  void increaseQty(int index) {
    setState(() {
      orderItems[index]['Quantity']++;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (orderItems[index]['Quantity'] > 1) {
        orderItems[index]['Quantity']--;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderItems(); // เรียกใช้ฟังก์ชันเมื่อหน้าโหลด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 40,
            color: Color(0xFF3C40C6),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'รายการสินค้าในรถเข็น',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = orderItems[index];
                print(item);
                return Container(
                  width: 372,
                  height: 132,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3C40C6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            item['ImageURL'] != null
                                ? Image.network(
                                  item['ImageURL'],
                                ) // แสดงภาพจาก URL
                                : const Icon(
                                  Icons.image,
                                  size: 92,
                                ), // ถ้าไม่มีรูป ให้แสดง icon แทน
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['ProductName'].length > 10
                                  ? '${item['ProductName'].substring(0, 10)}...'
                                  : item['ProductName'], // ถ้ามีมากกว่า 10 ตัวอักษรให้แสดงแค่ 10 ตัวและเพิ่ม '...'
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item['ProductName'].length > 10
                                  ? '${item['ProductName'].substring(item['ProductName'].length - 10)}...'
                                  : item['ProductName'], // ถ้ามีมากกว่า 10 ตัวอักษรให้แสดง 10 ตัวสุดท้ายและเพิ่ม '...'
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${item['Price']}฿/ถุง',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'จำนวน',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => decreaseQty(index),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item['Quantity']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => increaseQty(index),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('ยืนยันการลบรายการ'),
                                      content: const Text(
                                        'คุณแน่ใจหรือไม่ว่าต้องการยกเลิกรายการทั้งหมด?',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('ยกเลิก'),
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pop(); // ปิด dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('ยืนยัน'),
                                          onPressed: () async {
                                            Navigator.of(
                                              context,
                                            ).pop(); // ปิด dialog
                                            await _deleteOrderItem(
                                              item['OrderItemID'],
                                            );
                                            setState(() {
                                              orderItems.removeAt(index);
                                            }); // เรียกฟังก์ชันลบ
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 42,
              width: 240,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      'ชื่อลูกค้า : ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(),
                        child: TextField(
                          controller: _customerNameController,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ประเภทการจัดส่ง',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: const Text('รับสินค้าที่หน้าร้าน'),
              value: 'pickup',
              groupValue: _deliveryOption,
              onChanged:
                  (value) => setState(() => _deliveryOption = value.toString()),
            ),
            RadioListTile(
              title: const Text('บริการจัดส่งสินค้า'),
              value: 'delivery',
              groupValue: _deliveryOption,
              onChanged: (value) async {
                setState(() => _deliveryOption = value.toString());
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
                if (result != null && result is String) {
                  setState(() => _deliveryAddress = result);
                }
              },
            ),
            if (_deliveryOption == 'delivery' && _deliveryAddress != null)
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                    if (result != null && result is String) {
                      setState(() => _deliveryAddress = result);
                    }
                  },
                  child: Text('สถานที่: $_deliveryAddress'),
                ),
              ),
            const SizedBox(height: 20),
            Container(
              color: const Color(0xFF3C40C6),
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สินค้ารวม ${orderItems.length} รายการ',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'สินค้า',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'ราคา',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...orderItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${item['Quantity']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              item['ProductName'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${itemPrice(item['Price'], item['Quantity'])} ฿',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'รวมทั้งหมด: $_totalPrice บาท',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ยืนยันการลบรายการ'),
                            content: const Text(
                              'คุณแน่ใจหรือไม่ว่าต้องการยกเลิกรายการทั้งหมด?',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('ยกเลิก'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // ปิด dialog
                                },
                              ),
                              TextButton(
                                child: const Text('ยืนยัน'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // ปิด dialog
                                  _cancelOrder(); // เรียกฟังก์ชันลบ
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('ยกเลิกรายการทั้งหมด'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.black.withAlpha(255),
                      backgroundColor: const Color(0xFF0BE881),
                    ),
                    onPressed: _confirmOrder,
                    child: const Text('ยืนยันคำสั่งซื้อ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: 2, // index ของ 'cart' จาก BottomNavigationBarItem
        onTap: (index) {
          if (index == 2) return; // อยู่ที่หน้า cart แล้ว ไม่ต้องทำอะไร
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/search');
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
