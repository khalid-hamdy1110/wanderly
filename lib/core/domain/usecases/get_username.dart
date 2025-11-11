import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class GetUsername {
  final SettingsRepository repository;

  GetUsername(this.repository);

  String call() {
    return repository.getUsername();
  }
}