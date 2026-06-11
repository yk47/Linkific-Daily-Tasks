import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  /// Simulated working API call
  Future<dynamic> fetchPosts() async {
    try {
      final response = await _dio.get(
        "https://jsonplaceholder.typicode.com/posts",
      );

      return response.data;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

  /// Intentional broken API call (for debugging)
  Future<dynamic> fetchBrokenApi() async {
    try {
      final response = await _dio.get(
        "https://invalid-api-url-123456.com/data",
      );

      return response.data;
    } catch (e) {
      throw Exception("Broken API error: $e");
    }
  }

  /// Timeout simulation API
  Future<dynamic> fetchSlowApi() async {
    try {
      final response = await _dio.get(
        "https://httpstat.us/200?sleep=8000",
      );

      return response.data;
    } catch (e) {
      throw Exception("Timeout or slow API error: $e");
    }
  }

  /// Generic request helper
  Future<dynamic> getRequest(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}