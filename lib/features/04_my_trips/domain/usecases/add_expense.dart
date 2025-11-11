import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';
import 'package:wanderly/features/04_my_trips/domain/repositories/expense_repository.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  void call(Expense expense) {
    repository.addExpense(expense);
  }
}