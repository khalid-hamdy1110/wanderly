import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/exchange_rate.dart';
import 'package:wanderly/core/domain/repositories/exchange_rate_repository.dart';
import 'package:wanderly/core/error/failures.dart';

class GetExchangeRate {
  final ExchangeRateRepository repository;

  GetExchangeRate(this.repository);

  Future<Either<Failure, List<ExchangeRate>>> call() async {
    return repository.getExchangeRate();
  }
}
