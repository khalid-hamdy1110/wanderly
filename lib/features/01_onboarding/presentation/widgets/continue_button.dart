import 'package:flutter/material.dart';
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
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDisabled
              ? const Color.fromARGB(255, 255, 138, 159)
              : const Color(0xFFFF385C),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              label,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
