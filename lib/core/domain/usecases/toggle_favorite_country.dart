import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/repositories/favorite_repository.dart';
import 'package:wanderly/core/error/failures.dart';

class ToggleFavoriteCountry {
  final FavoriteRepository repository;

  ToggleFavoriteCountry(this.repository);

  Future<Either<Failure, void>> call(Country country) {
    return repository.toggleFavoriteCountry(country);
  }
}