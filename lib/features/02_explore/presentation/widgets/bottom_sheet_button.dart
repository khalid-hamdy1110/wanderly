import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: customColors.accent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: -5,
            blurRadius: 25,
            offset: Offset(0, -10),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: -6,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: customColors.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Amicons.remix_calendar_check,
                  color: customColors.onPrimary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                CustomText(
                  label,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: customColors.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
