import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/error/failures.dart';

class RestCountriesService {
  final Dio _dio;
  final SharedPreferencesWithCache _prefs;

  RestCountriesService(this._dio, this._prefs);

  static const _cacheKey = 'rest_countries_cache';
  static const _timeStampKey = 'rest_countries_cache_timestamp';
  static const _cacheDuration = Duration(hours: 24);

  Future<List<dynamic>> getAllCountries() async {
    final cachedData = _prefs.getString(_cacheKey);
    final cacheTimestamp = _prefs.getInt(_timeStampKey);

    try {
      if (cachedData != null && cacheTimestamp != null) {
        final isExpired =
            DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(cacheTimestamp),
            ) >
            _cacheDuration;

        if (!isExpired) {
          return jsonDecode(cachedData) as List<dynamic>;
        }
      }

      final response = await _dio.get(
        'https://restcountries.com/v3.1/all?fields=name,flags,region,capital,population,languages,currencies,timezones,cca2,latlng',
      );

      if (response.statusCode != 200) {
        throw ServerFailure('API Error: ${response.statusCode}');
      }

      final List<dynamic> data = response.data as List<dynamic>;

      try {
        await _prefs.setString(_cacheKey, jsonEncode(data));
        await _prefs.setInt(
          _timeStampKey,
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
