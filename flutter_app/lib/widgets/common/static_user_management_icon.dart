import 'package:flutter/material.dart';

class StaticUserManagementIcon extends StatelessWidget {
  const StaticUserManagementIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD), // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: UserManagementIcon(),
      ),
    );
  }
}

class UserManagementIcon extends StatelessWidget {
  const UserManagementIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main user icon
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3), // Blue
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        // Settings gear overlay
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2), // Darker blue
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ),
        // Small user indicators
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50), // Green
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
