import 'package:flutter/material.dart';
import 'package:riverpod_state_manage/core/theme/app_theme.dart';
import '../models/movie_model.dart';


/// Signature card layout: poster thumbnail bleeds to the left edge,
/// fades into a gradient, teal accent strip on the very left border.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: AppColors.tealGlow,
          highlightColor: AppColors.tealGlow,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Row(
                children: [
                  // ── Teal accent strip ──────────────────────────────────
                  Container(width: 3, color: AppColors.teal),

                  // ── Poster with gradient fade ──────────────────────────
                  SizedBox(
                    width: 72,
                    height: 90,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _PosterImage(url: movie.poster),
                        // Gradient fade-out to the right (film frame bleed)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  AppColors.surface.withOpacity(0.85),
                                ],
                                stops: const [0.4, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Metadata ──────────────────────────────────────────
                 Expanded(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              movie.title,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        const SizedBox(height: 4),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _Chip(
                label: movie.type,
                isTeal: false,
              ),
              const SizedBox(width: 6),
              _Chip(
                label: movie.year.toString(),
                isTeal: true,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

                  // ── Trailing ──────────────────────────────────────────
                  if (onDelete != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.errorRed,
                          size: 20,
                        ),
                        onPressed: onDelete,
                      ),
                    )
                  else if (onTap != null)
                    const Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textMuted,
                        size: 14,
                      ),
                    )
                  else
                    const SizedBox(width: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  final String url;
  const _PosterImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : _placeholder(),
    );
  }

  Widget _placeholder() => const ColoredBox(
        color: AppColors.surfaceHigh,
        child: Center(
          child: Icon(
            Icons.movie_filter_rounded,
            color: AppColors.textMuted,
            size: 28,
          ),
        ),
      );
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isTeal;
  const _Chip({required this.label, required this.isTeal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isTeal ? AppColors.tealDim : AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isTeal ? AppColors.teal.withOpacity(0.35) : AppColors.cardBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isTeal ? AppColors.teal : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}