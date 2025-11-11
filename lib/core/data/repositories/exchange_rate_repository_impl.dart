import 'package:dartz/dartz.dart';
import 'package:wanderly/core/data/datasources/exchange_rate_remote_data_source.dart';
import 'package:wanderly/core/domain/entities/currency.dart';
import 'package:wanderly/core/domain/entities/exchange_rate.dart';
import 'package:wanderly/core/domain/repositories/exchange_rate_repository.dart';
import 'package:wanderly/core/error/failures.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateRemoteDataSource remoteDataSource;

  ExchangeRateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRate() async {
    try {
      final exchangeRateModel = await remoteDataSource.getExchangeRates();
      return Right(exchangeRateModel);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch exchange rate: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Currency>>> getSupportedCurrencies() async {
    try {
      final currencyModels = await remoteDataSource.getSupportedCurrencies();
      return Right(currencyModels);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch supported currencies: ${e.toString()}'));
    }
  }
}