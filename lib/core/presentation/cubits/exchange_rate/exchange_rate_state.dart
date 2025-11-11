import 'package:equatable/equatable.dart';
import 'package:wanderly/core/domain/entities/exchange_rate.dart';

sealed class ExchangeRateState extends Equatable {
  const ExchangeRateState();

  @override
  List<Object?> get props => [];
}

class ExchangeRateInitial extends ExchangeRateState {}

class ExchangeRateLoading extends ExchangeRateState {}

class ExchangeRateLoaded extends ExchangeRateState {
  final List<ExchangeRate> exchangeRate;

  const ExchangeRateLoaded(this.exchangeRate);

  @override
  List<Object?> get props => [exchangeRate];
}

class ExchangeRateError extends ExchangeRateState {
  final String message;

  const ExchangeRateError(this.message);

  @override
  List<Object?> get props => [message];
}
