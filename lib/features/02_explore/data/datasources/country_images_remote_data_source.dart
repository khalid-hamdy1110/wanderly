import 'package:wanderly/core/network/unsplash_service.dart';
import 'package:wanderly/features/02_explore/data/models/country_image_model.dart';

abstract interface class CountryImagesRemoteDataSource {
  Future<List<CountryImageModel>> getCountryImages(String countryName);
}

class CountryImagesRemoteDataSourceImpl implements CountryImagesRemoteDataSource {

  final UnsplashService unsplashService;

  CountryImagesRemoteDataSourceImpl({required this.unsplashService});

  @override
  Future<List<CountryImageModel>> getCountryImages(String countryName) async {
    final response = await unsplashService.getCountryImages(countryName: countryName);
    return (response['results'] as List<dynamic>)
        .map((json) => CountryImageModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}