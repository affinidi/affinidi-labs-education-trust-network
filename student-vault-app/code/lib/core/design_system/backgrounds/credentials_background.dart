import 'package:flutter/material.dart';

/// Layered background for credentials screen with gradient and curved overlay
class CredentialsBackground extends StatelessWidget {
  const CredentialsBackground({
    super.key,
    this.overlayTop = 114,
    this.overlayLeft = 0,
    this.overlayRight = 0,
    this.overlayBottom = 0,
    this.curveHeight = 20,
    this.edgeHeight = 40,
  });

  final double overlayTop;
  final double overlayLeft;
  final double overlayRight;
  final double overlayBottom;
  final double curveHeight;
  final double edgeHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bottom layer: Vertical gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFC470), // 0%
                Color(0xFFFFC470), // 0%
                Color(0xFFFFD966), // 32%
                Color(0xFFFFD966), // 32% and continues
              ],
              stops: [0.0, 0.0, 0.32, 1.0],
            ),
          ),
        ),

        // Top layer: Curved orange overlay at Y:114
        Positioned(
          top: overlayTop,
          left: overlayLeft,
          right: overlayRight,
          bottom: overlayBottom,
          child: ClipPath(
            clipper: _CurvedTopClipper(
              curveHeight: curveHeight,
              edgeHeight: edgeHeight,
            ),
            child: Container(color: const Color(0xFFFFAB66)),
          ),
        ),
      ],
    );
  }
}

/// Custom clipper for curved top edge
class _CurvedTopClipper extends CustomClipper<Path> {
  const _CurvedTopClipper({this.curveHeight = 20, this.edgeHeight = 40});

  final double curveHeight;
  final double edgeHeight;

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from bottom left
    path.moveTo(0, size.height);

    // Left edge
    path.lineTo(0, edgeHeight);

    // Convex curve at top (upward arch)
    path.quadraticBezierTo(
      size.width / 2, // Control point X (center)
      -curveHeight, // Control point Y (above top edge - creates upward curve)
      size.width, // End point X (right edge)
      edgeHeight, // End point Y
    );

    // Right edge
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
