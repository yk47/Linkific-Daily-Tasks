import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String apiKey = '3DYLf7uIDRSYD3xzeYPeZ9xLePRou8fPG7fRCagE';
  static const String baseUrl = 'https://api.watchmode.com/v1';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/autocomplete-search/?search_value=$query&search_type=2',
      ),
      headers: {
        'X-API-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
    }

    throw Exception('Failed to fetch movies');
  }

Future<Map<String, dynamic>> getMovieDetails(
  int movieId,
) async {
  final response = await http.get(
    Uri.parse(
      '$baseUrl/title/$movieId/details/',
    ),
    headers: {
      'X-API-Key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('Failed to load details');
}

Future<List<dynamic>> getSources(
  int movieId,
) async {
  final response = await http.get(
    Uri.parse(
      '$baseUrl/title/$movieId/sources/',
    ),
    headers: {
      'X-API-Key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('Failed to load sources');
}
}