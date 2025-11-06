import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/features/02_explore/data/datasources/country_weather_remote_data_source.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_weather_repository.dart';

class CountryWeatherRepositoryImpl implements CountryWeatherRepository {
  final CountryWeatherRemoteDataSource countryWeatherRemoteDataSource;

  CountryWeatherRepositoryImpl({required this.countryWeatherRemoteDataSource});

  @override
  Future<Either<Failure, CountryWeather>> getCountryWeather(
    Country country,
  ) async {
    try {
      final countryWeather = await countryWeatherRemoteDataSource
          .getCountryWeather(
            latitude: country.latitude,
            longitude: country.longitude,
          );
      return Right(countryWeather);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch country details: ${e.toString()}'),
      );
    }
  }
}
