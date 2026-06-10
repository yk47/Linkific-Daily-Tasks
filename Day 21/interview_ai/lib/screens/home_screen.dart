import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_5_packages_app/controllers/connectivity_controller.dart';
import 'package:top_5_packages_app/core/data/question_data.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConnectivityController connectivityController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background orb
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              // Offline banner
              Obx(() {
                if (!connectivityController.isConnected) {
                  return Container(
                    width: double.infinity,
                    color: AppColors.error.withValues(alpha: 0.9),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.wifi_off_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'No internet connection',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              // Main content
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Hero header
                    SliverToBoxAdapter(
                      child: _buildHeader(context),
                    ),
                    // Tech quiz categories
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                        child: _buildSectionLabel('Technical Quizzes', Icons.code_rounded),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 110,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: QuestionData.allCategories.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final cat = QuestionData.allCategories[index];
                            return _buildCategoryChip(context, cat, index);
                          },
                        ),
                      ),
                    ),
                    // Menu items
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildSectionLabel('Practice Modes', Icons.bolt_rounded),
                          const SizedBox(height: 12),
                          _buildMenuCard(
                            context,
                            icon: Icons.calculate_rounded,
                            title: 'Aptitude Quiz',
                            subtitle: 'Quantitative & logical reasoning',
                            gradient: [const Color(0xFFFF8C42), const Color(0xFFFFB347)],
                            badge: null,
                            onTap: () => Get.toNamed('/aptitude'),
                          ),
                          const SizedBox(height: 10),
                          _buildMenuCard(
                            context,
                            icon: Icons.record_voice_over_rounded,
                            title: 'HR Interview',
                            subtitle: 'Master behavioral questions',
                            gradient: [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
                            badge: null,
                            onTap: () => Get.toNamed('/hr-interview'),
                          ),
                          const SizedBox(height: 10),
                          _buildMenuCard(
                            context,
                            icon: Icons.smart_toy_rounded,
                            title: 'AI Mock Interview',
                            subtitle: 'Role-specific AI-generated questions',
                            gradient: [AppColors.primary, const Color(0xFF9C8FFF)],
                            badge: 'AI',
                            onTap: () => Get.toNamed('/ai-interview'),
                          ),
                          const SizedBox(height: 10),
                          _buildMenuCard(
                            context,
                            icon: Icons.local_fire_department_rounded,
                            title: 'Daily Challenge',
                            subtitle: 'Three daily challenges, one big reward',
                            gradient: [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
                            badge: 'NEW',
                            onTap: () => Get.toNamed('/daily-challenge'),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionLabel('Your Progress', Icons.trending_up_rounded),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSmallMenuCard(
                                  context,
                                  icon: Icons.bar_chart_rounded,
                                  title: 'Dashboard',
                                  color: const Color(0xFF4C9BE8),
                                  onTap: () => Get.toNamed('/dashboard'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildSmallMenuCard(
                                  context,
                                  icon: Icons.history_rounded,
                                  title: 'History',
                                  color: const Color(0xFF9B59B6),
                                  onTap: () => Get.toNamed('/history'),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF9C8FFF)],
                  ),
                ),
                child: const Icon(Icons.psychology_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'Interview Prep',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Ready to\n',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(
                  text: 'ace your interview?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Practice every day, land your dream role.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
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
            title.toUpperCase(),
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

  Widget _buildCategoryChip(BuildContext context, String category, int index) {
    final colors = [
      [const Color(0xFF6C63FF), const Color(0xFF9C8FFF)],
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4C9BE8), const Color(0xFF2F80ED)],
      [const Color(0xFF9B59B6), const Color(0xFF8E44AD)],
    ];
    final colorPair = colors[index % colors.length];

    return GestureDetector(
      onTap: () => Get.toNamed('/quiz/$category'),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorPair[0].withValues(alpha: 0.18),
              colorPair[1].withValues(alpha: 0.08),
            ],
          ),
          border: Border.all(
            color: colorPair[0].withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: colorPair),
              ),
              child: const Icon(Icons.code_rounded,
                  size: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required String? badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
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
                  colors: gradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: gradient[0].withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: gradient[0].withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: gradient[0],
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 13, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color.withValues(alpha: 0.18),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}