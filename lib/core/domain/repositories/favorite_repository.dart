import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/error/failures.dart';

abstract interface class FavoriteRepository {
  Future<Either<Failure, void>> toggleFavoriteCountry(Country country);
  Future<Either<Failure, List<Country>>> getFavoriteCountries();
}