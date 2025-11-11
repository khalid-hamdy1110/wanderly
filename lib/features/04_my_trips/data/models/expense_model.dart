
import 'package:objectbox/objectbox.dart';
import 'package:wanderly/features/04_my_trips/data/models/trip_model.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';

@Entity()
class ExpenseModel {
  @Id()
  int id = 0;

  final String title;
  final double amount;
  final String category;
  final int dateEpoch;

  final trip = ToOne<TripModel>();

  ExpenseModel({
    this.id = 0,
    required this.title,
    required this.amount,
    required this.category,
    required this.dateEpoch,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: 0,
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      dateEpoch: expense.date.millisecondsSinceEpoch,
    );
  }

  Expense toEntity(String tripId) {
    return Expense(
      id: id,
      tripId: tripId,
      title: title,
      amount: amount,
      category: category,
      date: DateTime.fromMillisecondsSinceEpoch(dateEpoch),
    );
  }
}