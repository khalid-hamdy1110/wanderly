import 'package:wanderly/features/04_my_trips/data/models/expense_model.dart';
import 'package:wanderly/features/04_my_trips/data/models/trip_model.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/expense_repository.dart';
import 'package:wanderly/objectbox.g.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final Box<ExpenseModel> _expenseBox;
  final Box<TripModel> _tripBox;

  ExpenseRepositoryImpl(this._expenseBox, this._tripBox);

  @override
  void addExpense(Expense expense) {
    final expenseModel = ExpenseModel.fromEntity(expense);

    final tripQuery = _tripBox.query(TripModel_.tripId.equals(expense.tripId)).build();
    final tripModel = tripQuery.findFirst();
    tripQuery.close();

    if (tripModel != null) {
      expenseModel.trip.target = tripModel;
      _expenseBox.put(expenseModel);
    }
  }

  @override
  List<Expense> getExpensesForTrip(String tripId) {
    final tripQuery = _tripBox.query(TripModel_.tripId.equals(tripId)).build();
    final tripModel = tripQuery.findFirst();
    tripQuery.close();

    if (tripModel == null) {
      return [];
    }

    return tripModel.expenses
        .map((expenseModel) => expenseModel.toEntity(tripId))
        .toList();
  }

  @override
  void deleteExpense(int id) {
    _expenseBox.remove(id);
  }
}
