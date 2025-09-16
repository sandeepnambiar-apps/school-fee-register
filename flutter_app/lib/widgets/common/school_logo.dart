import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class SchoolLogo extends StatefulWidget {
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
  State<SchoolLogo> createState() => _SchoolLogoState();
}

class _SchoolLogoState extends State<SchoolLogo> {
  String? _currentSchoolCode;

  @override
  void initState() {
    super.initState();
    _loadSchoolCode();
  }

  Future<void> _loadSchoolCode() async {
    final apiService = ApiService();
    final schoolCode = await apiService.getStoredSchoolCode();
    setState(() {
      _currentSchoolCode = schoolCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show BOON logo if school code is BOON
    if (_currentSchoolCode == 'BOON') {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BOON Logo Image
            Container(
              width: widget.size * 0.8,
              height: widget.size * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/boon-logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to default logo if image fails to load
                    return _buildDefaultLogo();
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            // BOON School Name
            Text(
              'BOON',
              style: TextStyle(
                fontSize: widget.size * 0.15,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      );
    }
    
    // Default logo for other schools
    return _buildDefaultLogo();
  }

  Widget _buildDefaultLogo() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Open Book (base)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: widget.size * 0.4,
              decoration: BoxDecoration(
                color: widget.bookColor ?? Colors.blue[600],
                borderRadius: BorderRadius.circular(widget.size * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Book spine
                  Positioned(
                    left: widget.size * 0.45,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: widget.size * 0.1,
                      decoration: BoxDecoration(
                        color: (widget.bookColor ?? Colors.blue[600])!.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(widget.size * 0.02),
                      ),
                    ),
                  ),
                  // Book pages (slightly fanned out)
                  Positioned(
                    left: widget.size * 0.05,
                    right: widget.size * 0.05,
                    top: widget.size * 0.02,
                    bottom: widget.size * 0.02,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(widget.size * 0.03),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Left Figure (Green)
          Positioned(
            bottom: widget.size * 0.45,
            left: widget.size * 0.15,
            child: _buildHumanFigure(
              widget.size * 0.25,
              widget.figureColor1 ?? Colors.green[600]!,
            ),
          ),
          
          // Center Figure (Purple) - taller and more prominent
          Positioned(
            bottom: widget.size * 0.5,
            left: widget.size * 0.35,
            child: _buildHumanFigure(
              widget.size * 0.3,
              widget.figureColor2 ?? Colors.purple[600]!,
            ),
          ),
          
          // Right Figure (Orange)
          Positioned(
            bottom: widget.size * 0.45,
            right: widget.size * 0.15,
            child: _buildHumanFigure(
              widget.size * 0.25,
              widget.figureColor3 ?? Colors.orange[600]!,
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
