import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class SetUsername {
  final SettingsRepository repository;

  SetUsername(this.repository);

  Future<void> call(String username) async {
    return await repository.setUsername(username);
  }
}