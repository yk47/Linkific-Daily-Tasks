import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_5_packages_app/controllers/quiz_controller.dart';
import 'package:top_5_packages_app/controllers/progress_controller.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';


class AptitudeScreen extends StatefulWidget {
  const AptitudeScreen({super.key});

  @override
  State<AptitudeScreen> createState() => _AptitudeScreenState();
}

class _AptitudeScreenState extends State<AptitudeScreen> {
  final QuizController quizController = Get.find();
  final ProgressController progressController = Get.find();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    quizController.startAptitudeQuiz();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (quizController.timeLeft > 0 && !quizController.isCompleted) {
        quizController.decrementTimer();
      } else if (quizController.isCompleted) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
        title: const Text('Aptitude Quiz'),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: _TimerBadge(
                    seconds: quizController.timeLeft,
                    isWarning: quizController.timeLeft <= 10,
                  ),
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (quizController.isCompleted) return _buildResultView();
        if (quizController.questions.isEmpty) {
          return const Center(
            child: Text('No questions available.',
                style: TextStyle(color: AppColors.textSecondary)),
          );
        }
        return _buildQuestionView();
      }),
    );
  }

  Widget _buildQuestionView() {
    final questions = quizController.questions;
    final index = quizController.currentIndex;
    final question = questions[index];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (index + 1) / questions.length,
                    minHeight: 5,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFFFFB347)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${index + 1}/${questions.length}',
                style: const TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB347).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Aptitude',
                    style: TextStyle(
                      color: Color(0xFFFFB347),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  question.questionText,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, optionIndex) {
                final isSelected =
                    quizController.selectedOption == optionIndex;
                final isCorrect = optionIndex == question.correctIndex;
                final showFeedback = quizController.selectedOption != -1;

                Color borderColor = AppColors.cardBorder;
                Color bgColor = AppColors.surface;
                Color labelBg = AppColors.surfaceLight;

                if (showFeedback && isCorrect) {
                  borderColor = AppColors.success;
                  bgColor = AppColors.success.withValues(alpha: 0.08);
                  labelBg = AppColors.success;
                } else if (showFeedback && isSelected && !isCorrect) {
                  borderColor = AppColors.error;
                  bgColor = AppColors.error.withValues(alpha: 0.08);
                  labelBg = AppColors.error;
                }

                return GestureDetector(
                  onTap: showFeedback
                      ? null
                      : () => quizController.selectOption(optionIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: labelBg,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: showFeedback && isCorrect
                                ? const Icon(Icons.check_rounded,
                                    size: 18, color: Colors.white)
                                : showFeedback && isSelected && !isCorrect
                                    ? const Icon(Icons.close_rounded,
                                        size: 18, color: Colors.white)
                                    : Text(
                                        String.fromCharCode(65 + optionIndex),
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            question.options[optionIndex],
                            style: TextStyle(
                              color: showFeedback && (isCorrect || isSelected)
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: showFeedback &&
                                      (isCorrect || (isSelected && !isCorrect))
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (quizController.selectedOption != -1)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB347)),
                onPressed: quizController.nextQuestion,
                child: Text(
                  index < quizController.questions.length - 1
                      ? 'Next Question'
                      : 'See Results',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final accuracy = quizController.accuracy;
    final passed = accuracy >= 70;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (passed ? AppColors.success : AppColors.accent)
                  .withValues(alpha: 0.15),
              border: Border.all(
                color: passed ? AppColors.success : AppColors.accent,
                width: 2,
              ),
            ),
            child: Icon(
              passed ? Icons.emoji_events_rounded : Icons.trending_up_rounded,
              size: 52,
              color: passed ? AppColors.success : AppColors.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Quiz Complete!',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _ResultStat(
                label: 'Score',
                value:
                    '${quizController.score}/${quizController.totalQuestions}',
                color: const Color(0xFFFFB347),
              ),
              const SizedBox(width: 12),
              _ResultStat(
                label: 'Accuracy',
                value: '${accuracy.toStringAsFixed(0)}%',
                color: passed ? AppColors.success : AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB347)),
                  onPressed: () {
                    quizController.startAptitudeQuiz();
                    _startTimer();
                  },
                  child: const Text('Try Again'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  final int seconds;
  final bool isWarning;

  const _TimerBadge({required this.seconds, required this.isWarning});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.error.withValues(alpha: 0.15)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWarning ? AppColors.error : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded,
              size: 14,
              color: isWarning ? AppColors.error : AppColors.textMuted),
          const SizedBox(width: 5),
          Text(
            '${seconds}s',
            style: TextStyle(
              color: isWarning ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 28),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}