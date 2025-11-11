import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/core/domain/usecases/get_favorite_countries.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/get_all_trips.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_state.dart';

class ProfileStatsCubit extends Cubit<ProfileStatsState> {
  final GetAllTrips _getAllTrips;
  final GetFavoriteCountries _getFavoriteCountries;

  ProfileStatsCubit(this._getAllTrips, this._getFavoriteCountries)
    : super(ProfileStatsInitial());

  Future<void> load() async {
    emit(ProfileStatsLoading());
    try {
      final trips = _getAllTrips();
      final favoritesEither = await _getFavoriteCountries();
      final favorites = favoritesEither.fold((l) {
        // Optional: log the non-critical failure and proceed.
        // debugPrint('Favorites load failed: ${l.message}');
        return <dynamic>[];
      }, (r) => r);

      final totalTrips = trips.length;
      final now = DateTime.now();
      final exploredCountries = <String>{};
      for (final Trip t in trips) {
        final ended = t.endDate.isBefore(now);
        if (ended || t.isManuallyCompleted) {
          exploredCountries.add(t.countryName);
        }
      }

      emit(
        ProfileStatsLoaded(
          totalTrips: totalTrips,
          countriesExplored: exploredCountries.length,
          favoritesCount: favorites.length,
        ),
      );
    } catch (e) {
      emit(ProfileStatsError(UnknownFailure(e.toString())));
    }
  }
}
