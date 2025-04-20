import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/page/home_page.dart';
import '/page/cart_page.dart';
import '/page/profile_page.dart';
import '/material/bottom_navbar.dart';

class ListHistory extends StatefulWidget {
  @override
  State<ListHistory> createState() => _ListHistoryState();
}

class _ListHistoryState extends State<ListHistory> {
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> _orders = [
    {
      'date': DateTime.now(),
      'orders': [
        {
          'orderNo': '0307001',
          'customer': 'คุณทฤษฎี',
          'deliveryUser': 'จีนเอฟพื้นนิริน',
          'itemCount': 3,
          'products': [
            'ปูนงานโครงสร้าง SCG... (2)',
            'เหล็กเส้นกลม... (1)',
            'อิฐมวล... (10)',
          ],
          'total': 735.00,
        },
      ],
    },
    {
      'date': DateTime(2023, 7, 15),
      'orders': [
        {
          'orderNo': '0306012',
          'customer': 'คุณเสือ',
          'deliveryUser': 'จีนเอฟพื้นนิริน',
          'itemCount': 2,
          'products': ['ผู้แทนโครงสร้าง SCG... (1)', 'อิฐมวล... (5)'],
          'total': 270.00,
        },
        {
          'orderNo': '0306011',
          'customer': 'คุณแอร์',
          'deliveryUser': 'จีนเอฟพื้นนิริน',
          'itemCount': 2,
          'products': ['อิฐมวลเขา สะพงพร... (10)', 'เหล็กเล่นกลบ... (2)'],
          'total': 420.00,
        },
        {
          'orderNo': '0306010',
          'customer': 'คุณกิจากร',
          'deliveryUser': 'จีนเอฟพื้นนิริน',
          'itemCount': 6,
          'products': ['เหล็กเล่นกลบ... (2)', 'ปูนโครงสร้าง... (4)'],
          'total': 980.00,
        },
      ],
    },
  ];

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDate = DateTime(date.year, date.month, date.day);

    return orderDate == today
        ? 'วันนี้: ${DateFormat('dd/MM/yyyy').format(date)}'
        : DateFormat('dd/MM/yyyy').format(date);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CartPage()));
        break;
      case 2:
        // current page
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfilePage(id: 1,)));
        break;
    }
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
              itemCount: _orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final dateGroup = _orders[index];
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
                                    child: Image.asset('assets/Team01.jpg', fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Order No. ${order['orderNo']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'ชื่อลูกค้า : ${order['customer']}',
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'ผู้จัดส่ง : ${order['deliveryUser']}',
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        'จำนวนสินค้า ${order['itemCount']} รายการ',
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      ...order['products']
                                          .take(2)
                                          .map<Widget>((p) => Text('  • $p', style: TextStyle(color: Colors.white))),
                                      if (order['products'].length > 2)
                                        const Text('  • ...', style: TextStyle(color: Colors.white, fontSize: 12)),
                                      Row(
                                        spacing: 10,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'ยอดรวม',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${order['total'].toStringAsFixed(2)}฿',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
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
