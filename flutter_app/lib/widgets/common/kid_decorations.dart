import 'package:flutter/material.dart';

class KidDecorations extends StatelessWidget {
  final bool showRocket;
  final bool showBook;
  final bool showToy;
  final bool showStar;
  
  const KidDecorations({
    super.key,
    this.showRocket = true,
    this.showBook = true,
    this.showToy = true,
    this.showStar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Rocket decoration
        if (showRocket)
          Positioned(
            right: 20,
            top: 20,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 3),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -10 * value),
                  child: Icon(
                    Icons.rocket_launch,
                    color: Colors.lightBlue[400],
                    size: 24,
                  ),
                );
              },
            ),
          ),
        
        // Book decoration
        if (showBook)
          Positioned(
            left: 20,
            bottom: 20,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: 0.1 * value,
                  child: Icon(
                    Icons.book,
                    color: Colors.lightBlue[300],
                    size: 20,
                  ),
                );
              },
            ),
          ),
        
        // Toy decoration
        if (showToy)
          Positioned(
            right: 40,
            bottom: 40,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 4),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Icon(
                    Icons.toys,
                    color: Colors.lightBlue[500],
                    size: 18,
                  ),
                );
              },
            ),
          ),
        
        // Star decoration
        if (showStar)
          Positioned(
            left: 40,
            top: 40,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: 0.5 * value,
                  child: Icon(
                    Icons.star,
                    color: Colors.amber[400],
                    size: 16,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// Floating kid elements for backgrounds
class FloatingKidElements extends StatelessWidget {
  const FloatingKidElements({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating pencil
        Positioned(
          right: 30,
          top: 100,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 5),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(5 * value, -5 * value),
                child: Icon(
                  Icons.edit,
                  color: Colors.lightBlue[300],
                  size: 16,
                ),
              );
            },
          ),
        ),
        
        // Floating calculator
        Positioned(
          left: 30,
          top: 150,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 6),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(-3 * value, 3 * value),
                child: Icon(
                  Icons.calculate,
                  color: Colors.lightBlue[400],
                  size: 14,
                ),
              );
            },
          ),
        ),
        
        // Floating graduation cap
        Positioned(
          right: 60,
          bottom: 100,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 4),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(2 * value, -2 * value),
                child: Icon(
                  Icons.school,
                  color: Colors.lightBlue[500],
                  size: 18,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
