import 'package:flutter/material.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class CurrencyConversionContainer extends StatelessWidget {
  const CurrencyConversionContainer({
    super.key,
    required this.yourBudget,
    required this.yourCurrency,
    required this.convertedBudget,
    required this.convertedCurrency,
    required this.conversionRate,
    required this.countryName,
  });

  final String yourBudget;
  final String yourCurrency;
  final String convertedBudget;
  final String convertedCurrency;
  final String conversionRate;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBEBEB)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF5F7), Color(0xFFF7F7F7)],
          stops: [0, 1],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 2,
            spreadRadius: -1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Currency Conversion',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomText(
                  'Your Budget',
                  fontSize: 12,
                  color: Color(0xFF717171),
                ),
              ),
              Expanded(
                child: CustomText(
                  'In $countryName',
                  fontSize: 12,
                  color: const Color(0xFF717171),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  '$yourBudget $yourCurrency',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: CustomText(
                  '$convertedBudget $convertedCurrency',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF385C),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 6),

          CustomText(
            'Exchange Rate: 1 $yourCurrency = $conversionRate $convertedCurrency',
            fontSize: 12,
            color: const Color(0xFF717171),
          ),
        ],
      ),
    );
  }
}
