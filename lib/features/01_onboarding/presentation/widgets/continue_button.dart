import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.isDisabled,
    required this.onTap,
    required this.label,
    required this.icon,
  });

  final String label;
  final bool isDisabled;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 48,
      decoration: BoxDecoration(
        color: isDisabled ? customColors.disabledPrimary : customColors.primary,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: customColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(999),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: CustomText(
                  label,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDisabled
                      ? customColors.disabledOnPrimary
                      : customColors.onPrimary,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  icon,
                  color: isDisabled
                      ? customColors.disabledOnPrimary
                      : customColors.onPrimary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
