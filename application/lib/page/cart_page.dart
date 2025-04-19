import 'package:flutter/material.dart';
import '/page/map_page.dart';

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
      'spec': 'สูตรโฮบรด 50 กก.',
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
      'name': 'อัฐมวลเนา สราเพชร',
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
          icon: Icon(Icons.arrow_back , size: 40,color: Color(0xFF3C40C6),),
          onPressed: () {
            Navigator.pop(context); // or your custom logic
          },
        ),
        title: const Text('รายการสินค้าในรถเข็น'),
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
                  child: ListTile(
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['spec']),
                        Text('${item['price']}B/หน่วย'),
                      ],
                    ),
                    trailing: Text('จำนวน ${item['quantity']}'),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            // ข้อมูลลูกค้า
            const SizedBox(
              height: 42,
              width: 240,
              child: const Text(
                'ชื่อลูกค้า : คุณทฤษฎี',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
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
                  onTap: () async{
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
            const Text(
              'สินค้ารวม ${3} รายการ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    Text(
                      'จำนวน',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'สินค้า',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('ราคา', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                ..._products.map(
                  (item) => TableRow(
                    children: [
                      Text('${item['quantity']}'),
                      Text(item['name']),
                      Text(
                        '${(item['price'] * item['quantity']).toStringAsFixed(2)}B',
                      ),
                    ],
                  ),
                ),
                TableRow(
                  children: [
                    const Text(
                      'รวม',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(''),
                    Text(
                      '${_totalPrice.toStringAsFixed(2)}B',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
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
