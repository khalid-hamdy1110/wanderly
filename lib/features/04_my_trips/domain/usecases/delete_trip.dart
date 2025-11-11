import 'package:wanderly/features/04_my_trips/domain/repositories/trip_repository.dart';

class DeleteTrip {
  final TripRepository repository;

  DeleteTrip(this.repository);

  void call(String tripId) {
    repository.deleteTrip(tripId);
  }
}