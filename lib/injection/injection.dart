import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/data/repositories/favorite_repository_impl.dart';
import 'package:wanderly/core/database/objectbox.dart';
import 'package:wanderly/core/domain/repositories/favorite_repository.dart';
import 'package:wanderly/core/domain/usecases/get_favorite_countries.dart';
import 'package:wanderly/core/domain/usecases/toggle_favorite_country.dart';
import 'package:wanderly/core/network/exchange_rate_service.dart';
import 'package:wanderly/core/network/open_weather_service.dart';
import 'package:wanderly/core/network/rest_countries_service.dart';
import 'package:wanderly/core/network/unsplash_service.dart';
import 'package:wanderly/features/02_explore/data/datasources/country_images_remote_data_source.dart';
import 'package:wanderly/features/02_explore/data/datasources/country_remote_data_source.dart';
import 'package:wanderly/core/data/models/country_model.dart';
import 'package:wanderly/features/02_explore/data/datasources/country_weather_remote_data_source.dart';
import 'package:wanderly/features/02_explore/data/repositories/counrtry_images_repository_impl.dart';
import 'package:wanderly/features/02_explore/data/repositories/country_repository_impl.dart';
import 'package:wanderly/features/02_explore/data/repositories/country_weather_repository_impl.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_images_repository.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_repository.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_weather_repository.dart';
import 'package:wanderly/features/02_explore/domain/usecases/get_all_countries.dart';
import 'package:wanderly/features/02_explore/domain/usecases/get_country_images.dart';
import 'package:wanderly/features/02_explore/domain/usecases/get_country_weather.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/images_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/weather_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_cubit.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Core dependencies
  di.registerLazySingleton(() => Dio());

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  di.registerLazySingleton(() => prefs);

  // ObjectBox
  await initObjectBox();
  di.registerLazySingleton(() => objectBoxStore);

  // CountryModel box
  di.registerLazySingleton<Box<CountryModel>>(() => di<Store>().box<CountryModel>());

  // Services
  di.registerLazySingleton(() => RestCountriesService(di(), di()));
  di.registerLazySingleton(() => OpenWeatherService(di(), di()));
  di.registerLazySingleton(() => UnsplashService(di(), di()));
  di.registerLazySingleton(() => ExchangeRateService(di()));

  // Data sources
  di.registerLazySingleton<CountryRemoteDataSource>(() => CountryRemoteDataSourceImpl(restCountriesService: di()));
  di.registerLazySingleton<CountryImagesRemoteDataSource>(() => CountryImagesRemoteDataSourceImpl(unsplashService: di()));
  di.registerLazySingleton<CountryWeatherRemoteDataSource>(() => CountryWeatherRemoteDataSourceImpl(openWeatherService: di()));

  // Repositories
  di.registerLazySingleton<CountryRepository>(
      () => CountryRepositoryImpl(remoteDataSource: di()));

  di.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(box: di()));
  di.registerLazySingleton<CountryImagesRepository>(() => CountryImagesRepositoryImpl(countryImagesRemoteDataSource: di()));
  di.registerLazySingleton<CountryWeatherRepository>(() => CountryWeatherRepositoryImpl(countryWeatherRemoteDataSource: di()));

  // Use cases
  di.registerLazySingleton(() => GetAllCountries(di()));
  di.registerLazySingleton(() => GetFavoriteCountries(di()));
  di.registerLazySingleton(() => ToggleFavoriteCountry(di()));
  di.registerLazySingleton(() => GetCountryWeather(di()));
  di.registerLazySingleton(() => GetCountryImages(di()));

  // Cubits
  di.registerFactory(() => ExploreCubit(di(), di(), di()));
  di.registerFactory(() => ImagesCubit(di()));
  di.registerFactory(() => WeatherCubit(di()));
}
