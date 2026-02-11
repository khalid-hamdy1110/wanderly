import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class SearchCurrencies extends StatelessWidget {
  const SearchCurrencies({super.key, this.onPressed, required this.label});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return Container(
      decoration: BoxDecoration(
        color: customColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: customColors.border),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Row(
              children: [
                Icon(
                  Amicons.remix_search,
                  size: 18,
                  color: customColors.textFieldPlaceholder,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    label,
                    fontSize: 16,
                    color: customColors.textFieldPlaceholder,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Amicons.remix_arrow_drop_down,
                  size: 18,
                  color: customColors.textFieldPlaceholder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
