import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/trip_repository.dart';

class AddTrip {
  final TripRepository repository;

  AddTrip(this.repository);

  void call(Trip trip) {
    repository.addTrip(trip);
  }
}