import 'package:flutter/material.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InvoicePage extends StatefulWidget {
  final int orderId;
  const InvoicePage({super.key, required this.orderId});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  Map<String, dynamic>? orderData;
  List<dynamic> orderItems = [];
  bool isLoading = true;

  Future<void> _cancelOrder() async {
    if (orderData == null) return;

    final url = Uri.parse(
      "${AppConfig.baseUrl}/orders/${orderData!['OrderID']}",
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          orderData = null;
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

  Future<void> _fetchOrderDetails() async {
    try {
      final orderRes = await http.get(
        Uri.parse('${AppConfig.baseUrl}/orders/${widget.orderId}'),
      );
      final itemsRes = await http.get(
        Uri.parse('${AppConfig.baseUrl}/order_items/${widget.orderId}'),
      );

      if (orderRes.statusCode == 200 && itemsRes.statusCode == 200) {
        setState(() {
          orderData = json.decode(orderRes.body);
          orderItems = json.decode(itemsRes.body);
          isLoading = false;
        });
      } else {
        throw Exception('โหลดข้อมูลไม่สำเร็จ');
      }
    } catch (e) {
      print("❗️ Error: $e");
    }
  }

  double get totalPrice {
    return orderItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item['Price'].toString()) ?? 0.0;
      final qty = int.tryParse(item['Quantity'].toString()) ?? 0;
      return sum + (price * qty);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Color(0xFF3C40C6), size: 40),
          ),
          title: Text(
            'ใบสรุปคำสั่งซื้อ',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [IconButton(onPressed: () {
            orderData!['Status'] = 'still in cart';
            Navigator.pop(context);
          }, icon: Icon(Icons.create))],
        ),
        body:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Container(
                      color: Color(0xFF3C40C6),
                      width: 380,
                      height: 637,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ชื่อลูกค้า: ${orderData?['CustomerName'] ?? '-'}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'ประเภทการจัดส่ง: ${orderData?['transport'] == 'pickup' ? 'รับเองที่หน้าร้าน' : 'บริการจัดส่งสินค้า'}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'สินค้ารวม ${orderItems.length} รายการ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'จำนวน',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'สินค้า',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'ราคา',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...orderItems.map((item) {
                            final qty = item['Quantity'].toString();
                            final name = item['ProductName'] ?? '';
                            final price =
                                double.tryParse(item['Price'].toString()) ??
                                0.0;
                            final total = (price * (int.tryParse(qty) ?? 0))
                                .toStringAsFixed(2);
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      qty,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      total,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'ยอดรวม',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 25),
                                Text(
                                  '${totalPrice.toStringAsFixed(2)}฿',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
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
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // ปิด dialog
                                        _cancelOrder(); // เรียกฟังก์ชันลบ
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(154, 53),
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF0000),
                          ),
                          child: Text(
                            'ยกเลิกคำสั่งซื้อ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(154, 53),
                            foregroundColor: Colors.black,
                            backgroundColor: Color(0xFF0BE881),
                            side: BorderSide(color: Color(0xFF0BE881)),
                          ),
                          child: Text(
                            'กลับสู่หน้าหลัก',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
