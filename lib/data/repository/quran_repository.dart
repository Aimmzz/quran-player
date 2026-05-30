import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:quranplayer/core/network/dio_client.dart';
import 'package:quranplayer/data/model/reciter.dart';
import 'package:quranplayer/data/model/surah.dart';

class QuranRepository extends GetxService {
  final DioClient _client;

  QuranRepository(this._client);

  Future<List<Surah>> fetchSurahs() async {
    try {
      final response = await _client.dio.get('/surah');
      final data = response.data['data'] as List<dynamic>;

      return data
          .map((json) => Surah.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<Reciter>> fetchReciters() async {
    try {
      final response = await _client.dio.get(
        '/edition',
        queryParameters: {'format': 'audio', 'language': 'ar'},
      );
      final data = response.data['data'] as List<dynamic>;

      return data
          .map((json) => Reciter.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Maps [DioException] to a human-readable error message.
  String _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return e.response?.data?['message']?.toString() ??
            'Something went wrong. Please try again.';
    }
  }
}