import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class SetIsDarkMode {
  final SettingsRepository repository;

  SetIsDarkMode(this.repository);

  Future<void> call(bool isDarkMode) {
    return repository.setIsDarkMode(isDarkMode);
  }
}