import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_5_packages_app/core/data/question_data.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';


class HRInterviewScreen extends StatefulWidget {
  const HRInterviewScreen({super.key});

  @override
  State<HRInterviewScreen> createState() => _HRInterviewScreenState();
}

class _HRInterviewScreenState extends State<HRInterviewScreen> {
  int _currentIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  final List<Map<String, String>> _responses = [];
  final List<String> _questions = QuestionData.hrInterviewQuestions;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    _responses.add({
      'question': _questions[_currentIndex],
      'answer': answer,
    });
    _answerController.clear();

    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mint.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.mint, width: 2),
                ),
                child: const Icon(Icons.check_circle_outline_rounded,
                    size: 36, color: AppColors.mint),
              ),
              const SizedBox(height: 20),
              const Text(
                'Practice Complete!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You answered ${_responses.length} HR questions. Keep practicing to build confidence!',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _currentIndex = 0;
                          _responses.clear();
                        });
                      },
                      child: const Text('Again'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.back();
                      },
                      child: const Text('Home'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        title: const Text('HR Interview'),
      ),
      body: Padding(
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
                      value: (_currentIndex + 1) / _questions.length,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.mint),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Question card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.mint.withValues(alpha: 0.15),
                    AppColors.mint.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.mint.withValues(alpha: 0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.mint.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.record_voice_over_rounded,
                            size: 17, color: AppColors.mint),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'HR Question',
                        style: TextStyle(
                          color: AppColors.mint,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _questions[_currentIndex],
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
            const Text(
              'YOUR ANSWER',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _answerController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 15, height: 1.6),
                decoration: const InputDecoration(
                  hintText:
                      'Use the STAR method: Situation, Task, Action, Result...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.mint),
                onPressed: _submitAnswer,
                child: Text(
                  _currentIndex < _questions.length - 1
                      ? 'Next Question'
                      : 'Finish Practice',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}