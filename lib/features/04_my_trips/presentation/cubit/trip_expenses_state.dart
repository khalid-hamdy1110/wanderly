import 'package:equatable/equatable.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';

sealed class TripExpensesState extends Equatable {
  const TripExpensesState();

  @override
  List<Object?> get props => [];
}

class TripExpensesInitial extends TripExpensesState {}

class TripExpensesLoading extends TripExpensesState {}

class TripExpensesLoaded extends TripExpensesState {
  final List<Expense> expenses;

  const TripExpensesLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class TripExpensesError extends TripExpensesState {
  final String message;

  const TripExpensesError(this.message);

  @override
  List<Object?> get props => [message];
}