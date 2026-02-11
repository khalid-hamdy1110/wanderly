import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/custom_components/custom_colors.dart';

extension ThemeDataExtensions on ThemeData {
  CustomColors get customColors => extension<CustomColors>() ?? CustomColors.light;
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
}