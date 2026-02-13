import 'package:flutter/material.dart';

/// A container with a convex (upward curved) top edge that can overlap previous widgets
class ConvexContainer extends StatelessWidget {
  const ConvexContainer({
    super.key,
    required this.child,
    this.gradient,
    this.color,
    this.curveHeight = 20,
    this.edgeHeight = 40,
    this.overlapOffset = 0,
  }) : assert(
         gradient == null || color == null,
         'Cannot provide both gradient and color',
       );

  final Widget child;
  final Gradient? gradient;
  final Color? color;
  final double curveHeight;
  final double edgeHeight;
  final double overlapOffset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, overlapOffset),
      child: ClipPath(
        clipper: ConvexTopClipper(
          curveHeight: curveHeight,
          edgeHeight: edgeHeight,
        ),
        child: Container(
          decoration: BoxDecoration(gradient: gradient, color: color),
          child: child,
        ),
      ),
    );
  }
}

/// Custom clipper for convex top edge
class ConvexTopClipper extends CustomClipper<Path> {
  const ConvexTopClipper({this.curveHeight = 20, this.edgeHeight = 40});

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
