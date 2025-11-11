import 'package:flutter/material.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class BudgetTiles extends StatelessWidget {
  const BudgetTiles({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.color,
  });

  final String title;
  final String amount;
  final String currency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(title, fontSize: 12, color: const Color(0xFF717171)),
          const SizedBox(height: 8),
          CustomText(amount, fontSize: 18),
          const SizedBox(height: 4),
          CustomText(currency, fontSize: 12, color: const Color(0xFF717171)),
        ],
      ),
    );
  }
}
