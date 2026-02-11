import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String username;
  final String preferredCurrency;
  final List<String> travelInterests;
  final bool onboardingCompleted;
  final bool isDarkMode;

  const SettingsState({
    required this.username,
    required this.preferredCurrency,
    required this.travelInterests,
    required this.onboardingCompleted,
    required this.isDarkMode,
  });

  SettingsState copyWith({
    String? username,
    String? preferredCurrency,
    List<String>? travelInterests,
    bool? onboardingCompleted,
    bool? isDarkMode,
  }) {
    return SettingsState(
      username: username ?? this.username,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      travelInterests: travelInterests ?? this.travelInterests,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [
        username,
        preferredCurrency,
        travelInterests,
        onboardingCompleted,
        isDarkMode,
      ];
}
