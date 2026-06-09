import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

final movieServiceProvider =
    Provider<MovieService>((ref) {
  return MovieService();
});

final searchQueryProvider =
    StateProvider<String>((ref) => '');

final searchMoviesProvider =
    FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return [];
  }

  final service = ref.watch(movieServiceProvider);

  return service.searchMovies(query);
});

final movieDetailsProvider =
    FutureProvider.family<
        Map<String, dynamic>,
        int>((ref, movieId) async {
  final service =
      ref.watch(movieServiceProvider);

  return service.getMovieDetails(
    movieId,
  );
});

final movieSourcesProvider =
    FutureProvider.family<
        List<dynamic>,
        int>((ref, movieId) async {
  final service =
      ref.watch(movieServiceProvider);

  return service.getSources(
    movieId,
  );
});