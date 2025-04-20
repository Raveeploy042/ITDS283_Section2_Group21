import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/material/bottom_navbar.dart';

class ListHistory extends StatefulWidget {
  @override
  State<ListHistory> createState() => _ListHistoryState();
}

class _ListHistoryState extends State<ListHistory> {
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
            'ผู้แทนโครงสร้าง SCG... (2)',
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
    return date.year == today.year && date.month == today.month && date.day == today.day
        ? 'วันนี้: ${DateFormat('dd/MM/yyyy').format(date)}'
        : DateFormat('dd/MM/yyyy').format(date);
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
                      onPressed: () {},
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final dateGroup = _orders[index];
                final ordersList = dateGroup['orders'] as List;
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
                    ...ordersList.map<Widget>((order) {
                      return Card(
                        color: Color(0xFF3C40C6),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {},
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
                                  child: Image.asset(
                                  'assets/tiger_cement.png',
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
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
                                            style: const TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text('ชื่อลูกค้า : ${order['customer']}', style: TextStyle(color: Colors.white)),
                                      Text('ประเภทการจัดส่ง : รับสินค้าที่หน้าร้าน', style: TextStyle(color: Colors.white)),
                                      Text('จำนวนสินค้า ${order['products'].length} รายการ', style: TextStyle(color: Colors.white)),
                                      const SizedBox(height: 2),
                                      ...order['products'].take(2).map<Widget>((p) => Text('• $p', style: TextStyle(color: Colors.white))),
                                      if (order['products'].length > 2)
                                        const Text('• ...', style: TextStyle(color: Colors.white)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('ยอดรวม', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                                          SizedBox(width: 10),
                                          Text('${order['total'].toStringAsFixed(2)}฿',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
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
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
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
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
