import 'package:equatable/equatable.dart';
import 'package:wanderly/core/error/failures.dart';

// Sealed union state for profile stats
sealed class ProfileStatsState extends Equatable {
  const ProfileStatsState();

  @override
  List<Object?> get props => [];
}

class ProfileStatsInitial extends ProfileStatsState {}

class ProfileStatsLoading extends ProfileStatsState {}

class ProfileStatsLoaded extends ProfileStatsState {
  final int totalTrips;
  final int countriesExplored;
  final int favoritesCount;
  const ProfileStatsLoaded({
    required this.totalTrips,
    required this.countriesExplored,
    required this.favoritesCount,
  });

  @override
  List<Object?> get props => [totalTrips, countriesExplored, favoritesCount];
}

class ProfileStatsError extends ProfileStatsState {
  final Failure failure;
  const ProfileStatsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
