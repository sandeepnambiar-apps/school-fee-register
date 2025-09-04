import 'package:flutter/material.dart';

class SchoolLogo extends StatelessWidget {
  final double size;
  final Color? bookColor;
  final Color? figureColor1;
  final Color? figureColor2;
  final Color? figureColor3;

  const SchoolLogo({
    super.key,
    this.size = 80.0,
    this.bookColor,
    this.figureColor1,
    this.figureColor2,
    this.figureColor3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Open Book (base)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size * 0.4,
              decoration: BoxDecoration(
                color: bookColor ?? Colors.blue[600],
                borderRadius: BorderRadius.circular(size * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Book spine
                  Positioned(
                    left: size * 0.45,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: size * 0.1,
                      decoration: BoxDecoration(
                        color: (bookColor ?? Colors.blue[600])!.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(size * 0.02),
                      ),
                    ),
                  ),
                  // Book pages (slightly fanned out)
                  Positioned(
                    left: size * 0.05,
                    right: size * 0.05,
                    top: size * 0.02,
                    bottom: size * 0.02,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size * 0.03),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Left Figure (Green)
          Positioned(
            bottom: size * 0.45,
            left: size * 0.15,
            child: _buildHumanFigure(
              size * 0.25,
              figureColor1 ?? Colors.green[600]!,
            ),
          ),
          
          // Center Figure (Purple) - taller and more prominent
          Positioned(
            bottom: size * 0.5,
            left: size * 0.35,
            child: _buildHumanFigure(
              size * 0.3,
              figureColor2 ?? Colors.purple[600]!,
            ),
          ),
          
          // Right Figure (Orange)
          Positioned(
            bottom: size * 0.45,
            right: size * 0.15,
            child: _buildHumanFigure(
              size * 0.25,
              figureColor3 ?? Colors.orange[600]!,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHumanFigure(double figureSize, Color color) {
    return Container(
      width: figureSize,
      height: figureSize,
      child: Stack(
        children: [
          // Body
          Positioned(
            bottom: 0,
            left: figureSize * 0.3,
            child: Container(
              width: figureSize * 0.4,
              height: figureSize * 0.6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(figureSize * 0.2),
              ),
            ),
          ),
          
          // Head
          Positioned(
            top: 0,
            left: figureSize * 0.25,
            child: Container(
              width: figureSize * 0.5,
              height: figureSize * 0.4,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Arms (raised in celebration/reaching gesture)
          Positioned(
            top: figureSize * 0.1,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left arm
                Container(
                  width: figureSize * 0.15,
                  height: figureSize * 0.25,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(figureSize * 0.075),
                  ),
                  transform: Matrix4.rotationZ(-0.3),
                ),
                // Right arm
                Container(
                  width: figureSize * 0.15,
                  height: figureSize * 0.25,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(figureSize * 0.075),
                  ),
                  transform: Matrix4.rotationZ(0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
