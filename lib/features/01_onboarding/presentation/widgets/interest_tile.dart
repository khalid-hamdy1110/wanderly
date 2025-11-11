import 'package:flutter/material.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class InterestTile extends StatelessWidget {
  const InterestTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.isSelected,
  });

  final String emoji;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFEBEF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF385C) : const Color(0xFFEBEBEB),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomText(emoji, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomText(title, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
