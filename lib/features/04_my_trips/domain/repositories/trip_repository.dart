import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';

abstract interface class TripRepository {
  void addTrip(Trip trip);
  List<Trip> getAllTrips();
  void updateTrip(Trip trip);
  void deleteTrip(String id);
}