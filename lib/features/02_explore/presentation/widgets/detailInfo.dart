import 'package:flutter/material.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class DetailInfo extends StatelessWidget {
  const DetailInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.info,
  });

  final IconData icon;
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 56, 93, 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: const Color(0xFFFF385C), size: 20),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(' $title', fontSize: 12, color: const Color(0xFF717171)),
            CustomText(
              ' $info',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ],
        ),
      ],
    );
  }
}
