import 'package:equatable/equatable.dart';
import 'package:wanderly/core/domain/entities/country.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Country> favoriteDestinations;
  final String sortKey; // 'alpha' | 'recent' | 'region'

  const FavoritesLoaded(this.favoriteDestinations, {this.sortKey = 'recent'});

  @override
  List<Object?> get props => [favoriteDestinations, sortKey];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
