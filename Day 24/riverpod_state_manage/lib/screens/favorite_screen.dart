import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/widgets/empty_state.dart';

import '../controllers/favorite_controller.dart';
import '../widgets/movie_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(
      builder: (controller) {
        final favorites = controller.favorites;

        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.heartRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'SAVED',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                    color: AppColors.heartRed,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Favourites',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                      if (favorites.isNotEmpty)
                        _CountBadge(
                          count: favorites.length,
                          color: AppColors.heartRed,
                        ),
                    ],
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                const SizedBox(height: 4),

                // List
                Expanded(
                  child: favorites.isEmpty
                      ? const EmptyState(
                          icon: Icons.favorite_border_rounded,
                          title: 'Nothing saved yet',
                          subtitle: 'Tap the heart on any film to\nadd it here',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 4, bottom: 24),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) => MovieCard(
                            movie: favorites[index],
                            onDelete: () {
                              controller.toggleFavorite(favorites[index]);
                              controller.update();
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final Color color;
  const _CountBadge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}