import 'package:wanderly/core/data/models/currency_model.dart';
import 'package:wanderly/core/data/models/exchange_rate_model.dart';
import 'package:wanderly/core/network/exchange_rate_service.dart';

abstract interface class ExchangeRateRemoteDataSource {
  Future<List<ExchangeRateModel>> getExchangeRates();
  Future<List<CurrencyModel>> getSupportedCurrencies();
}

class ExchangeRateRemoteDataSourceImpl implements ExchangeRateRemoteDataSource {
  final ExchangeRateService exchangeRateService;

  ExchangeRateRemoteDataSourceImpl({required this.exchangeRateService});

  @override
  Future<List<ExchangeRateModel>> getExchangeRates() async {
    final response = await exchangeRateService.getExchangeRates();
    return response.entries
        .map((entry) => ExchangeRateModel.fromJson(entry.key, (entry.value as num).toDouble()))
        .toList();  
  }

  @override
  Future<List<CurrencyModel>> getSupportedCurrencies() async {
    final response = await exchangeRateService.getSupportedCurrencies();
    return response.map((currency) => CurrencyModel.fromJson(currency)).toList();
  }
}