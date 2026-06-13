import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/widgets/empty_state.dart';


import '../controllers/movie_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/watchlist_controller.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<MovieController>()) {
      Get.put(MovieController(), permanent: true);
    }
    if (!Get.isRegistered<FavoriteController>()) {
      Get.put(FavoriteController(), permanent: true);
    }
    if (!Get.isRegistered<WatchlistController>()) {
      Get.put(WatchlistController(), permanent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text('DISCOVER', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.teal, letterSpacing: 2.0,
                      )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Find your\nnext watch', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 26, height: 1.2)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            MovieSearchBar(
              onChanged: (value) => Get.find<MovieController>().setSearchQuery(value),
            ),
            Expanded(
              child: Obx(() {
                final controller = Get.find<MovieController>();
                final movies = controller.searchResults;
                final isSearching = controller.isSearching;
                final errorMessage = controller.errorMessage;

                if (isSearching) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                }
                if (errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Something went wrong.\n$errorMessage',
                        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    ),
                  );
                }
                if (movies.isEmpty) {
                  return const EmptyState(
                    icon: Icons.movie_filter_rounded,
                    title: 'Search for a film',
                    subtitle: 'Type a title above to start\nbrowsing movies and series',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => context.push('/details/${movie.id}', extra: movie),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}