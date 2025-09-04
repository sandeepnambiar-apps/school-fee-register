import 'package:flutter/material.dart';

class TrackBusCardImage extends StatelessWidget {
  const TrackBusCardImage({super.key});

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
        child: TrackBusIcon(),
      ),
    );
  }
}

class TrackBusIcon extends StatelessWidget {
  const TrackBusIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2), // Blue
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          Icons.directions_bus,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
