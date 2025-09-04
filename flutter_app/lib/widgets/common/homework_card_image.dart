import 'package:flutter/material.dart';

class HomeworkCardImage extends StatelessWidget {
  const HomeworkCardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Clipboard base
          Positioned(
            left: 12,
            top: 8,
            child: Container(
              width: 36,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF1976D2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // Clipboard clip
          Positioned(
            left: 18,
            top: 4,
            child: Container(
              width: 24,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          // Lines on clipboard
          Positioned(
            left: 16,
            top: 16,
            child: Column(
              children: List.generate(6, (index) => 
                Padding(
                  padding: EdgeInsets.only(bottom: index == 5 ? 0 : 3),
                  child: Container(
                    width: 28,
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Pencil
          Positioned(
            right: 10,
            top: 12,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Pencil tip
          Positioned(
            right: 8,
            top: 12,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 0,
                height: 0,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: const Color(0xFF1976D2), width: 3),
                    top: BorderSide(color: Colors.transparent, width: 2),
                    bottom: BorderSide(color: Colors.transparent, width: 2),
                  ),
                ),
              ),
            ),
          ),
          // "HW" text
          Positioned(
            left: 20,
            top: 18,
            child: Text(
              'HW',
              style: TextStyle(
                color: const Color(0xFF1976D2),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
