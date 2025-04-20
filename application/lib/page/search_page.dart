import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> items = ['ปูนซีเมนต์', 'เหล็กเส้น', 'อิฐมวลเบา', 'ทราย'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Color(0xFF3C40C6), size: 50),
        title: TextField(
          decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF3C40C6),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3C40C6)),
                  borderRadius: BorderRadius.circular(30))),
        ),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: items.length + 1,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, index) {
            if (index < items.length) {
              return ListTile(
                title: Text(items[index]),
              );
            } 
            else {
              return Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'แสดงเพิ่มเติม',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
          },
        ),
      ),
      
    );
  }
}
