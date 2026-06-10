import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_5_packages_app/controllers/progress_controller.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProgressController>();

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
        title: const Text('Progress Dashboard'),
      ),
      body: Obx(() {
        if (controller.results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceLight,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Icon(Icons.bar_chart_rounded,
                      size: 44, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No data yet',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete quizzes to see your progress here.',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Overview cards
            _buildStatsRow(context, controller),
            const SizedBox(height: 28),
            // Overall accuracy ring
            _buildAccuracyCard(context, controller),
            const SizedBox(height: 28),
            // Category breakdown
            const Text(
              'CATEGORY BREAKDOWN',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            ...controller.categoryAverages.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildCategoryCard(context, entry.key, entry.value),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatsRow(BuildContext context, ProgressController controller) {
    return Row(
      children: [
        _StatCard(
          label: 'Quizzes',
          value: '${controller.totalQuizzes}',
          icon: Icons.quiz_rounded,
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Correct',
          value: '${controller.totalCorrect}',
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Accuracy',
          value: '${controller.overallAccuracy.toStringAsFixed(0)}%',
          icon: Icons.gps_fixed_rounded,
          color: AppColors.amber,
        ),
      ],
    );
  }

  Widget _buildAccuracyCard(
      BuildContext context, ProgressController controller) {
    final accuracy = controller.overallAccuracy;
    final color = accuracy >= 70 ? AppColors.success : AppColors.accent;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: accuracy / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${accuracy.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Accuracy',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  accuracy >= 70
                      ? 'Great job! You\'re above the 70% target.'
                      : 'Keep practicing to reach 70% accuracy.',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 12),
                Text(
                  '${controller.totalQuizzes} quiz${controller.totalQuizzes == 1 ? '' : 'zes'} completed',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String category, double average) {
    final color = average >= 70 ? AppColors.success : AppColors.accent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${average.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: average / 100,
              minHeight: 6,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
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