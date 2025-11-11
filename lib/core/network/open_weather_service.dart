import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/error/failures.dart';

class OpenWeatherService {
  final Dio _dio;
  final SharedPreferencesWithCache _prefs;

  OpenWeatherService(this._dio, this._prefs);

  static const _cacheDuration = Duration(hours: 1);
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getCountryWeather({
    required double latitude,
    required double longitude,
  }) async {
    final cacheKey = 'weather_${latitude}_$longitude';
    final timeStampKey = '${cacheKey}_timestamp';

    try {
      final cachedData = _prefs.getString(cacheKey);
      final cacheTimestamp = _prefs.getInt(timeStampKey);

      if (cachedData != null && cacheTimestamp != null) {
        final isExpired =
            DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(cacheTimestamp),
            ) >
            _cacheDuration;

        if (!isExpired) {
          return jsonDecode(cachedData) as Map<String, dynamic>;
        }
      }

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': dotenv.env['OPENWEATHER_API_KEY'],
        },
      );

      if (response.statusCode != 200) {
        throw ServerFailure('API Error: ${response.statusCode}');
      }

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      try {
        await _prefs.setString(cacheKey, jsonEncode(data));
        await _prefs.setInt(
          timeStampKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      } catch (e) {
        throw const CacheFailure('Failed to cache countries data');
      }

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
