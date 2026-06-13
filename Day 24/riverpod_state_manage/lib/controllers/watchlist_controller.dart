import 'package:get/get.dart';
import '../models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WatchlistController extends GetxController {
  final _watchlist = <Movie>[].obs;

  List<Movie> get watchlist => _watchlist;

  @override
  void onInit() {
    super.onInit();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('watchlist');
    if (data != null) {
      final list = jsonDecode(data) as List;
      _watchlist.assignAll(
        list.map((e) => Movie.fromJson(Map<String, dynamic>.from(e))),
      );
    }
  }

  Future<void> _saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_watchlist.map((e) => {
      'id': e.id,
      'name': e.title,
      'type': e.type,
      'year': e.year,
      'image_url': e.poster,
      'plot_overview': e.description,
    }).toList());
    await prefs.setString('watchlist', data);
  }

  void toggleWatchlist(Movie movie) {
    final exists = _watchlist.any((item) => item.id == movie.id);
    if (exists) {
      _watchlist.removeWhere((item) => item.id == movie.id);
    } else {
      _watchlist.add(movie);
    }
    _saveWatchlist();
  }

  bool isInWatchlist(Movie movie) {
    return _watchlist.any((item) => item.id == movie.id);
  }
}