import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie_model.dart';

class WatchlistNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() => [];

  void toggleWatchlist(Movie movie) {
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

  bool isInWatchlist(Movie movie) {
    return state.any(
      (item) => item.id == movie.id,
    );
  }
}

final watchlistProvider =
    NotifierProvider<WatchlistNotifier, List<Movie>>(
  WatchlistNotifier.new,
);