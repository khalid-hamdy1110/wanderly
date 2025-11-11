import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final String tripId;
  final String countryName;
  final double countryLatitude;
  final double countryLongitude;
  final String title;
  final DateTime startDate;
  final double budget;
  final String budgetCurrency;
  final String destinationCurrency;
  final String? notes;
  final DateTime endDate;
  final bool isManuallyCompleted;

  const Trip({
    required this.tripId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.countryName,
    required this.countryLatitude,
    required this.countryLongitude,
    required this.budget,
    required this.budgetCurrency,
    required this.destinationCurrency,
    this.notes,
    this.isManuallyCompleted = false,
  });

  @override
  List<Object?> get props => [
        tripId,
        title,
        startDate,
        endDate,
        countryName,
        countryLatitude,
        countryLongitude,
        budget,
        budgetCurrency,
        destinationCurrency,
        notes,
        isManuallyCompleted,
      ];
}