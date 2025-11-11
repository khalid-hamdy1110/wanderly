import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class SearchCurrencies extends StatelessWidget {
  const SearchCurrencies({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBEBEB)),
        ),
        child: const Row(
          children: [
            Icon(Amicons.remix_search, size: 18, color: Color(0xFF717171)),
            SizedBox(width: 12),
            Expanded(
              child: CustomText(
                'Search from 100+ currencies...',
                fontSize: 16,
                color: Color(0xFF717171),
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Amicons.remix_arrow_drop_down,
              size: 18,
              color: Color(0xFF717171),
            ),
          ],
        ),
      ),
    );
  }
}
