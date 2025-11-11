import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class SetPreferredCurrency {
  final SettingsRepository repository;

  SetPreferredCurrency(this.repository);

  Future<void> call(String currencyCode) async {
    return await repository.setPreferredCurrency(currencyCode);
  }
}