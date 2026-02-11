import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
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
    final customColors = context.theme.customColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: customColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: customColors.primary, size: 20),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(title, fontSize: 12, color: customColors.onMuted),
              CustomText(
                info,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: customColors.onCard,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
