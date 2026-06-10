import 'package:dio/dio.dart';

import '../models/quote_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<QuoteModel>> fetchQuotes() async {
    try {
      final response = await _dio.get(
        'https://dummyjson.com/quotes',
      );

      final List quotes = response.data['quotes'];

      return quotes
          .map((quote) => QuoteModel.fromJson(quote))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }
}