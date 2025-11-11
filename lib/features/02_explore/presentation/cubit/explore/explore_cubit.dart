import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/usecases/get_favorite_countries.dart';
import 'package:wanderly/features/02_explore/domain/usecases/get_all_countries.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_state.dart';
import 'package:wanderly/core/constants/travel_interests.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final GetAllCountries _getAllCountries;
  final GetFavoriteCountries _getFavoriteCountries;

  ExploreCubit(this._getAllCountries, this._getFavoriteCountries)
    : super(ExploreInitial());

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
              searchQuery: '',
              selectedInterest: null,
            ),
          );
        },
      );
    });
  }

  void setSearchQuery(String query) {
    final currentState = state;
    if (currentState is ExploreLoaded) {
      _applyFilters(
        countries: currentState.countries,
        searchQuery: query,
        selectedInterest: currentState.selectedInterest,
      );
    }
  }

  void setSelectedInterest(String? interest) {
    final currentState = state;
    if (currentState is ExploreLoaded) {
      _applyFilters(
        countries: currentState.countries,
        searchQuery: currentState.searchQuery,
        selectedInterest: interest,
      );
    }
  }

  void _applyFilters({
    required List<Country> countries,
    required String searchQuery,
    required String? selectedInterest,
  }) {
    final lowerQuery = searchQuery.toLowerCase();
    final interestCountries = selectedInterest == null
        ? null
        : interestCountryMap[selectedInterest] ?? <String>[];

    final filtered = countries.where((country) {
      final matchesSearch = country.name.toLowerCase().contains(lowerQuery);
      final matchesInterest = interestCountries == null
          ? true
          : interestCountries.contains(country.name);
      return matchesSearch && matchesInterest;
    }).toList();

    emit(
      ExploreLoaded(
        countries: countries,
        filteredCountries: filtered,
        searchQuery: searchQuery,
        selectedInterest: selectedInterest,
      ),
    );
  }
}
