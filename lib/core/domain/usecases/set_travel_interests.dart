import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class SetTravelInterests {
  final SettingsRepository repository;

  SetTravelInterests(this.repository);

  Future<void> call(List<String> interests) async {
    return await repository.setTravelInterests(interests);
  }
}