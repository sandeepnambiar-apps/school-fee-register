import 'package:flutter/material.dart';

class TimetableCardImage extends StatelessWidget {
  const TimetableCardImage({super.key});

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
          // Timetable base
          Positioned(
            left: 10,
            top: 12,
            child: Container(
              width: 40,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF9C27B0), width: 2),
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
          // Timetable header
          Positioned(
            left: 10,
            top: 12,
            child: Container(
              width: 40,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ),
          ),
          // Schedule lines
          Positioned(
            left: 12,
            top: 26,
            child: Column(
              children: List.generate(5, (index) => 
                Padding(
                  padding: EdgeInsets.only(bottom: index == 4 ? 0 : 3),
                  child: Row(
                    children: [
                      // Time indicator
                      Container(
                        width: 8,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Subject line
                      Container(
                        width: 20,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
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
                color: const Color(0xFF9C27B0),
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
                      angle: 0.8,
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
                      angle: -0.5,
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
