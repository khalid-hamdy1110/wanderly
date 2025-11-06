import 'package:wanderly/core/domain/entities/country.dart';

extension CountryExtension on Country {
  String get briefInfo {
    final capitalText = capital != 'N/A' ? ' Its capital is $capital.' : '';
    return '$name is located in the $region region.$capitalText It also has a population of $population.';
  }
}