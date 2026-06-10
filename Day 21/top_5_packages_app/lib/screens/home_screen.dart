import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../controllers/quote_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/quote_card.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final QuoteController quoteController = Get.put(QuoteController());
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return CustomScrollView(
            slivers: [
              _buildSliverHeader(context),
              if (quoteController.isLoading.value)
                const SliverFillRemaining(child: _LoadingView())
              else if (quoteController.errorMessage.isNotEmpty)
                SliverFillRemaining(
                  child: _ErrorView(
                    message: quoteController.errorMessage.value,
                    onRetry: quoteController.fetchQuotes,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final quote = quoteController.quotes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: QuoteCard(
                            quote: quote,
                            favoriteController: favoriteController,
                          ),
                        );
                      },
                      childCount: quoteController.quotes.length,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QUOTE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3.5,
                          color: AppTheme.accent,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Vault',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                _FavoritesButton(),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Words that move the world',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                fontStyle: FontStyle.italic,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => quoteController.fetchQuotes(),
      tooltip: 'Refresh quotes',
      child: const Icon(Icons.auto_awesome_rounded, size: 22),
    );
  }
}

class _FavoritesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => FavoriteScreen()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.favorite_rounded, size: 14, color: AppTheme.accent),
            SizedBox(width: 6),
            Text(
              'Saved',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.accent,
            strokeWidth: 1.5,
          ),
          SizedBox(height: 16),
          Text(
            'Gathering wisdom...',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontStyle: FontStyle.italic,
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accent,
                side: const BorderSide(color: AppTheme.accentSoft),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}