import 'package:flutter/material.dart';
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
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFEBEBEB)),
        ),
        child: Center(
          child: CustomText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDisabled ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}
