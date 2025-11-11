import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/currency.dart';
import 'package:wanderly/core/domain/repositories/exchange_rate_repository.dart';
import 'package:wanderly/core/error/failures.dart';

class GetSupportedCurrencies {
  final ExchangeRateRepository repository;

  GetSupportedCurrencies(this.repository);

  Future<Either<Failure, List<Currency>>> call() async {
    return await repository.getSupportedCurrencies();
  }
}