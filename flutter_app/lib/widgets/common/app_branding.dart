import 'package:flutter/material.dart';

class AppBranding extends StatelessWidget {
  final bool isCompact;
  
  const AppBranding({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: isCompact ? 8.0 : 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Kid',
                    style: TextStyle(
                      fontSize: isCompact ? 14.0 : 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 4.0 : 6.0,
                      vertical: isCompact ? 2.0 : 3.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      'sy',
                      style: TextStyle(
                        fontSize: isCompact ? 14.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}
