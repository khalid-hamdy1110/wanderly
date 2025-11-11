import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/trip_repository.dart';

class GetAllTrips {
  final TripRepository repository;

  GetAllTrips(this.repository);

  List<Trip> call() {
    return repository.getAllTrips();
  }
}