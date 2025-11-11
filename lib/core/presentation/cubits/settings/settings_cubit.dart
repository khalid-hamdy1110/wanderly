import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/usecases/get_preferred_currency.dart';
import 'package:wanderly/core/domain/usecases/get_travel_interests.dart';
import 'package:wanderly/core/domain/usecases/get_username.dart';
import 'package:wanderly/core/domain/usecases/is_onboarding_completed.dart';
import 'package:wanderly/core/domain/usecases/set_onboarding_completed.dart';
import 'package:wanderly/core/domain/usecases/set_preferred_currency.dart';
import 'package:wanderly/core/domain/usecases/set_travel_interests.dart';
import 'package:wanderly/core/domain/usecases/set_username.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetUsername _getUsername;
  final SetUsername _setUsername;
  final GetPreferredCurrency _getPreferredCurrency;
  final SetPreferredCurrency _setPreferredCurrency;
  final GetTravelInterests _getTravelInterests;
  final SetTravelInterests _setTravelInterests;
  final IsOnboardingCompleted _isOnboardingCompleted;
  final SetOnboardingCompleted _setOnboardingCompleted;

  SettingsCubit({
    required GetUsername getUsername,
    required SetUsername setUsername,
    required GetPreferredCurrency getPreferredCurrency,
    required SetPreferredCurrency setPreferredCurrency,
    required GetTravelInterests getTravelInterests,
    required SetTravelInterests setTravelInterests,
    required IsOnboardingCompleted isOnboardingCompleted,
    required SetOnboardingCompleted setOnboardingCompleted,
  })  : _getUsername = getUsername,
        _setUsername = setUsername,
        _getPreferredCurrency = getPreferredCurrency,
        _setPreferredCurrency = setPreferredCurrency,
        _getTravelInterests = getTravelInterests,
        _setTravelInterests = setTravelInterests,
        _isOnboardingCompleted = isOnboardingCompleted,
        _setOnboardingCompleted = setOnboardingCompleted,
        super(
          SettingsState(
            username: getUsername(),
            preferredCurrency: getPreferredCurrency(),
            travelInterests: getTravelInterests(),
            onboardingCompleted: isOnboardingCompleted(),
          ),
        );

  Future<void> refresh() async {
    emit(
      SettingsState(
        username: _getUsername(),
        preferredCurrency: _getPreferredCurrency(),
        travelInterests: _getTravelInterests(),
        onboardingCompleted: _isOnboardingCompleted(),
      ),
    );
  }

  Future<void> setUsername(String username) async {
    await _setUsername(username);
    emit(state.copyWith(username: username));
  }

  Future<void> setPreferredCurrency(String currency) async {
    await _setPreferredCurrency(currency);
    emit(state.copyWith(preferredCurrency: currency));
  }

  Future<void> setTravelInterests(List<String> interests) async {
    await _setTravelInterests(interests);
    emit(state.copyWith(travelInterests: List<String>.from(interests)));
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _setOnboardingCompleted(completed);
    emit(state.copyWith(onboardingCompleted: completed));
  }
}
