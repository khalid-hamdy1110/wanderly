import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferencesWithCache prefs;

  static const _keyUsername = 'username';
  static const _keyCurrency = 'preferred_currency';
  static const _keyInterests = 'travel_interests';
  static const _keyOnboarding = 'onboarding_completed';
  static const _keyDarkMode = 'is_dark_mode';

  SettingsRepositoryImpl({required this.prefs});

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await prefs.setBool(_keyOnboarding, completed);
  }

  @override
  bool isOnboardingCompleted() {
    return prefs.getBool(_keyOnboarding) ?? false;
  }

  @override
  Future<void> setUsername(String username) async {
    await prefs.setString(_keyUsername, username);
  }

  @override
  String getUsername() {
    return prefs.getString(_keyUsername) ?? 'User';
  }

  @override
  Future<void> setPreferredCurrency(String currency) async {
    await prefs.setString(_keyCurrency, currency);
  }

  @override
  String getPreferredCurrency() {
    return prefs.getString(_keyCurrency) ?? '';
  }

  @override
  Future<void> setTravelInterests(List<String> interests) async {
    await prefs.setStringList(_keyInterests, interests);
  }

  @override
  List<String> getTravelInterests() {
    return prefs.getStringList(_keyInterests) ?? [];
  }
  
  @override
  Future<void> setIsDarkMode(bool isDarkMode) {
    return prefs.setBool(_keyDarkMode, isDarkMode);
  }

  @override
  bool isDarkMode() {
    return prefs.getBool(_keyDarkMode) ?? false;
  }
}