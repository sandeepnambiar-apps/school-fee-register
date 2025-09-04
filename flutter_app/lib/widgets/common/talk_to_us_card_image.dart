import 'package:flutter/material.dart';

class TalkToUsCardImage extends StatelessWidget {
  const TalkToUsCardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5), // Light purple background
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: TalkToUsIcon(),
      ),
    );
  }
}

class TalkToUsIcon extends StatelessWidget {
  const TalkToUsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF9C27B0), // Purple
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
