import 'package:equatable/equatable.dart';

class CountryWeather extends Equatable {
  final String countryName;
  final double temperature;
  final String weatherDescription;
  final double windSpeed;
  final int humidity;

  const CountryWeather({
    required this.countryName,
    required this.temperature,
    required this.weatherDescription,
    required this.windSpeed,
    required this.humidity,
  });

  @override
  List<Object?> get props => [
    countryName,
    temperature,
    weatherDescription,
    windSpeed,
    humidity,
  ];
}
