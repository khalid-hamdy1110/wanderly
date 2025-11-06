import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/usecases/get_favorite_countries.dart';
import 'package:wanderly/core/domain/usecases/toggle_favorite_country.dart';
import 'package:wanderly/features/02_explore/domain/usecases/get_all_countries.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final GetAllCountries _getAllCountries;
  final GetFavoriteCountries _getFavoriteCountries;
  final ToggleFavoriteCountry _toggleFavoriteCountry;

  ExploreCubit(
    this._getAllCountries,
    this._getFavoriteCountries,
    this._toggleFavoriteCountry,
  ) : super(ExploreInitial());

  Future<void> fetchAllCountries() async {
    emit(ExploreLoading());

    final result = await _getAllCountries();
    final favoriteResult = await _getFavoriteCountries();

    result.fold((failure) => emit(ExploreError(failure.message)), (countries) {
      favoriteResult.fold(
        (favFailure) => emit(ExploreError(favFailure.message)),
        (favorites) {
          final shuffled = List<Country>.from(countries)..shuffle();

          emit(
            ExploreLoaded(
              countries: shuffled,
              filteredCountries: shuffled,
              favorites: favorites,
            ),
          );
        },
      );
    });
  }

  void filterCountries(String query) {
    final currentState = state;
    if (currentState is ExploreLoaded) {
      final filtered = currentState.countries
          .where(
            (country) =>
                country.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      emit(
        ExploreLoaded(
          countries: currentState.countries,
          filteredCountries: filtered,
          favorites: currentState.favorites,
        ),
      );
    }
  }

  Future<void> toggleFavorite(Country country) async {
    final currentState = state;
    if (currentState is ExploreLoaded) {
      final result = await _toggleFavoriteCountry(country);

      result.fold((failure) => emit(ExploreError(failure.message)), (_) async {
        final favoriteResult = await _getFavoriteCountries();
        favoriteResult.fold(
          (favFailure) => emit(ExploreError(favFailure.message)),
          (favorites) {
            emit(
              ExploreLoaded(
                countries: currentState.countries,
                filteredCountries: currentState.filteredCountries,
                favorites: favorites,
              ),
            );
          },
        );
      });
    }
  }
}
