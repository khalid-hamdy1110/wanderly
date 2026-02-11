import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color primary;
  final Color onPrimary;
  final Color disabledPrimary;
  final Color disabledOnPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color disabledSecondary;
  final Color disabledOnSecondary;
  final Color muted;
  final Color onMuted;
  final Color background;
  final Color onBackground;
  final Color card;
  final Color onCard;
  final Color accent;
  final Color onAccent;
  final Color destructive;
  final Color onDestructive;
  final Color success;
  final Color onSuccess;
  final Color focusRing;
  final Color border;
  final Color inputBorder;
  final Color inputBackground;
  final Color dropdownBackground;
  final Color onDropdownBackground;
  final Color textFieldPlaceholder;
  final Color upcoming;
  final Color ongoing;
  final Color completed;

  const CustomColors({
    required this.primary,
    required this.onPrimary,
    required this.disabledPrimary,
    required this.disabledOnPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.disabledSecondary,
    required this.disabledOnSecondary,
    required this.muted,
    required this.onMuted,
    required this.background,
    required this.onBackground,
    required this.card,
    required this.onCard,
    required this.accent,
    required this.onAccent,
    required this.destructive,
    required this.onDestructive,
    required this.success,
    required this.onSuccess,
    required this.focusRing,
    required this.border,
    required this.inputBorder,
    required this.inputBackground,
    required this.dropdownBackground,
    required this.onDropdownBackground,
    required this.textFieldPlaceholder,
    required this.upcoming,
    required this.ongoing,
    required this.completed,
  });

  static const CustomColors light = CustomColors(
    primary: Color(0xFFFF385C),
    onPrimary: Color(0xFFFFFFFF),
    disabledPrimary: Color(0x80FF385C),
    disabledOnPrimary: Color(0x80FFFFFF),
    secondary: Color(0xFFF7F7F7),
    onSecondary: Color(0xFF1A1A1A),
    disabledSecondary: Color(0x80F7F7F7),
    disabledOnSecondary: Color(0x801A1A1A),
    muted: Color(0xFFF7F7F7),
    onMuted: Color(0xFF717171),
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1A1A1A),
    card: Color(0xFFFFFFFF),
    onCard: Color(0xFF1A1A1A),
    accent: Color(0xFFFFF5F7),
    onAccent: Color(0xFFFF385C),
    destructive: Color(0xFFE11D48),
    onDestructive: Color(0xFFFFFFFF),
    success: Color(0xFF4CAF50),
    onSuccess: Color(0xFFFFFFFF),
    focusRing: Color(0xFFFF385C),
    border: Color(0xFFEBEBEB),
    inputBorder: Color(0x00FFFFFF),
    inputBackground: Color(0xFFF7F7F7),
    dropdownBackground: Color(0xFFFFFFFF),
    onDropdownBackground: Color(0xFF1A1A1A),
    textFieldPlaceholder: Color(0xFF717171),
    upcoming: Color(0xFF1447E6),
    ongoing: Color(0xFF008236),
    completed: Color(0xFF8200DB),
  );

  static const CustomColors dark = CustomColors(
    primary: Color(0xFFFF385C),
    onPrimary: Color(0xFFFFFFFF),
    disabledPrimary: Color(0x80FF385C),
    disabledOnPrimary: Color(0x80FFFFFF),
    secondary: Color(0xFF2A2A2A),
    onSecondary: Color(0xFFE8E8E8),
    disabledSecondary: Color(0x802A2A2A),
    disabledOnSecondary: Color(0x80E8E8E8),
    muted: Color(0xFF2A2A2A),
    onMuted: Color(0xFFA0A0A0),
    background: Color(0xFF121212),
    onBackground: Color(0xFFE8E8E8),
    card: Color(0xFF1E1E1E),
    onCard: Color(0xFFE8E8E8),
    accent: Color(0xFF2A2A2A),
    onAccent: Color(0xFFFF385C),
    destructive: Color(0xFFF43F5E),
    onDestructive: Color(0xFFE8E8E8),
    success: Color(0xFF1B5E20),
    onSuccess: Color(0xFFE8E8E8),
    focusRing: Color(0xFFFF385C),
    border: Color(0xFF2A2A2A),
    inputBorder: Color(0x00FFFFFF),
    inputBackground: Color(0xFF2A2A2A),
    dropdownBackground: Color(0xFF1E1E1E),
    onDropdownBackground: Color(0xFFE8E8E8),
    textFieldPlaceholder: Color(0xFFA0A0A0),
    upcoming: Color(0xFF1447E6),
    ongoing: Color(0xFF008236),
    completed: Color(0xFF8200DB),
  );

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? disabledPrimary,
    Color? disabledOnPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? disabledSecondary,
    Color? disabledOnSecondary,
    Color? muted,
    Color? onMuted,
    Color? background,
    Color? onBackground,
    Color? card,
    Color? onCard,
    Color? accent,
    Color? onAccent,
    Color? destructive,
    Color? onDestructive,
    Color? success,
    Color? onSuccess,
    Color? focusRing,
    Color? border,
    Color? inputBorder,
    Color? inputBackground,
    Color? dropdownBackground,
    Color? onDropdownBackground,
    Color? textFieldPlaceholder,
    Color? upcoming,
    Color? ongoing,
    Color? completed,
  }) {
    return CustomColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      disabledPrimary: disabledPrimary ?? this.disabledPrimary,
      disabledOnPrimary: disabledOnPrimary ?? this.disabledOnPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      disabledSecondary: disabledSecondary ?? this.disabledSecondary,
      disabledOnSecondary: disabledOnSecondary ?? this.disabledOnSecondary,
      muted: muted ?? this.muted,
      onMuted: onMuted ?? this.onMuted,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      card: card ?? this.card,
      onCard: onCard ?? this.onCard,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      destructive: destructive ?? this.destructive,
      onDestructive: onDestructive ?? this.onDestructive,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      focusRing: focusRing ?? this.focusRing,
      border: border ?? this.border,
      inputBorder: inputBorder ?? this.inputBorder,
      inputBackground: inputBackground ?? this.inputBackground,
      dropdownBackground: dropdownBackground ?? this.dropdownBackground,
      onDropdownBackground: onDropdownBackground ?? this.onDropdownBackground,
      textFieldPlaceholder: textFieldPlaceholder ?? this.textFieldPlaceholder,
      upcoming: upcoming ?? this.upcoming,
      ongoing: ongoing ?? this.ongoing,
      completed: completed ?? this.completed,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    covariant ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) {
      return this;
    } else {
      return CustomColors(
        primary: Color.lerp(primary, other.primary, t) ?? primary,
        onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
        disabledPrimary:
            Color.lerp(disabledPrimary, other.disabledPrimary, t) ??
            disabledPrimary,
        disabledOnPrimary:
            Color.lerp(disabledOnPrimary, other.disabledOnPrimary, t) ??
            disabledOnPrimary,
        secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
        onSecondary:
            Color.lerp(onSecondary, other.onSecondary, t) ?? onSecondary,
        disabledSecondary:
            Color.lerp(disabledSecondary, other.disabledSecondary, t) ??
            disabledSecondary,
        disabledOnSecondary:
            Color.lerp(disabledOnSecondary, other.disabledOnSecondary, t) ??
            disabledOnSecondary,
        muted: Color.lerp(muted, other.muted, t) ?? muted,
        onMuted: Color.lerp(onMuted, other.onMuted, t) ?? onMuted,
        background: Color.lerp(background, other.background, t) ?? background,
        onBackground:
            Color.lerp(onBackground, other.onBackground, t) ?? onBackground,
        card: Color.lerp(card, other.card, t) ?? card,
        onCard: Color.lerp(onCard, other.onCard, t) ?? onCard,
        accent: Color.lerp(accent, other.accent, t) ?? accent,
        onAccent: Color.lerp(onAccent, other.onAccent, t) ?? onAccent,
        destructive:
            Color.lerp(destructive, other.destructive, t) ?? destructive,
        onDestructive:
            Color.lerp(onDestructive, other.onDestructive, t) ?? onDestructive,
        success: Color.lerp(success, other.success, t) ?? success,
        onSuccess: Color.lerp(onSuccess, other.onSuccess, t) ?? onSuccess,
        focusRing: Color.lerp(focusRing, other.focusRing, t) ?? focusRing,
        border: Color.lerp(border, other.border, t) ?? border,
        inputBorder:
            Color.lerp(inputBorder, other.inputBorder, t) ?? inputBorder,
        inputBackground:
            Color.lerp(inputBackground, other.inputBackground, t) ??
            inputBackground,
        dropdownBackground:
            Color.lerp(dropdownBackground, other.dropdownBackground, t) ??
            dropdownBackground,
        onDropdownBackground:
            Color.lerp(onDropdownBackground, other.onDropdownBackground, t) ??
            onDropdownBackground,
        textFieldPlaceholder:
            Color.lerp(textFieldPlaceholder, other.textFieldPlaceholder, t) ??
            textFieldPlaceholder,
        upcoming: Color.lerp(upcoming, other.upcoming, t) ?? upcoming,
        ongoing: Color.lerp(ongoing, other.ongoing, t) ?? ongoing,
        completed: Color.lerp(completed, other.completed, t) ?? completed,
      );
    }
  }
}
