import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class SetOnboardingCompleted {
  final SettingsRepository repository;

  SetOnboardingCompleted(this.repository);

  Future<void> call(bool completed) async {
    return await repository.setOnboardingCompleted(completed);
  }
}