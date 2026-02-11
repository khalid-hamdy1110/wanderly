import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.bgColor,
    this.child,
    this.noPadding = false,
  });

  final Color bgColor;
  final Widget? child;
  final bool noPadding;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: customColors.border),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: -5, // How much the shadow spreads
            blurRadius: 25, // How blurred the shadow is
            offset: Offset(0, 20), // Offset of the shadow (x, y)
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: -6,
            blurRadius: 10,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: !noPadding ? const EdgeInsets.all(24) : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
