import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/data/models/country_model.dart';
import 'package:wanderly/features/04_my_trips/data/models/expense_model.dart';
import 'package:wanderly/features/04_my_trips/data/models/trip_model.dart';

class ClearCache {
  final SharedPreferencesWithCache prefs;
  final Box<CountryModel> countryBox;
  final Box<TripModel> tripBox;
  final Box<ExpenseModel> expenseBox;

  ClearCache({required this.prefs, required this.countryBox, required this.tripBox, required this.expenseBox});

  Future<void> call() async {
    await prefs.clear();

    countryBox.removeAll();
    tripBox.removeAll();
    expenseBox.removeAll();
  }
}