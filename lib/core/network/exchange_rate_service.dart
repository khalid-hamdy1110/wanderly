import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wanderly/core/error/failures.dart';

class ExchangeRateService {
  final Dio _dio;

  ExchangeRateService(this._dio);

  Future<Map<String, dynamic>> getExchangeRates() async {
    try {
      final response = await _dio.get(
        'https://v6.exchangerate-api.com/v6/${dotenv.env['EXCHANGE_RATES_API_KEY']}/latest/USD',
      );

      if (response.statusCode != 200) {
        throw ServerFailure('API Error: ${response.statusCode}');
      }

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      return data['conversion_rates'] as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkFailure(
          'Connection timed out. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        throw ServerFailure(
          'Server error: ${e.response?.statusCode ?? 'unknown'}',
        );
      } else {
        throw const NetworkFailure('Network error occurred');
      }
    } on CacheFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }

  Future<List<Map<String, String>>> getSupportedCurrencies() async {
    try {
      final response = await _dio.get(
        'https://v6.exchangerate-api.com/v6/${dotenv.env['EXCHANGE_RATES_API_KEY']}/codes',
      );

      if (response.statusCode != 200) {
        throw ServerFailure('API Error: ${response.statusCode}');
      }

      final data = response.data as Map<String, dynamic>;
      final codes = data['supported_codes'] as List<dynamic>;

      return codes
          .map((e) => {'code': e[0] as String, 'name': e[1] as String})
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkFailure(
          'Connection timed out. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        throw ServerFailure(
          'Server error: ${e.response?.statusCode ?? 'unknown'}',
        );
      } else {
        throw const NetworkFailure('Network error occurred');
      }
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }
}
