import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String code;
  final String name;
  final String flagUrl;
  final String capital;
  final String region;
  final int population;
  final List<String> languages;
  final List<String> currencies;
  final List<String> timezones;
  final double latitude;
  final double longitude;

  const Country({
    required this.code,
    required this.name,
    required this.flagUrl,
    required this.capital,
    required this.region,
    required this.population,
    required this.languages,
    required this.currencies,
    required this.timezones,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    name,
    capital,
    region,
    population,
    languages,
    currencies,
    timezones,
    latitude,
    longitude,
  ];
}
