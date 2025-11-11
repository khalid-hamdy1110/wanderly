import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/add_expense.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/delete_expense.dart';
import 'package:wanderly/features/04_my_trips/domain/usecases/get_expenses_for_trip.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trip_expenses_state.dart';

class TripExpensesCubit extends Cubit<TripExpensesState> {
  final GetExpensesForTrip _getExpensesForTrip;
  final AddExpense _addExpense;
  final DeleteExpense _deleteExpense;

  TripExpensesCubit(
      this._getExpensesForTrip,
      this._addExpense,
      this._deleteExpense,
      ) : super(TripExpensesInitial());

  void loadExpenses(String tripId) {
    emit(TripExpensesLoading());
    try {
      final expenses = _getExpensesForTrip(tripId);
      emit(TripExpensesLoaded(expenses));
    } catch (e) {
      emit(const TripExpensesError('Failed to load expenses'));
    }
  }

  void addNewExpense(Expense expense) {
    try {
      _addExpense(expense);
      final expenses = _getExpensesForTrip(expense.tripId);
      emit(TripExpensesLoaded(expenses));
    } catch (e) {
      emit(const TripExpensesError('Failed to add expense'));
    }
  }

  void deleteExistingExpense(int id, String tripId) {
    try {
      _deleteExpense(id);
      final expenses = _getExpensesForTrip(tripId);
      emit(TripExpensesLoaded(expenses));
    } catch (e) {
      emit(const TripExpensesError('Failed to delete expense'));
    }
  }
}