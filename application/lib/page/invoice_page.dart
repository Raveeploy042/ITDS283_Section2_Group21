import 'package:flutter/material.dart';
import '/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<List<String>> items = [
      ['2', 'ปูนงานโครงสร้าง SCG สูตรไฮ...', '300.00'],
      ['1', 'เหล็กเส้นกลม (พับ) มอก.ขนาด...', '85.00'],
      ['10', 'อิฐมวลเบา ตราเพชร รุ่น 7 ซม.', '350.00'],
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back, color: Color(0xFF3C40C6), size: 40),
          title: const Text('ใบสรุปคำสั่งซื้อ',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.create))],
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xFF3C40C6),
              width: 380,
              height: 637,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ชื่อลูกค้า: คุณทฤษฎี',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 20, color: Colors.white)),
                  const Text('ประเภทการจัดส่ง: รับเองที่หน้าร้าน',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 20, color: Colors.white)),
                  const SizedBox(height: 20),
                  const Text('สินค้ารวม 3 รายการ',
                      style: TextStyle(
                          fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),

                  Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Row(
                      children: [
                        Expanded(flex: 1, child: Text('จำนวน', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 4, child: Text('สินค้า', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 2,
                            child: Text('ราคา',
                                textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),

                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(item[0],
                                    style: const TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter'))),
                            Expanded(
                                flex: 4,
                                child: Text(item[1],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter'))),
                            Expanded(
                                flex: 2,
                                child: Text(item[2],
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter'))),
                          ],
                        ),
                      )),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('ยอดรวม',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 25),
                        Text('735.00฿',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        minimumSize: const Size(154, 53),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFFF0000)),
                    child: const Text('ยกเลิกคำสั่งซื้อ',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold))),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        minimumSize: const Size(154, 53),
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFF0BE881),
                        side: const BorderSide(color: Color(0xFF0BE881))),
                    child: const Text('ยืนยันคำสั่งซื้อ',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold))),
              ],
            )
          ],
        ),
      ),
    );
  }
}