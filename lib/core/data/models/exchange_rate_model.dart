import 'package:wanderly/core/domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate { 
  const ExchangeRateModel({ 
    required super.currency,
    required super.rate,
  }); 

  factory ExchangeRateModel.fromJson(String code, double rate) { 
    return ExchangeRateModel( 
      currency: code, 
      rate: rate,
    ); 
  } 

  Map<String, dynamic> toJson() { 
    return { 
      'base_code': currency, 
      'conversion_rate': rate,
    };
  } 
}