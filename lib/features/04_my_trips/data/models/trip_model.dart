import 'package:objectbox/objectbox.dart';
import 'package:wanderly/features/04_my_trips/data/models/expense_model.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';

@Entity()
class TripModel {

  @Id()
  int id = 0;

  @Unique()
  final String tripId;
  final String tripName;
  final String countryName;
  final double countryLatitude;
  final double countryLongitude;
  final int startDateEpoch;
  final int endDateEpoch;
  final double budget;
  final String budgetCurrency;
  final String destinationCurrency;
  final String? notes;
  final bool isManuallyCompleted;

  @Backlink('trip')
  final expenses = ToMany<ExpenseModel>();

  TripModel({
    this.id = 0,
    required this.tripId,
    required this.tripName,
    required this.countryName,
    required this.countryLatitude,
    required this.countryLongitude,
    required this.startDateEpoch,
    required this.endDateEpoch,
    required this.budget,
    required this.budgetCurrency,
    required this.destinationCurrency,
    this.notes,
    this.isManuallyCompleted = false,
  });

  Trip toEntity() {
    return Trip(
      tripId: tripId,
      title: tripName,
      startDate: DateTime.fromMillisecondsSinceEpoch(startDateEpoch),
      endDate: DateTime.fromMillisecondsSinceEpoch(endDateEpoch),
      countryName: countryName,
      countryLatitude: countryLatitude,
      countryLongitude: countryLongitude,
      budget: budget,
      budgetCurrency: budgetCurrency,
      destinationCurrency: destinationCurrency,
      notes: notes,
      isManuallyCompleted: isManuallyCompleted,
    );
  }

  factory TripModel.fromEntity(Trip trip) {
    return TripModel(
      id: 0,
      tripId: trip.tripId,
      tripName: trip.title,
      countryName: trip.countryName,
      countryLatitude: trip.countryLatitude,
      countryLongitude: trip.countryLongitude,
      startDateEpoch: trip.startDate.millisecondsSinceEpoch,
      endDateEpoch: trip.endDate.millisecondsSinceEpoch,
      budget: trip.budget,
      notes: trip.notes,
      budgetCurrency: trip.budgetCurrency,
      destinationCurrency: trip.destinationCurrency,
      isManuallyCompleted: trip.isManuallyCompleted,
    );
  }
}