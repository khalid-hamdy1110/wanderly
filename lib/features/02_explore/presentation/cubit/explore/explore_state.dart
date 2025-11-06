import 'package:equatable/equatable.dart';
import 'package:wanderly/core/domain/entities/country.dart';

sealed class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<Country> countries;
  final List<Country> filteredCountries;
  final List<Country> favorites;

  const ExploreLoaded({required this.countries, required this.filteredCountries, required this.favorites});

  @override
  List<Object?> get props => [countries, filteredCountries, favorites];
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}