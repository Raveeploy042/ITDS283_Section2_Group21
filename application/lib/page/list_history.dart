import 'package:flutter/material.dart';
import '/page/home_page.dart';
import 'package:intl/intl.dart';

void main(List<String> args) {
  runApp(ListHistory());
}

class ListHistory extends StatelessWidget {
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
    final orderDate = DateTime(date.year, date.month, date.day);

    return orderDate == today
        ? 'วันนี้: ${DateFormat('dd/MM/yyyy').format(date)}'
        : DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: null, icon: Icon(Icons.arrow_back))
          ],
          title: const Text('ประวัติคำสั่งซื้อ')
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final dateGroup = _orders[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // วันที่
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _formatDate(dateGroup['date']),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
      
                // รายการคำสั่งซื้อ
                ...dateGroup['orders'].map<Widget>(
                  (order) => Card(
                    color: Color(0xFF3C40C6),
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {}, // เพิ่มการทำงานเมื่อกดดูรายละเอียด
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order No. ${order['orderNo']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '฿${order['total'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('ชื่อลูกค้า : ${order['customer']}'),
                            Text('ผู้จัดส่ง : ${order['deliveryUser']}'),
                            Text('จำนวนสินค้า ${order['itemCount']} รายการ'),
                            const SizedBox(height: 8),
                            ...order['products']
                                .take(2)
                                .map<Widget>(
                                  (p) => Text(
                                    '• $p',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                            if (order['products'].length > 2)
                              const Text(
                                '• ...',
                                style: TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
