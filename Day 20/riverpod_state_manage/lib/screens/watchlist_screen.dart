import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_manage/core/theme/app_theme.dart';
import 'package:riverpod_state_manage/widgets/empty_state.dart';

import '../providers/watchlist_provider.dart';

import '../widgets/movie_card.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
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
                                color: AppColors.bookmarkGold,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'UP NEXT',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                color: AppColors.bookmarkGold,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Watchlist',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                  if (watchlist.isNotEmpty)
                    _CountBadge(
                      count: watchlist.length,
                      color: AppColors.bookmarkGold,
                    ),
                ],
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
            const SizedBox(height: 4),

            // ── List ─────────────────────────────────────────────────────
            Expanded(
              child: watchlist.isEmpty
                  ? const EmptyState(
                      icon: Icons.bookmark_border_rounded,
                      title: 'Your queue is empty',
                      subtitle: 'Add films from the details screen\nto build your watchlist',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      itemCount: watchlist.length,
                    itemBuilder: (context, index) => MovieCard(
  movie: watchlist[index],
  onDelete: () {
    ref
        .read(watchlistProvider.notifier)
        .toggleWatchlist(watchlist[index]);
  },
),
                    ),
            ),
          ],
        ),
      ),
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