import 'package:flutter/material.dart';

class FeesCardImage extends StatelessWidget {
  const FeesCardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.account_balance_wallet,
          color: Color(0xFF1976D2), // Blue color
          size: 32,
        ),
      ),
    );
  }
}
