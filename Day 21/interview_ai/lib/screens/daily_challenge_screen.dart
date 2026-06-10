import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_5_packages_app/controllers/daily_challenge_controller.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';


class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyChallengeController>();

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
        title: const Text('Daily Challenge'),
      ),
      body: Obx(() {
        if (!controller.isLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    color: AppColors.amber,
                    strokeWidth: 2.5),
                const SizedBox(height: 16),
                const Text('Loading challenges...',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.amber.withValues(alpha: 0.2),
                    AppColors.accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.35), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFFB347)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.local_fire_department_rounded,
                        size: 28, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Today's Challenges",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Complete all 3 to earn a bonus!',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildChallengeCard(
              context,
              icon: Icons.code_rounded,
              title: 'Technical',
              subtitle: 'Programming & CS concepts',
              color: AppColors.primary,
              child: _QuizWidget(
                question:
                    controller.technicalQuestion?.questionText ?? 'N/A',
                options: controller.technicalQuestion?.options ?? [],
                correctIndex:
                    controller.technicalQuestion?.correctIndex ?? 0,
                accentColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildChallengeCard(
              context,
              icon: Icons.calculate_rounded,
              title: 'Aptitude',
              subtitle: 'Quantitative & reasoning',
              color: AppColors.amber,
              child: _QuizWidget(
                question:
                    controller.aptitudeQuestion?.questionText ?? 'N/A',
                options: controller.aptitudeQuestion?.options ?? [],
                correctIndex:
                    controller.aptitudeQuestion?.correctIndex ?? 0,
                accentColor: AppColors.amber,
              ),
            ),
            const SizedBox(height: 12),
            _buildChallengeCard(
              context,
              icon: Icons.record_voice_over_rounded,
              title: 'HR',
              subtitle: 'Behavioral & soft skills',
              color: AppColors.mint,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  controller.hrQuestion,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          childrenPadding:
              const EdgeInsets.fromLTRB(18, 0, 18, 18),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: color.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 12),
          ),
          trailing: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Expand',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ),
          children: [child],
        ),
      ),
    );
  }
}

class _QuizWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final Color accentColor;

  const _QuizWidget({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.accentColor,
  });

  @override
  State<_QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<_QuizWidget> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(widget.options.length, (index) {
          final isSelected = _selectedOption == index;
          final isCorrect = index == widget.correctIndex;
          final showFeedback = _selectedOption != null;

          Color borderColor = AppColors.cardBorder;
          Color bgColor = AppColors.surfaceLight;
          Color labelBg = AppColors.background;

          if (showFeedback && isCorrect) {
            borderColor = AppColors.success;
            bgColor = AppColors.success.withValues(alpha: 0.1);
            labelBg = AppColors.success;
          } else if (showFeedback && isSelected && !isCorrect) {
            borderColor = AppColors.error;
            bgColor = AppColors.error.withValues(alpha: 0.1);
            labelBg = AppColors.error;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: _selectedOption == null
                  ? () => setState(() => _selectedOption = index)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: labelBg,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: showFeedback && isCorrect
                            ? const Icon(Icons.check_rounded,
                                size: 16, color: Colors.white)
                            : showFeedback && isSelected && !isCorrect
                                ? const Icon(Icons.close_rounded,
                                    size: 16, color: Colors.white)
                                : Text(
                                    String.fromCharCode(65 + index),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.options[index],
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}