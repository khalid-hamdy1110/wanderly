import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.fillColor,
    required this.text,
    required this.textStyle,
    required this.onTap,
  });

  final Color fillColor;
  final String text;
  final TextStyle textStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: customColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          splashColor: customColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(text, style: textStyle),
          ),
        ),
      ),
    );
  }
}
