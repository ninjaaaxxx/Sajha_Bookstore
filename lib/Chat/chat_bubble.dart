import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';

class chatbubble extends StatelessWidget {
  final String message;
  const chatbubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Text(
        message,
        style:
            TextStyle(fontSize: 16, color: Colors.white, fontFamily: regular),
      ),
    );
  }
}
