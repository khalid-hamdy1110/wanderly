import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class IsDarkMode {
  final SettingsRepository repository;

  IsDarkMode(this.repository);

  bool call() {
    return repository.isDarkMode();
  }
}