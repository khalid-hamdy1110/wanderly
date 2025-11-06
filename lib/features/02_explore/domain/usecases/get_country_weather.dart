import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_weather_repository.dart';

class GetCountryWeather {
  
  final CountryWeatherRepository repository;

  GetCountryWeather(this.repository);

  Future<Either<Failure, CountryWeather>> call(Country country) {
    return repository.getCountryWeather(country);
  }
}