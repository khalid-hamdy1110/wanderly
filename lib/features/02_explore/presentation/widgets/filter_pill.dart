import 'package:flutter/widgets.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.fillColor,
    required this.text,
    required this.textStyle,
  });

  final Color fillColor;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: textStyle),
    );
  }
}
