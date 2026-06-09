import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie_model.dart';

class FavoriteNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() => [];

  void toggleFavorite(Movie movie) {
    final exists = state.any(
      (item) => item.id == movie.id,
    );

    if (exists) {
      state = state
          .where((item) => item.id != movie.id)
          .toList();
    } else {
      state = [...state, movie];
    }
  }

  bool isFavorite(Movie movie) {
    return state.any(
      (item) => item.id == movie.id,
    );
  }
}

final favoriteProvider =
    NotifierProvider<FavoriteNotifier, List<Movie>>(
  FavoriteNotifier.new,
);