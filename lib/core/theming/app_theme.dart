import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/custom_components/custom_colors.dart';

class AppTheme {
  static const _primary = Color(0xFFFF385C);

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _primary,
      onPrimary: Colors.white,
    ),
    extensions: const [CustomColors.light],
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: _primary,
      selectionColor: Color(0x40FF385C),
      selectionHandleColor: _primary,
    ),
    datePickerTheme: DatePickerThemeData(
      todayBorder: const BorderSide(color: _primary),
      dayOverlayColor: WidgetStatePropertyAll(_primary.withValues(alpha: 0.1)),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      onPrimary: Colors.white,
    ),
    extensions: const [CustomColors.dark],
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: _primary,
      selectionColor: Color(0x40FF385C),
      selectionHandleColor: _primary,
    ),
    datePickerTheme: DatePickerThemeData(
      todayBorder: const BorderSide(color: _primary),
      dayOverlayColor: WidgetStatePropertyAll(_primary.withValues(alpha: 0.1)),
    ),
  );
}
