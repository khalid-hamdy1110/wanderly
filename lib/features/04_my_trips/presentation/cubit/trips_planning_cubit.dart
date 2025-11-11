import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/add_trip.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/delete_trip.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/get_all_trips.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/update_trip.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_state.dart';

class TripsPlanningCubit extends Cubit<TripsPlanningState> {
  final AddTrip _addTrip;
  final GetAllTrips _getAllTrips;
  final DeleteTrip _deleteTrip;
  final UpdateTrip _updateTrip;

  TripsPlanningCubit(
    this._addTrip,
    this._getAllTrips,
    this._deleteTrip,
    this._updateTrip,
  ) : super(TripsPlanningInitial());

  void getAllTrips() {
    emit(TripsPlanningLoading());

    try {
      final trips = _getAllTrips();
      emit(TripsPlanningLoaded(trips));
    } catch (e) {
      emit(TripsPlanningError(e.toString()));
      return;
    }
  }

  void addTrip(Trip trip) {

    try {
      _addTrip(trip);
    } catch (e) {
      emit(TripsPlanningError(e.toString()));
      return;
    }
    getAllTrips();
  }

  void deleteTrip(String tripId) {
    try {
      _deleteTrip(tripId);
    } catch (e) {
      emit(TripsPlanningError(e.toString()));
      return;
    }
    getAllTrips();
  }

  void updateTrip(Trip trip) {
    try {
      _updateTrip(trip);
    } catch (e) {
      emit(TripsPlanningError(e.toString()));
      return;
    }
    getAllTrips();
  }
}