import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/usecases/get_favorite_countries.dart';
import 'package:wanderly/core/domain/usecases/toggle_favorite_country.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoriteCountries _getFavoriteCountries;
  final ToggleFavoriteCountry _toggleFavoriteCountry;
  List<Country> _baseFavorites = const [];

  FavoritesCubit(this._getFavoriteCountries, this._toggleFavoriteCountry)
    : super(FavoritesInitial());

  Future<void> fetchFavoriteCountries() async {
    emit(FavoritesLoading());

    final result = await _getFavoriteCountries();

    result.fold((failure) => emit(FavoritesError(failure.message)), (
      favorites,
    ) {
      _baseFavorites = List<Country>.from(favorites);
      emit(
        FavoritesLoaded(
          _sort(_baseFavorites, _currentSort),
          sortKey: _currentSort,
        ),
      );
    });
  }

  Future<void> toggleFavoriteStatus(Country country) async {
    if (state is! FavoritesLoaded) return;
    try {
      await _toggleFavoriteCountry(country);
      await fetchFavoriteCountries();
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  String _currentSort = 'recent';

  void setSort(String sortKey) {
    if (state is FavoritesLoaded) {
      _currentSort = sortKey;
      emit(FavoritesLoaded(_sort(_baseFavorites, sortKey), sortKey: sortKey));
    }
  }

  List<Country> _sort(List<Country> base, String sortKey) {
    final list = List<Country>.from(base);
    switch (sortKey) {
      case 'alpha':
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case 'region':
        list.sort(
          (a, b) => a.region.toLowerCase().compareTo(b.region.toLowerCase()),
        );
        break;
      case 'recent':
      default:
        // Keep the base order (assumed most-recent-first from repository).
        // No sorting; return a fresh copy to trigger UI updates if needed.
        break;
    }
    return list;
  }
}
