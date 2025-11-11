import 'package:wanderly/core/domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({required super.code, required super.name});

  factory CurrencyModel.fromJson(Map<String, String> json) {
    return CurrencyModel(code: json['code']!, name: json['name']!);
  }

  Map<String, String> toJson() {
    return {'code': code, 'name': name};
  }
}
