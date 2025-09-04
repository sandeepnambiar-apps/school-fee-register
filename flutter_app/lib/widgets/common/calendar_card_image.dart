import 'package:flutter/material.dart';

class CalendarCardImage extends StatelessWidget {
  const CalendarCardImage({super.key});

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
          // Calendar base
          Positioned(
            left: 10,
            top: 12,
            child: Container(
              width: 40,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
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
          // Calendar header
          Positioned(
            left: 10,
            top: 12,
            child: Container(
              width: 40,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ),
          ),
          // Calendar rings
          Positioned(
            left: 16,
            top: 16,
            child: Container(
              width: 8,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Container(
              width: 8,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Calendar grid
          Positioned(
            left: 12,
            top: 26,
            child: Column(
              children: List.generate(4, (row) => 
                Padding(
                  padding: EdgeInsets.only(bottom: row == 3 ? 0 : 2),
                  child: Row(
                    children: List.generate(7, (col) => 
                      Padding(
                        padding: EdgeInsets.only(right: col == 6 ? 0 : 2),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1976D2).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Clock overlay
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Stack(
                children: [
                  // Clock center
                  Center(
                    child: Container(
                      width: 2,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Hour hand
                  Center(
                    child: Transform.rotate(
                      angle: 0.5,
                      child: Container(
                        width: 1,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0.5),
                        ),
                      ),
                    ),
                  ),
                  // Minute hand
                  Center(
                    child: Transform.rotate(
                      angle: -0.3,
                      child: Container(
                        width: 1,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
