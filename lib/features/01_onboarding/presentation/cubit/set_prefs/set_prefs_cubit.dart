import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/usecases/get_supported_currencies.dart';
import 'package:wanderly/core/domain/usecases/set_onboarding_completed.dart';
import 'package:wanderly/core/domain/usecases/set_preferred_currency.dart';
import 'package:wanderly/core/domain/usecases/set_travel_interests.dart';
import 'package:wanderly/core/domain/usecases/set_username.dart';
import 'package:wanderly/features/01_onboarding/presentation/cubit/set_prefs/set_prefs_state.dart';

class SetPrefsCubit extends Cubit<SetPrefsState> {
  SetPrefsCubit({
    required this.setUsername,
    required this.setOnboardingCompleted,
    required this.setPreferredCurrency,
    required this.setTravelInterests,
    required this.getSupportedCurrencies,
  }) : super(SetPrefsInitial());

  final SetUsername setUsername;
  final SetOnboardingCompleted setOnboardingCompleted; 
  final SetPreferredCurrency setPreferredCurrency;
  final SetTravelInterests setTravelInterests;
  final GetSupportedCurrencies getSupportedCurrencies;

  Future<void> setUsernamePref(String username) async {
    emit(SetPrefsLoading());
    try {
      await setUsername(username);
      emit(const SetPrefsSuccess());
    } catch (e) {
      emit(SetPrefsError('Failed to set username preference: $e'));
    }
  }

  Future<void> completeOnboarding(bool completed) async {
    emit(SetPrefsLoading());
    try {
      await setOnboardingCompleted(completed);
      emit(const SetPrefsSuccess());
    } catch (e) {
      emit(SetPrefsError('Failed to set onboarding preference: $e'));
    }
  }

  Future<void> setPreferredCurrencyPref(String currency) async {
    emit(SetPrefsLoading());
    try {
      await setPreferredCurrency(currency);
      emit(const SetPrefsSuccess());
    } catch (e) {
      emit(SetPrefsError('Failed to set preferred currency: $e'));
    }
  }

  Future<void> setTravelInterestsPref(List<String> interests) async {
    emit(SetPrefsLoading());
    try {
      await setTravelInterests(interests);
      emit(const SetPrefsSuccess());
    } catch (e) {
      emit(SetPrefsError('Failed to set travel interests: $e'));
    }
  }

  Future<void> fetchSupportedCurrencies() async {
    emit(SetPrefsLoading());
    try {
      final result = await getSupportedCurrencies();
      result.fold(
        (failure) => emit(SetPrefsError('Failed to fetch supported currencies: ${failure.message}')),
        (currencies) => emit(SetPrefsSuccess(currencies: currencies)),
      );
    } catch (e) {
      emit(SetPrefsError('Failed to fetch supported currencies: $e'));
    }
  }

}