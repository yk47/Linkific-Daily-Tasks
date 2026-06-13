import 'package:get/get.dart';
import '../models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteController extends GetxController {
  final _favorites = <Movie>[].obs;

  List<Movie> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favorites');
    if (data != null) {
      final list = jsonDecode(data) as List;
      _favorites.assignAll(
        list.map((e) => Movie.fromJson(Map<String, dynamic>.from(e))),
      );
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_favorites.map((e) => {
      'id': e.id,
      'name': e.title,
      'type': e.type,
      'year': e.year,
      'image_url': e.poster,
      'plot_overview': e.description,
    }).toList());
    await prefs.setString('favorites', data);
  }

  void toggleFavorite(Movie movie) {
    final exists = _favorites.any((item) => item.id == movie.id);
    if (exists) {
      _favorites.removeWhere((item) => item.id == movie.id);
    } else {
      _favorites.add(movie);
    }
    _saveFavorites();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((item) => item.id == movie.id);
  }
}