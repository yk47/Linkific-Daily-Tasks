import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:top_5_packages_app/core/data/package_data.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';
import 'package:top_5_packages_app/models/package_info.dart';
import 'package:top_5_packages_app/screens/dio_demo_screen.dart';
import 'package:top_5_packages_app/screens/hive_demo_screen.dart';
import 'package:top_5_packages_app/screens/freezed_demo_screen.dart';

/// Main screen demonstrating all 5 packages + utility packages
/// Uses: GetX (state), Freezed (models), Hive (storage), Dio (HTTP), url_launcher/share_plus (utilities)
class PackageExplorerScreen extends StatelessWidget {
  const PackageExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 15, color: AppColors.textPrimary),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text('Package Explorer'),
        actions: [
          // Share button using share_plus utility package
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primary),
            onPressed: () {
              Share.share(
                'Check out the top 5 Flutter packages: GetX, Freezed, GoRouter, Dio, Hive! #Flutter #Dart',
                subject: 'Top 5 Flutter Packages',
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Hero section
          SliverToBoxAdapter(
            child: _buildHeroSection(context),
          ),
          // Top 5 packages
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: _buildSectionLabel('TOP 5 PACKAGES', Icons.star_rounded),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final pkg = PackageData.topPackages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildPackageCard(context, pkg, index),
                  );
                },
                childCount: PackageData.topPackages.length,
              ),
            ),
          ),
          // Interactive demos
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: _buildSectionLabel('INTERACTIVE DEMOS', Icons.play_circle_rounded),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildDemoCard(
                    context,
                    icon: Icons.http_rounded,
                    title: 'Dio HTTP Client',
                    subtitle: 'Interceptors, cancellation, API calls',
                    color: const Color(0xFF6C63FF),
                    onTap: () => Get.to(() => const DioDemoScreen()),
                  ),
                  const SizedBox(height: 10),
                  _buildDemoCard(
                    context,
                    icon: Icons.storage_rounded,
                    title: 'Hive Database',
                    subtitle: 'CRUD operations, box concept',
                    color: const Color(0xFF4ECDC4),
                    onTap: () => Get.to(() => const HiveDemoScreen()),
                  ),
                  const SizedBox(height: 10),
                  _buildDemoCard(
                    context,
                    icon: Icons.code_rounded,
                    title: 'Freezed Models',
                    subtitle: 'Immutable classes, union types',
                    color: const Color(0xFFFF6B6B),
                    onTap: () => Get.to(() => const FreezedDemoScreen()),
                  ),
                  const SizedBox(height: 10),
                  _buildDemoCard(
                    context,
                    icon: Icons.account_tree_rounded,
                    title: 'GetX State',
                    subtitle: 'Reactive state, dependency injection',
                    color: const Color(0xFFFFB347),
                    onTap: () => _showGetXDemo(context),
                  ),
                  const SizedBox(height: 10),
                  _buildDemoCard(
                    context,
                    icon: Icons.route_rounded,
                    title: 'GoRouter Navigation',
                    subtitle: 'Declarative routing, deep links',
                    color: const Color(0xFF4C9BE8),
                    onTap: () => _showGoRouterInfo(context),
                  ),
                ],
              ),
            ),
          ),
          // Utility packages
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: _buildSectionLabel('UTILITY PACKAGES', Icons.build_rounded),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final pkg = PackageData.utilityPackages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildUtilityCard(context, pkg),
                  );
                },
                childCount: PackageData.utilityPackages.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            const Color(0xFF9C8FFF).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PackageIcon(label: 'GetX', color: const Color(0xFFFF6B6B)),
              const SizedBox(width: 8),
              _PackageIcon(label: 'Freeze', color: const Color(0xFF4ECDC4)),
              const SizedBox(width: 8),
              _PackageIcon(label: 'Router', color: const Color(0xFF4C9BE8)),
              const SizedBox(width: 8),
              _PackageIcon(label: 'Dio', color: const Color(0xFFFFB347)),
              const SizedBox(width: 8),
              _PackageIcon(label: 'Hive', color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Top 5 Flutter Packages',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore the most essential packages for Flutter development',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, PackageInfo pkg, int index) {
    final colors = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFF4C9BE8), const Color(0xFF2F80ED)],
      [const Color(0xFFFFB347), const Color(0xFFFF8C42)],
      [AppColors.primary, const Color(0xFF9C8FFF)],
    ];
    final colorPair = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _showPackageDetail(context, pkg, colorPair[0]),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colorPair,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorPair[0].withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  pkg.name.substring(0, min(pkg.name.length, 2)),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pkg.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorPair[0].withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'v${pkg.version}',
                          style: TextStyle(
                            color: colorPair[0],
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pkg.category,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Popularity indicator
            Column(
              children: [
                Icon(Icons.star_rounded,
                    size: 18, color: AppColors.amber),
                const SizedBox(height: 2),
                Text(
                  '${pkg.popularityScore.toInt()}%',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityCard(BuildContext context, PackageInfo pkg) {
    return GestureDetector(
      onTap: () => _showPackageDetail(context, pkg, AppColors.primary),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.extension_rounded,
                size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pkg.name} v${pkg.version}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pkg.description,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // url_launcher demo - open documentation
            IconButton(
              icon: const Icon(Icons.open_in_new_rounded,
                  size: 16, color: AppColors.primary),
              onPressed: () async {
                final uri = Uri.parse(pkg.documentationUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPackageDetail(
      BuildContext context, PackageInfo pkg, Color accentColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pkg.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'v${pkg.version} • ${pkg.category}',
              style: TextStyle(
                color: accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pkg.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'FEATURES',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            ...pkg.features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 16, color: accentColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(pkg.documentationUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: const Text('Docs'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(pkg.githubUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.code_rounded, size: 18),
                    label: const Text('GitHub'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Share this package
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Share.share(
                    'Check out ${pkg.name} - ${pkg.description} ${pkg.documentationUrl}',
                  );
                },
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text('Share Package Info'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.mint,
                  side: const BorderSide(color: AppColors.mint),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGetXDemo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'GetX Demo',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This entire app demonstrates GetX!\n\n'
              '• State Management: All controllers use Rx observables\n'
              '• Dependency Injection: Get.put() / Get.find()\n'
              '• Navigation: Get.toNamed() / Get.back()\n'
              '• Reactive UI: Obx() widgets rebuild automatically\n\n'
              'Example: The connectivity status banner on the home screen '
              'uses Obx() to reactively show/hide based on network status.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showGoRouterInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'GoRouter Navigation',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'GoRouter is configured in app_router.dart with:\n\n'
              '• Declarative route definitions\n'
              '• Path parameters (/quiz/:category)\n'
              '• Named routes for type-safe navigation\n'
              '• Deep linking support\n\n'
              'This app uses GetX for navigation since it was built '
              'with GetMaterialApp. GoRouter is available as an '
              'alternative routing solution.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;
}

class _PackageIcon extends StatelessWidget {
  final String label;
  final Color color;
  const _PackageIcon({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label.substring(0, 3),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}