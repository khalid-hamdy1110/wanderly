abstract interface class SettingsRepository {
  Future<void> setOnboardingCompleted(bool completed);
  bool isOnboardingCompleted();
  
  Future<void> setUsername(String username);
  String getUsername();

  Future<void> setPreferredCurrency(String currency);
  String getPreferredCurrency();

  Future<void> setTravelInterests(List<String> interests);
  List<String> getTravelInterests();
}