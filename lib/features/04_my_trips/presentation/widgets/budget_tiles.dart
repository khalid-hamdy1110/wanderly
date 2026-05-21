import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/utilities/useful_functions.dart';

class BudgetTiles extends StatefulWidget {
  const BudgetTiles({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.color,
  });

  final String title;
  final double amount;
  final String currency;
  final Color color;

  @override
  State<BudgetTiles> createState() => _BudgetTilesState();
}

class _BudgetTilesState extends State<BudgetTiles> {
  bool _formatAmount = true;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return GestureDetector(
      onTap: () {
        setState(() {
          _formatAmount = !_formatAmount;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(widget.title, fontSize: 12, color: customColors.onMuted),
            const SizedBox(height: 8),
            _formatAmount
                ? CustomText(
                        formatNumber(widget.amount),
                        fontSize: 18,
                        color: customColors.onCard,
                      )
                      .animate(key: ValueKey(_formatAmount))
                      .fadeIn(duration: 300.ms)
                      .scale(duration: 300.ms, curve: Curves.easeOutBack)
                : FittedBox(
                        child: CustomText(
                          widget.amount.toString(),
                          fontSize: 18,
                          color: customColors.onCard,
                        ),
                      )
                      .animate(key: ValueKey(_formatAmount))
                      .fadeIn(duration: 300.ms)
                      .scale(duration: 300.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 4),
            CustomText(
              widget.currency,
              fontSize: 12,
              color: customColors.onMuted,
            ),
          ],
        ),
      ),
    );
  }
}
