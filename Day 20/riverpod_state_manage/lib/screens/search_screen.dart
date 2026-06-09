import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_manage/core/theme/app_theme.dart';
import 'package:riverpod_state_manage/widgets/empty_state.dart';

import '../providers/movie_provider.dart';

import '../widgets/movie_card.dart';
import '../widgets/search_bar.dart';
import 'details_screen.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(searchMoviesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'DISCOVER',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: AppColors.teal,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Find your\nnext watch',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 26,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Search bar ─────────────────────────────────────────────
            MovieSearchBar(
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),

            // ── Results ────────────────────────────────────────────────
            Expanded(
              child: movies.when(
                data: (movieList) {
                  if (movieList.isEmpty) {
                    return const EmptyState(
                      icon: Icons.movie_filter_rounded,
                      title: 'Search for a film',
                      subtitle: 'Type a title above to start\nbrowsing movies and series',
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    itemCount: movieList.length,
                    itemBuilder: (context, index) {
                      final movie = movieList[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(movie: movie),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Something went wrong.\n${e.toString()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}