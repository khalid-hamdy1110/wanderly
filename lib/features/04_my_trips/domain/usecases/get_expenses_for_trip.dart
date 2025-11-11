import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/expense_repository.dart';

class GetExpensesForTrip {
  final ExpenseRepository repository;

  GetExpensesForTrip(this.repository);

  List<Expense> call(String tripId) {
    return repository.getExpensesForTrip(tripId);
  }
}