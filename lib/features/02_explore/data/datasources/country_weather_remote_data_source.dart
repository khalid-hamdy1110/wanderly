import 'package:wanderly/core/network/open_weather_service.dart';
import 'package:wanderly/features/02_explore/data/models/country_weather_model.dart';

abstract interface class CountryWeatherRemoteDataSource {
  Future<CountryWeatherModel> getCountryWeather({
    required double latitude,
    required double longitude,
  });
}

class CountryWeatherRemoteDataSourceImpl
    implements CountryWeatherRemoteDataSource {
  final OpenWeatherService openWeatherService;

  CountryWeatherRemoteDataSourceImpl({required this.openWeatherService});

  @override
  Future<CountryWeatherModel> getCountryWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherJson = await openWeatherService.getCountryWeather(
      latitude: latitude,
      longitude: longitude,
    );
    return CountryWeatherModel.fromJson(weatherJson);
  }
}