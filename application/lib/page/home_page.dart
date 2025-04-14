import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final List<Map<String, String>> recommendedProducts = [
    {'name': 'ผู้USCG สูตรโฮม', 'price': '150B/ญา'},
    {'name': 'เหล็กเล่นกลม', 'price': '85B/10 ม.'},
    {'name': 'อิฐมวลแท', 'price': '35B/ห้อง'},
  ];

  final List<String> productCategories = [
    'เลือก',
    'ตกแต่ง',
    'ล้อ',
    'ตกแต่ง',
    'เลือก',
    'ตกแต่ง',
    'ชุดตกแต่ง',
  ];
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Home Page',
      home: Scaffold(
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 20,
                  children: [
                    Container(
                      padding: EdgeInsets.all(11),
                      width: 168,
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
                                style: TextStyle(color: Colors.white,fontSize: 18),
                              ),
                              Text(
                                'ในรถเข็น',
                                style: TextStyle(color: Colors.white,fontSize: 18),
                              ),
                            ],
                          ),
                          Icon(Icons.shopping_cart_outlined, color: Colors.white,size: 30,),
                        ],
                      ),
                    ),
                    Container(
                      width: 168,
                      height: 74,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF3C40C6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Text('ประวัติคำสั่งซื้อ',
                          style: TextStyle(color: Colors.white),),
                          Icon(Icons.receipt_long,color: Colors.white, size: 30,),
                        ],
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
                    itemCount: recommendedProducts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Container(
                          width: 120,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, size: 92),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                recommendedProducts[index]['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                recommendedProducts[index]['price']!,
                                style: TextStyle(color: Colors.grey[600]),
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: productCategories.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        foregroundColor: Colors.blue[800],
                      ),
                      onPressed: () {},
                      child: Text(productCategories[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xFF3C40C6),
      title: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(child: Container(color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.search, color: Colors.grey),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 32),
          onPressed: () {
            // 👉 ไปยังหน้ารถเข็น
            // Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
          },
        ),
      ],
    );
  }
}
