
import 'package:dartz/dartz.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_repository.dart';

class GetAllCountries {

  final CountryRepository repository;

  GetAllCountries(this.repository);

  Future<Either<Failure, List<Country>>> call() async {
    return await repository.getAllCountries();
  }
}