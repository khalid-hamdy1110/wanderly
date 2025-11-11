import 'package:flutter/material.dart';

class BudgetUsageProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color fillColor;

  BudgetUsageProgressPainter({
    required this.progress,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.fillColor = const Color(0xFF4CAF50),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.height;
    final radius = stroke / 2;

    final paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final start = Offset(radius, size.height / 2);
    final end = Offset(size.width - radius, size.height / 2);
    canvas.drawLine(start, end, paint);

    final progressPaint = Paint()
      ..color = fillColor
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final progressEnd = Offset(
      start.dx + (end.dx - start.dx) * progress.clamp(0, 1),
      size.height / 2,
    );
    canvas.drawLine(start, progressEnd, progressPaint);
  }

  @override
  bool shouldRepaint(covariant BudgetUsageProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
