import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';

abstract interface class CountryWeatherRepository {
  Future<Either<Failure, CountryWeather>> getCountryWeather(Country country);
}
