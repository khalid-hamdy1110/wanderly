import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/data/datasources/exchange_rate_remote_data_source.dart';
import 'package:wanderly/core/data/repositories/exchange_rate_repository_impl.dart';
import 'package:wanderly/core/data/repositories/favorite_repository_impl.dart';
import 'package:wanderly/core/data/repositories/settings_repository_impl.dart';
import 'package:wanderly/core/database/objectbox.dart';
import 'package:wanderly/core/domain/repositories/exchange_rate_repository.dart';
import 'package:wanderly/core/domain/repositories/favorite_repository.dart';
import 'package:wanderly/core/domain/repositories/settings_repository.dart';
import 'package:wanderly/core/domain/usecases/clear_cache.dart';
import 'package:wanderly/core/domain/usecases/get_exchange_rate.dart';
import 'package:wanderly/core/domain/usecases/get_favorite_countries.dart';
import 'package:wanderly/core/domain/usecases/get_preferred_currency.dart';
import 'package:wanderly/core/domain/usecases/get_supported_currencies.dart';
import 'package:wanderly/core/domain/usecases/get_travel_interests.dart';
import 'package:wanderly/core/domain/usecases/get_username.dart';
import 'package:wanderly/core/domain/usecases/is_dark_mode.dart';
import 'package:wanderly/core/domain/usecases/is_onboarding_completed.dart';
import 'package:wanderly/core/domain/usecases/set_is_dark_mode.dart';
import 'package:wanderly/core/domain/usecases/set_onboarding_completed.dart';
import 'package:wanderly/core/domain/usecases/set_preferred_currency.dart';
import 'package:wanderly/core/domain/usecases/set_travel_interests.dart';
import 'package:wanderly/core/domain/usecases/set_username.dart';
import 'package:wanderly/core/domain/usecases/toggle_favorite_country.dart';
import 'package:wanderly/core/network/exchange_rate_service.dart';
import 'package:wanderly/core/network/open_weather_service.dart';
import 'package:wanderly/core/network/rest_countries_service.dart';
import 'package:wanderly/core/network/unsplash_service.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_cubit.dart';
import 'package:wanderly/features/01_onboarding/presentation/cubit/set_prefs/set_prefs_cubit.dart';
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
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_cubit.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_cubit.dart';
import 'package:wanderly/features/04_my_trips/data/models/expense_model.dart';
import 'package:wanderly/features/04_my_trips/data/models/trip_model.dart';
import 'package:wanderly/features/04_my_trips/data/repositories/expense_repository_impl.dart';
import 'package:wanderly/features/04_my_trips/data/repositories/trip_repository_impl.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/expense_repository.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/trip_repository.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/add_expense.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/add_trip.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/delete_expense.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/delete_trip.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/get_all_trips.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/get_expenses_for_trip.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/update_trip.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trip_expenses_cubit.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_cubit.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Core dependencies
  di.registerLazySingleton(() => Dio());

  di.registerLazySingleton(() => AutoRouteObserver());

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  di.registerLazySingleton(() => prefs);

  // ObjectBox
  await initObjectBox();
  di.registerLazySingleton(() => objectBoxStore);

  // CountryModel box
  di.registerLazySingleton<Box<CountryModel>>(
    () => di<Store>().box<CountryModel>(),
  );

  // TripModel box
  di.registerLazySingleton<Box<TripModel>>(() => di<Store>().box<TripModel>());

  // ExpenseModel box
  di.registerLazySingleton<Box<ExpenseModel>>(
    () => di<Store>().box<ExpenseModel>(),
  );

  // Services
  di.registerLazySingleton(() => RestCountriesService(di(), di()));
  di.registerLazySingleton(() => OpenWeatherService(di(), di()));
  di.registerLazySingleton(() => UnsplashService(di(), di()));
  di.registerLazySingleton(() => ExchangeRateService(di()));

  // Data sources
  di.registerLazySingleton<CountryRemoteDataSource>(
    () => CountryRemoteDataSourceImpl(restCountriesService: di()),
  );
  di.registerLazySingleton<CountryImagesRemoteDataSource>(
    () => CountryImagesRemoteDataSourceImpl(unsplashService: di()),
  );
  di.registerLazySingleton<CountryWeatherRemoteDataSource>(
    () => CountryWeatherRemoteDataSourceImpl(openWeatherService: di()),
  );
  di.registerLazySingleton<ExchangeRateRemoteDataSource>(
    () => ExchangeRateRemoteDataSourceImpl(exchangeRateService: di()),
  );

  // Repositories
  di.registerLazySingleton<CountryRepository>(
    () => CountryRepositoryImpl(remoteDataSource: di()),
  );
  di.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(box: di()),
  );
  di.registerLazySingleton<CountryImagesRepository>(
    () => CountryImagesRepositoryImpl(countryImagesRemoteDataSource: di()),
  );
  di.registerLazySingleton<CountryWeatherRepository>(
    () => CountryWeatherRepositoryImpl(countryWeatherRemoteDataSource: di()),
  );
  di.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(di()));
  di.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(prefs: di()),
  );
  di.registerLazySingleton<ExchangeRateRepository>(
    () => ExchangeRateRepositoryImpl(remoteDataSource: di()),
  );
  di.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(di(), di()),
  );

  // Use cases
  di.registerLazySingleton(() => GetAllCountries(di()));
  di.registerLazySingleton(() => GetFavoriteCountries(di()));
  di.registerLazySingleton(() => ToggleFavoriteCountry(di()));
  di.registerLazySingleton(() => GetCountryWeather(di()));
  di.registerLazySingleton(() => GetCountryImages(di()));
  di.registerLazySingleton(() => GetAllTrips(di()));
  di.registerLazySingleton(() => AddTrip(di()));
  di.registerLazySingleton(() => DeleteTrip(di()));
  di.registerLazySingleton(() => UpdateTrip(di()));
  di.registerLazySingleton(() => GetExchangeRate(di()));
  di.registerLazySingleton(() => IsOnboardingCompleted(di()));
  di.registerLazySingleton(() => SetOnboardingCompleted(di()));
  di.registerLazySingleton(() => GetUsername(di()));
  di.registerLazySingleton(() => SetUsername(di()));
  di.registerLazySingleton(() => GetPreferredCurrency(di()));
  di.registerLazySingleton(() => SetPreferredCurrency(di()));
  di.registerLazySingleton(() => GetTravelInterests(di()));
  di.registerLazySingleton(() => SetTravelInterests(di()));
  di.registerLazySingleton(
    () => ClearCache(
      prefs: di(),
      countryBox: di(),
      tripBox: di(),
      expenseBox: di(),
    ),
  );
  di.registerLazySingleton(() => GetSupportedCurrencies(di()));
  di.registerLazySingleton(() => AddExpense(di()));
  di.registerLazySingleton(() => DeleteExpense(di()));
  di.registerLazySingleton(() => GetExpensesForTrip(di()));
  di.registerLazySingleton(() => SetIsDarkMode(di()));
  di.registerLazySingleton(() => IsDarkMode(di()));

  // Cubits
  di.registerFactory(() => ExploreCubit(di(), di()));
  di.registerFactory(() => ImagesCubit(di()));
  di.registerFactory(() => WeatherCubit(di()));
  di.registerFactory(() => TripsPlanningCubit(di(), di(), di(), di()));
  di.registerFactory(() => ExchangeRateCubit(getExchangeRate: di()));
  di.registerLazySingleton(
    () => SettingsCubit(
      getUsername: di(),
      setUsername: di(),
      getPreferredCurrency: di(),
      setPreferredCurrency: di(),
      getTravelInterests: di(),
      setTravelInterests: di(),
      isOnboardingCompleted: di(),
      setOnboardingCompleted: di(),
      isDarkMode: di(),
      setIsDarkMode: di(),
    ),
  );
  di.registerFactory(() => ProfileStatsCubit(di(), di()));
  di.registerFactory(
    () => SetPrefsCubit(
      setUsername: di(),
      setOnboardingCompleted: di(),
      setPreferredCurrency: di(),
      setTravelInterests: di(),
      getSupportedCurrencies: di(),
    ),
  );
  di.registerFactory(() => FavoritesCubit(di(), di()));
  di.registerFactory(() => TripExpensesCubit(di(), di(), di()));
}
