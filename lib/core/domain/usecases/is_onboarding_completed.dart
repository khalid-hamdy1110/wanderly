import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class IsOnboardingCompleted {
  final SettingsRepository repository;

  IsOnboardingCompleted(this.repository);

  bool call() {
    return repository.isOnboardingCompleted();
  }
}