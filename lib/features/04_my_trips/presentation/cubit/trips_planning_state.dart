import 'package:equatable/equatable.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';

sealed class TripsPlanningState extends Equatable {
  const TripsPlanningState();

  @override
  List<Object?> get props => [];
}

class TripsPlanningInitial extends TripsPlanningState {}

class TripsPlanningLoading extends TripsPlanningState {}

class TripsPlanningLoaded extends TripsPlanningState {
  final List<Trip> trips;

  const TripsPlanningLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

class TripsPlanningError extends TripsPlanningState {
  final String message;

  const TripsPlanningError(this.message);

  @override
  List<Object?> get props => [message];
}