import 'package:flutter/material.dart';
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
    return InkWell(
      onTap: disabled ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFFFFFFF) : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: hasError
                ? 2
                : disabled
                ? 1
                : 0,
            color: hasError
                ? const Color(0xFFE11D48)
                : disabled
                ? const Color(0xFFE0E0E0)
                : const Color(0xFFF7F7F7),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: disabled
                  ? const Color(0xFFBDBDBD)
                  : const Color(0xFF717171),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                label,
                fontSize: 16,
                color: disabled ? const Color(0xFFBDBDBD) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
