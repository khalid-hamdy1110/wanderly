
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void updateName(String value) {
    if (value == state.name) return;
    emit(state.copyWith(name: value));
  }

  void nextPage() {
    if (state.currentPage < state.totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void prevPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void jumpToPage(int page) {
    if (page >= 0 && page < state.totalPages && page != state.currentPage) {
      emit(state.copyWith(currentPage: page));
    }
  }

  void selectCurrencyDisplay(String display) {
    if (display == state.selectedCurrencyDisplay) return;
    emit(state.copyWith(selectedCurrencyDisplay: display));
  }

  void toggleInterest(String interest) {
    final currentInterests = state.selectedInterests ?? [];
    if (currentInterests.contains(interest)) {
      final updatedInterests = List<String>.from(currentInterests)..remove(interest);
      emit(state.copyWith(selectedInterests: updatedInterests));
    } else {
      final updatedInterests = List<String>.from(currentInterests)..add(interest);
      emit(state.copyWith(selectedInterests: updatedInterests));
    }
  }

  void reset() {
    emit(const OnboardingState());
  }
}
