import 'package:dartz/dartz.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/core/domain/entities/country.dart';

abstract interface class CountryRepository {
  Future<Either<Failure, List<Country>>> getAllCountries();
}