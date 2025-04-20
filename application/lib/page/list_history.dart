import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/page/invoice_page.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/material/bottom_navbar.dart';

class ListHistory extends StatefulWidget {
  @override
  State<ListHistory> createState() => _ListHistoryState();
}

class _ListHistoryState extends State<ListHistory> {

  List<Map<String, dynamic>> groupedOrders = [];
  String _statusMessage = "";

  Future<void> _fetchOrderItems() async {
    try {
      final url = Uri.parse("${AppConfig.baseUrl}/orders");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> orders = json.decode(response.body);
        print('orders : $orders');
        // กรองเฉพาะที่ status ยืนยันแล้ว
        final confirmedOrders =
            orders.where((o) => o['Status'] != 'still in cart').toList();

        // แปลงเป็นกลุ่มตามวัน
        print('confirmedOrders : $confirmedOrders');
        Map<String, List<Map<String, dynamic>>> grouped = {};
        for (var order in confirmedOrders) {
          final date = DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(order['OrderDate']));
          grouped[date] = [...(grouped[date] ?? []), order];
        }
        print('grouped $grouped');

        // แปลงเป็น list
        List<Map<String, dynamic>> groupedList =
            grouped.entries.map((entry) {
              return {'date': DateTime.parse(entry.key), 'orders': entry.value};
            }).toList();

        // เรียงจากวันที่ใหม่สุด
        groupedList.sort((a, b) => b['date'].compareTo(a['date']));

        setState(() {
          groupedOrders = groupedList;
          print('groupedOrders :$groupedOrders');
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

  // final List<Map<String, dynamic>> _orders = [
  //   {
  //     'date': DateTime.now(),
  //     'orders': [
  //       {
  //         'orderNo': '0307001',
  //         'customer': 'คุณทฤษฎี',
  //         'deliveryUser': 'จีนเอฟพื้นนิริน',
  //         'itemCount': 3,
  //         'products': [
  //           'ผู้แทนโครงสร้าง SCG... (2)',
  //           'เหล็กเส้นกลม... (1)',
  //           'อิฐมวล... (10)',
  //         ],
  //         'total': 735.00,
  //       },
  //     ],
  //   },
  //   {
  //     'date': DateTime(2023, 7, 15),
  //     'orders': [
  //       {
  //         'orderNo': '0306012',
  //         'customer': 'คุณเสือ',
  //         'deliveryUser': 'จีนเอฟพื้นนิริน',
  //         'itemCount': 2,
  //         'products': ['ผู้แทนโครงสร้าง SCG... (1)', 'อิฐมวล... (5)'],
  //         'total': 270.00,
  //       },
  //       {
  //         'orderNo': '0306011',
  //         'customer': 'คุณแอร์',
  //         'deliveryUser': 'จีนเอฟพื้นนิริน',
  //         'itemCount': 2,
  //         'products': ['อิฐมวลเขา สะพงพร... (10)', 'เหล็กเล่นกลบ... (2)'],
  //         'total': 420.00,
  //       },
  //       {
  //         'orderNo': '0306010',
  //         'customer': 'คุณกิจากร',
  //         'deliveryUser': 'จีนเอฟพื้นนิริน',
  //         'itemCount': 6,
  //         'products': ['เหล็กเล่นกลบ... (2)', 'ปูนโครงสร้าง... (4)'],
  //         'total': 980.00,
  //       },
  //     ],
  //   },
  // ];
  String transport_type (String transport){
    if(transport == 'pickup'){
      return "รับสินค้าที่หน้าร้าน";
    }else{
      return "บริการจัดส่งสินค้า";
    }
  }
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDate = DateTime(date.year, date.month, date.day);

    return orderDate == today
        ? 'วันนี้: ${DateFormat('dd/MM/yyyy').format(date)}'
        : DateFormat('dd/MM/yyyy').format(date);
  }
  @override
  void initState() {
    super.initState();
    _fetchOrderItems(); // เรียกใช้ฟังก์ชันเมื่อหน้าโหลด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ประวัติคำสั่งซื้อ'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Container(
                height: 45,
                width: 313,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    hintText: 'Search history',
                    hintStyle: const TextStyle(
                      color: Color(0xffDDDADA),
                      fontSize: 14,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Future: implement search filter
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Order list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: groupedOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final dateGroup = groupedOrders[index];
                print('Date Group : $dateGroup');
                final orders = dateGroup['orders'] as List;
                print('orders : $orders');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(dateGroup['date']),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...dateGroup['orders'].map<Widget>((order) {
                      return Card(
                        color: Color(0xFF3C40C6),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            // TODO: push to order detail page
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 124,
                                  width: 124,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/Team01.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Order No. ${order['OrderID']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'ชื่อลูกค้า : ${order['CustomerName']}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'ประเภทการจัดส่ง : ${transport_type(order['transport'])}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'จำนวนสินค้า ${order.length} รายการ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      ...order['products']
                                          .take(2)
                                          .map<Widget>(
                                            (p) => Text(
                                              '• $p',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      if (order['products'].length > 2)
                                        const Text(
                                          '• ...',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'ยอดรวม',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '${order['total'].toStringAsFixed(2)}฿',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          Center(
            child: Container(
              height: 40,
              padding: EdgeInsets.all(10),
              child: Text(
                'กดที่ใบคำสั่งซื้อเพื่อดูรายละเอียด',
                style: TextStyle(fontFamily: 'Inter', fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: 3, // index ของ 'Home' จาก BottomNavigationBarItem
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/search');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 3:
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
