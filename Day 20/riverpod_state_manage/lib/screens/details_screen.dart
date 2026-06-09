import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_manage/core/theme/app_theme.dart';
import 'package:riverpod_state_manage/providers/movie_provider.dart';

import '../models/movie_model.dart';
import '../providers/favorite_provider.dart';
import '../providers/watchlist_provider.dart';


class DetailsScreen extends ConsumerWidget {
  final Movie movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteProvider).contains(movie);
    final isWatchlisted = ref.watch(watchlistProvider).contains(movie);
    final screenHeight = MediaQuery.of(context).size.height;
    final detailsAsync =
    ref.watch(movieDetailsProvider(movie.id));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Full-bleed poster (top ~55% of screen) ─────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: _HeroPoster(posterUrl: movie.poster),
          ),

          // ── Top gradient (so back button is readable) ───────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bg.withOpacity(0.75),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Safe area back button ────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: _CircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // ── Bottom panel — slides up over poster ────────────────────
          Positioned(
            top: screenHeight * 0.44,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // ── Meta chips ──────────────────────────────────────
                    Row(
                      children: [
                        _MetaChip(
                          label: movie.type.toUpperCase(),
                          color: AppColors.teal,
                          bgColor: AppColors.tealDim,
                        ),
                        const SizedBox(width: 8),
                        _MetaChip(
                          label: movie.year.toString(),
                          color: AppColors.textSecondary,
                          bgColor: AppColors.surfaceHigh,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

Text(
  movie.title,
  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
    fontSize: 24,
    height: 1.25,
  ),
),

const SizedBox(height: 20),

detailsAsync.when(
  data: (details) {
    final description =
        details['plot_overview'] ??
        details['description'] ??
        'No description available';

    final rating =
        details['user_rating'];

    final runtime =
        details['runtime_minutes'];

    final genres =
        details['genre_names'];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          description,
          style: Theme.of(context)
              .textTheme
              .bodyLarge,
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            const Icon(Icons.star,
                size: 18,
                color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              '${rating ?? "N/A"}',
            ),
          ],
        ),

        const SizedBox(height: 10),

        Text(
          'Runtime: ${runtime ?? "N/A"} min',
        ),

        const SizedBox(height: 10),

        Text(
          'Genres: ${(genres ?? []).join(", ")}',
        ),
      ],
    );
  },

  loading: () => const Padding(
    padding: EdgeInsets.symmetric(
      vertical: 20,
    ),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),

  error: (e, _) => const Padding(
    padding: EdgeInsets.symmetric(
      vertical: 20,
    ),
    child: Text(
      'Failed to load movie details',
    ),
  ),
),

const SizedBox(height: 28),

const Divider(),
const SizedBox(height: 24),

                    // ── Action buttons ──────────────────────────────────
                    Text(
                      'MY LIST',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            label: isFavorite ? 'Saved' : 'Favourite',
                            isActive: isFavorite,
                            activeColor: AppColors.heartRed,
                            onTap: () => ref
                                .read(favoriteProvider.notifier)
                                .toggleFavorite(movie),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            icon: isWatchlisted
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            label: isWatchlisted ? 'Added' : 'Watchlist',
                            isActive: isWatchlisted,
                            activeColor: AppColors.bookmarkGold,
                            onTap: () => ref
                                .read(watchlistProvider.notifier)
                                .toggleWatchlist(movie),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _HeroPoster extends StatelessWidget {
  final String posterUrl;
  const _HeroPoster({required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (posterUrl.isNotEmpty)
          Image.network(
            posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : _fallback(),
          )
        else
          _fallback(),
        // Bottom fade-out into the panel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.bg],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() => const ColoredBox(
        color: AppColors.surfaceHigh,
        child: Center(
          child: Icon(Icons.movie_filter_rounded,
              color: AppColors.textMuted, size: 64),
        ),
      );
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  const _MetaChip({required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? activeColor.withOpacity(0.5) : AppColors.cardBorder,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.85),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 16),
      ),
    );
  }
}