import 'package:objectbox/objectbox.dart';
import 'package:wanderly/core/domain/entities/country.dart';

@Entity()
class CountryModel {
  @Id()
  int id = 0;

  @Unique()
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

  CountryModel({
    this.id = 0,
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

  Country toEntity() {
    return Country(
      code: code,
      name: name,
      flagUrl: flagUrl,
      capital: capital,
      region: region,
      population: population,
      languages: languages,
      currencies: currencies,
      timezones: timezones,
      latitude: latitude,
      longitude: longitude,
    );
  }

  factory CountryModel.fromEntity(Country country) {
    return CountryModel(
      id: 0,
      code: country.code,
      name: country.name,
      flagUrl: country.flagUrl,
      capital: country.capital,
      region: country.region,
      population: country.population,
      languages: country.languages,
      currencies: country.currencies,
      timezones: country.timezones,
      latitude: country.latitude,
      longitude: country.longitude,
    );
  }

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final code = json['cca2'] as String;
    final name = json['name']['common'] as String;
    final flagUrl = json['flags']['png'] as String;
    final latitude = (json['latlng'][0] as num).toDouble();
    final longitude = (json['latlng'][1] as num).toDouble();

    final capitalList = json['capital'] as List<dynamic>?;
    final capital = (capitalList != null && capitalList.isNotEmpty)
        ? capitalList[0] as String
        : 'N/A';

    final region = json['region'] as String;
    final population = (json['population'] as num).toInt();

    final languagesMap = json['languages'] as Map<String, dynamic>?;
    final languages = languagesMap != null
        ? languagesMap.values.map((lang) => lang as String).toList()
        : <String>[];

    final currenciesMap = json['currencies'] as Map<String, dynamic>?;
    final currencies = currenciesMap != null
        ? currenciesMap.keys.toList()
        : <String>[];

    final timezonesList = json['timezones'] as List<dynamic>?;
    final timezones = timezonesList != null
        ? timezonesList.map((tz) => tz as String).toList()
        : <String>[];

    return CountryModel(
      code: code,
      name: name,
      flagUrl: flagUrl,
      capital: capital,
      region: region,
      population: population,
      languages: languages,
      currencies: currencies,
      timezones: timezones,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': {'common': name},
      'flags': {'svg': flagUrl},
      'capital': [capital],
      'region': region,
      'population': population,
      'languages': {for (var lang in languages) lang: lang},
      'currencies': {for (var curr in currencies) curr: {}},
      'timezones': timezones,
      'latlng': [latitude, longitude],
    };
  }
}
