import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../theme/app_theme.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  final FavoriteController favoriteController =
      Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    favoriteController.loadFavorites();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: Obx(() {
                if (favoriteController.favorites.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 18,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentSoft.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.accentSoft.withOpacity(0.4)),
                    ),
                    child: Text(
                      '${favoriteController.favorites.length} saved',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AppTheme.accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'SAVED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.5,
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Your collection',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 32,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No saved quotes yet',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the heart on any quote\nto save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: favoriteController.favorites.length,
      itemBuilder: (context, index) {
        final quote = favoriteController.favorites[index];
        return _FavoriteCard(
          quote: quote,
          onDelete: () => favoriteController.removeFavorite(index),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Map quote;
  final VoidCallback onDelete;

  const _FavoriteCard({required this.quote, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Decorative quote mark
            Positioned(
              top: -8,
              right: 12,
              child: Text(
                '\u201C',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 80,
                  color: AppTheme.accentSoft.withOpacity(0.12),
                  height: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote['quote'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 1,
                        color: AppTheme.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          quote['author'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}