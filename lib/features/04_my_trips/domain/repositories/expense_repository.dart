import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';

abstract class ExpenseRepository {
  void addExpense(Expense expense);
  List<Expense> getExpensesForTrip(String tripId);
  void deleteExpense(int id);
}