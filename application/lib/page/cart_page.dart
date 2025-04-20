import 'package:flutter/material.dart';
import '/page/map_page.dart';
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
  String? _deliveryAddress;
  String _deliveryOption = 'pickup';
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'ปูนทานโครงสร้าง SCG',
      'spec': 'สูตรไฮบริด 50 กก.',
      'price': 150,
      'quantity': 2,
    },
    {
      'name': 'เหล็กเส้นกลม (พัน) มอก.',
      'spec': 'ขนาด 6 มม. x 10 นตร',
      'price': 85,
      'quantity': 1,
    },
    {
      'name': 'อิฐมวลเบา ตราเพชร',
      'spec': 'รุ่น 7 ชม.',
      'price': 35,
      'quantity': 10,
    },
  ];

  double get _totalPrice {
    return _products.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 40, color: Color(0xFF3C40C6)),
          onPressed: () {
            Navigator.pop(context); // or your custom logic
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
            // รายการสินค้า
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = _products[index];
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
                      // รูปสินค้า
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/Team02.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // รายละเอียดสินค้า
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item['spec'],
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${item['price']} B/หน่วย',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ),
                      // จำนวน
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'จำนวน ${item['quantity']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 20),
            // ข้อมูลลูกค้า
            SizedBox(
              height: 42,
              width: 240,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'ชื่อลูกค้า : คุณทฤษฎี',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // ประเภทการจัดส่ง
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

            // สรุปคำสั่งซื้อ
            Container(
              color: const Color(0xFF3C40C6),
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สินค้ารวม ${_products.length} รายการ',
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
                  ..._products.map(
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
                              '${item['quantity']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              item['name'],
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
                              '${item['price'] * item['quantity']} B',
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
                    onPressed: () {},
                    child: const Text('ยกเลิกรายการทั้งหมด'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.black.withAlpha(255),
                      backgroundColor: Color(0xFF0BE881),
                    ),
                    onPressed: () {},
                    child: const Text('ยืนยันคำสั่งซื้อ'),
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
