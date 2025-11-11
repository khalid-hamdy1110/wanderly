import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class GetPreferredCurrency {
  final SettingsRepository repository;

  GetPreferredCurrency(this.repository);

  String call() {
    return repository.getPreferredCurrency();
  }
}