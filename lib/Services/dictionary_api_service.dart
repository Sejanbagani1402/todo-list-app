import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum DioMethod { get }

class DictionaryAPIService {
  DictionaryAPIService._singleton();
  static final DictionaryAPIService instance =
      DictionaryAPIService._singleton();
  String get baseUrl {
    if (kDebugMode) {
      return "https://api.dictionaryapi.dev/api/v2/entries/en";
    } else {
      return "https://api.dictionaryapi.dev/api/v2/entries/en";
    }
  }

  Future<Response> request(
    String endpoint,
    DioMethod method, {
    Map<String, dynamic>? param,
    String? contentType,
    formData,
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType ?? Headers.formUrlEncodedContentType,
      ),
    );
    try {
      switch (method) {
        case DioMethod.get:
          return await dio.get(endpoint, queryParameters: param);
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
