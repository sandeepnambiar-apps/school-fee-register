import 'package:flutter/material.dart';

class KidsCardImage extends StatelessWidget {
  const KidsCardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.people,
          size: 32,
          color: const Color(0xFF1976D2),
        ),
      ),
    );
  }
}
