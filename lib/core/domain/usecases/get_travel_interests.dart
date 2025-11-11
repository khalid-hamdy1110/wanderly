import 'package:wanderly/core/domain/repositories/settings_repository.dart';

class GetTravelInterests {
  final SettingsRepository repository;

  GetTravelInterests(this.repository);

  List<String> call() {
    return repository.getTravelInterests();
  }
}