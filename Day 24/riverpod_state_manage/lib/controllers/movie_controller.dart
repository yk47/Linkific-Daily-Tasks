import 'package:get/get.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieController extends GetxController {
  final MovieService _movieService = MovieService();

  final _searchQuery = ''.obs;
  final _searchResults = <Movie>[].obs;
  final _isSearching = false.obs;
  final _errorMessage = ''.obs;

  String get searchQuery => _searchQuery.value;
  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching.value;
  String get errorMessage => _errorMessage.value;

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    if (query.isNotEmpty) {
      searchMovies();
    } else {
      _searchResults.clear();
      _errorMessage.value = '';
    }
  }

  Future<void> searchMovies() async {
    if (_searchQuery.value.isEmpty) return;

    _isSearching.value = true;
    _errorMessage.value = '';

    try {
      final results = await _movieService.searchMovies(_searchQuery.value);
      _searchResults.assignAll(results);
    } catch (e) {
      _errorMessage.value = e.toString();
      _searchResults.clear();
    } finally {
      _isSearching.value = false;
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    try {
      return await _movieService.getMovieDetails(movieId);
    } catch (e) {
      _errorMessage.value = e.toString();
      return {};
    }
  }

  Future<List<dynamic>> getMovieSources(int movieId) async {
    try {
      return await _movieService.getSources(movieId);
    } catch (e) {
      _errorMessage.value = e.toString();
      return [];
    }
  }
}