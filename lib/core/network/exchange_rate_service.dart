import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wanderly/core/error/failures.dart';

class ExchangeRateService {
  final Dio _dio;

  ExchangeRateService(this._dio);

  Future<Map<String, dynamic>> getExchangeRate({required String baseCurrency, required String targetCurrency, required double amount}) async {
    try {
      final response = await _dio.get(
        'https://v6.exchangerate-api.com/v6/${dotenv.env['EXCHANGE_RATE_API_KEY']}/pair/$baseCurrency/$targetCurrency/$amount',
      );

      if (response.statusCode != 200) {
        throw ServerFailure('API Error: ${response.statusCode}');
      }

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      return data;
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
}
