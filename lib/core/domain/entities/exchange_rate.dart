import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String currency;
  final double rate;

  const ExchangeRate({
    required this.currency,
    required this.rate,
  });

  @override
  List<Object?> get props => [currency, rate];
}