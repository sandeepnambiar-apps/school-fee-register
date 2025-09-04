import 'package:flutter/material.dart';

class StaticReportsIcon extends StatelessWidget {
  const StaticReportsIcon({super.key});

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
        child: ReportsIcon(),
      ),
    );
  }
}

class ReportsIcon extends StatelessWidget {
  const ReportsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Document base
        Container(
          width: 35,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0), // Purple
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Document header
              Container(
                width: 35,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2), // Darker purple
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 8,
                  ),
                ),
              ),
              // Document content lines
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: List.generate(4, (index) => Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Chart overlay
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF9C27B0),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.bar_chart,
                color: Color(0xFF9C27B0),
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
