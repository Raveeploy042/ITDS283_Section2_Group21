import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? searchController;
  final VoidCallback? onCartPressed;

  CustomAppBar({this.searchController, this.onCartPressed});

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: 
                  Container(
                    color: Colors.white,
                  )
              ),
              SizedBox(width: 8),
              Icon(Icons.search, color: Colors.grey),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart ,
            color: Colors.white,
            size: 32,
            ),
            onPressed: () {
              // 👉 ไปยังหน้ารถเข็น
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
        ],
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
