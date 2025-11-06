import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';
import 'package:wanderly/features/02_explore/domain/usecases/get_country_weather.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/destination_details_state.dart';

class WeatherCubit extends Cubit<DestinationDetailsState<CountryWeather>> {

  final GetCountryWeather _getCountryWeather;

  WeatherCubit(this._getCountryWeather) : super(DestinationDetailsInitial());

  Future<void> loadCountryWeather(Country country) async {
    emit(DestinationDetailsLoading());

    final result = await _getCountryWeather(country);
    
    result.fold(
      (failure) => emit(DestinationDetailsError(failure.message)),
      (countryWeather) => emit(DestinationDetailsLoaded(countryWeather)),
    );
  }
}