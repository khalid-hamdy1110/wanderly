import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    super.key,
    required this.isDisabled,
    required this.onTap,
    required this.label,
  });

  final String label;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 48,
      decoration: BoxDecoration(
        color: isDisabled
            ? customColors.disabledSecondary
            : customColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: customColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: CustomText(
                label,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDisabled
                    ? customColors.disabledOnSecondary
                    : customColors.onSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
