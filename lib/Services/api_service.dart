import 'package:dio/dio.dart';

enum DioMethod { get, post, delete, put }

class ApiService {
  final Dio dio;
  ApiService._internal(String baseUrl)
    : dio = Dio(
        BaseOptions(baseUrl: baseUrl, contentType: Headers.jsonContentType),
      );
  static ApiService? _instance;
  factory ApiService({required String baseUrl}) {
    return _instance ??= ApiService._internal(baseUrl);
  }
  static ApiService get instance {
    if (_instance == null) {
      throw Exception("Api service not initialized.");
    }
    return _instance!;
  }

  Future<Response<T>> request<T>({
    required String endpoint,
    required DioMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    String? contentType,
  }) async {
    try {
      switch (method) {
        case DioMethod.get:
          return await dio.get(endpoint, queryParameters: queryParameters);
        case DioMethod.post:
          return await dio.post(endpoint, data: data);
        case DioMethod.delete:
          return await dio.delete(endpoint, data: data);
        case DioMethod.put:
          return await dio.put(endpoint, data: data);
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
