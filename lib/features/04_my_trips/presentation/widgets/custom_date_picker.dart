import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.disabled = false,
    this.hasError = false,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final bool disabled;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: disabled
            ? customColors.secondary.withValues(alpha: 0.7)
            : customColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: hasError
              ? 2
              : disabled
              ? 1
              : 0,
          color: hasError ? customColors.destructive : customColors.border,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: disabled ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 18, color: customColors.textFieldPlaceholder),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    label,
                    fontSize: 16,
                    color: disabled
                        ? customColors.textFieldPlaceholder.withValues(
                            alpha: 0.7,
                          )
                        : customColors.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
