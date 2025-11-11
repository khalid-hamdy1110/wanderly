import 'package:wanderly/features/04_my_trips/domain/repositories/expense_repository.dart';

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  void call(int id) {
    repository.deleteExpense(id);
  }
}