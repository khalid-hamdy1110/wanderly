import 'package:freezed_annotation/freezed_annotation.dart';
part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
	const factory OnboardingState({
		@Default('') String name,
		@Default(0) int currentPage,
		@Default(4) int totalPages,
		String? selectedCurrencyDisplay,
    List<String>? selectedInterests,
	}) = _OnboardingState;
}

extension OnboardingStateX on OnboardingState {
	bool get hasName => name.trim().isNotEmpty;
  bool get isCurrencySeelected => selectedCurrencyDisplay != null;
  bool get hasSelectedInterests => selectedInterests != null && selectedInterests!.isNotEmpty;
	double get progress => (currentPage + 1) / totalPages;
}