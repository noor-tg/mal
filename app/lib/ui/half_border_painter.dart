import 'package:flutter/material.dart';

class HalfBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  HalfBorderPainter({required this.color, this.strokeWidth = 3});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = 0.0; // 0 rad = right side
    const sweepAngle = 3.14159; // π rad = 180° half-circle

    // Draw only the bottom half arc
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
