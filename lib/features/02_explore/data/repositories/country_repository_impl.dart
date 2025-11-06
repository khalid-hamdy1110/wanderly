import 'package:dartz/dartz.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/features/02_explore/data/datasources/country_remote_data_source.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;

  CountryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Country>>> getAllCountries() async {
    try {
      final countryModels = await remoteDataSource.getAllCountries();
      return Right(countryModels.map((model) => model.toEntity()).toList());
    } on Failure catch(failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch countries: ${e.toString()}'));
    }
  }
}