import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/currency.dart';
import 'package:wanderly/core/domain/entities/exchange_rate.dart';
import 'package:wanderly/core/error/failures.dart';

abstract interface class ExchangeRateRepository {
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRate();

  Future<Either<Failure, List<Currency>>> getSupportedCurrencies();
}
