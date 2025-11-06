import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';

class CountryWeatherModel extends CountryWeather {
  const CountryWeatherModel({
    required super.countryName,
    required super.temperature,
    required super.weatherDescription,
    required super.windSpeed,
    required super.humidity,
  });

  factory CountryWeatherModel.fromJson(Map<String, dynamic> json) {
    return CountryWeatherModel(
      countryName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      weatherDescription: json['weather'][0]['description'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': countryName,
      'main': {'temp': temperature, 'humidity': humidity},
      'weather': [
        {'description': weatherDescription},
      ],
      'wind': {'speed': windSpeed},
    };
  }
}
