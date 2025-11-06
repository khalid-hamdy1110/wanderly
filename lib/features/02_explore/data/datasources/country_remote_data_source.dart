import 'package:wanderly/core/network/rest_countries_service.dart';
import 'package:wanderly/core/data/models/country_model.dart';

abstract interface class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final RestCountriesService restCountriesService;

  CountryRemoteDataSourceImpl({required this.restCountriesService});

  @override
  Future<List<CountryModel>> getAllCountries() async {
    final countryJsonList = await restCountriesService.getAllCountries();
    return countryJsonList
        .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}