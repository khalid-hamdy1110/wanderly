import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String username;
  final String preferredCurrency;
  final List<String> travelInterests;
  final bool onboardingCompleted;

  const SettingsState({
    required this.username,
    required this.preferredCurrency,
    required this.travelInterests,
    required this.onboardingCompleted,
  });

  SettingsState copyWith({
    String? username,
    String? preferredCurrency,
    List<String>? travelInterests,
    bool? onboardingCompleted,
  }) {
    return SettingsState(
      username: username ?? this.username,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      travelInterests: travelInterests ?? this.travelInterests,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  List<Object?> get props => [
        username,
        preferredCurrency,
        travelInterests,
        onboardingCompleted,
      ];
}
