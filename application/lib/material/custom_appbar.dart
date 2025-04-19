import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF3C40C6),
      title: GestureDetector(
        onTap: null,
        child: Container(
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
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 32),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
