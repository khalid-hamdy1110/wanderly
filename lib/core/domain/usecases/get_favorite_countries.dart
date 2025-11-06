import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/repositories/favorite_repository.dart';
import 'package:wanderly/core/error/failures.dart';

class GetFavoriteCountries {
  final FavoriteRepository repository;

  GetFavoriteCountries(this.repository);

  Future<Either<Failure, List<Country>>> call() {
    return repository.getFavoriteCountries();
  }
}