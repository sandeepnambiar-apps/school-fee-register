import 'package:flutter/material.dart';

class CartoonChildrenIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const CartoonChildrenIcon({
    super.key,
    this.size = 36.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? Colors.orange[600],
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Boy (left side)
          Positioned(
            left: size * 0.1,
            child: Container(
              width: size * 0.35,
              height: size * 0.35,
              decoration: BoxDecoration(
                color: Colors.orange[300],
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  // Boy's face
                  Positioned(
                    top: size * 0.02,
                    left: size * 0.02,
                    child: Container(
                      width: size * 0.31,
                      height: size * 0.31,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          // Eyes
                          Positioned(
                            top: size * 0.08,
                            left: size * 0.06,
                            child: Container(
                              width: size * 0.04,
                              height: size * 0.04,
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            top: size * 0.08,
                            right: size * 0.06,
                            child: Container(
                              width: size * 0.04,
                              height: size * 0.04,
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Smile
                          Positioned(
                            bottom: size * 0.08,
                            left: size * 0.08,
                            child: Container(
                              width: size * 0.15,
                              height: size * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.brown,
                                    width: size * 0.01,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(size * 0.08),
                                  bottomRight: Radius.circular(size * 0.08),
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
            ),
          ),
          // Girl (right side)
          Positioned(
            right: size * 0.1,
            child: Container(
              width: size * 0.35,
              height: size * 0.35,
              decoration: BoxDecoration(
                color: Colors.pink[300],
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  // Girl's face
                  Positioned(
                    top: size * 0.02,
                    left: size * 0.02,
                    child: Container(
                      width: size * 0.31,
                      height: size * 0.31,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          // Eyes
                          Positioned(
                            top: size * 0.08,
                            left: size * 0.06,
                            child: Container(
                              width: size * 0.04,
                              height: size * 0.04,
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            top: size * 0.08,
                            right: size * 0.06,
                            child: Container(
                              width: size * 0.04,
                              height: size * 0.04,
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Smile
                          Positioned(
                            bottom: size * 0.08,
                            left: size * 0.08,
                            child: Container(
                              width: size * 0.15,
                              height: size * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.brown,
                                    width: size * 0.01,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(size * 0.08),
                                  bottomRight: Radius.circular(size * 0.08),
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
            ),
          ),
        ],
      ),
    );
  }
}


