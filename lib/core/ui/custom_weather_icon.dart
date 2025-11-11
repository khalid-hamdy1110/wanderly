import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomWeatherIcon extends StatefulWidget {
  const CustomWeatherIcon({super.key});

  @override
  State<CustomWeatherIcon> createState() => _CustomWeatherIconState();
}

class _CustomWeatherIconState extends State<CustomWeatherIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offsetY = Tween<double>(begin: -5, end: 5).evaluate(_controller);

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: CustomPaint(size: const Size(60, 60), painter: SunPainter()),
        );
      },
    );
  }
}

class SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    final sunPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw sun core
    canvas.drawCircle(center, radius, sunPaint);

    final rayPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const rayCount = 10;
    const rayLength = 20.0;

    // Draw rays evenly around circle
    for (int i = 0; i < rayCount; i++) {
      final angle = (2 * math.pi / rayCount) * i;
      final start = Offset(
        center.dx + math.cos(angle) * (radius + 4),
        center.dy + math.sin(angle) * (radius + 4),
      );
      final end = Offset(
        center.dx + math.cos(angle) * (radius + rayLength),
        center.dy + math.sin(angle) * (radius + rayLength),
      );
      canvas.drawLine(start, end, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
