import 'package:wanderly/features/04_my_trips/data/models/trip_model.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/trip_repository.dart';
import 'package:wanderly/objectbox.g.dart';

class TripRepositoryImpl implements TripRepository {
  
  final Box<TripModel> _box;

  TripRepositoryImpl(this._box);

  @override
  void addTrip(Trip trip) {
    final tripModel = TripModel.fromEntity(trip);
    _box.put(tripModel);
  }

  @override
  List<Trip> getAllTrips() {
    final tripModels = _box.getAll();
    return tripModels.map((model) => model.toEntity()).toList();
  }

  @override
  void updateTrip(Trip trip) {
    final q = _box.query(TripModel_.tripId.equals(trip.tripId)).build();
    final tripModel = q.findFirst();
    if (tripModel != null) {
      final updatedTripModel = TripModel.fromEntity(trip);
      updatedTripModel.id = tripModel.id;
      _box.put(updatedTripModel);
    }
    q.close();
  }

  @override
  void deleteTrip(String tripId) {  
    final q = _box.query(TripModel_.tripId.equals(tripId)).build();
    final tripModel = q.findFirst();
    if (tripModel != null) {
      _box.remove(tripModel.id);
    }
    q.close();
  }
}