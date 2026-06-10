import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_5_packages_app/controllers/interview_controller.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';


class AIInterviewScreen extends StatefulWidget {
  const AIInterviewScreen({super.key});

  @override
  State<AIInterviewScreen> createState() => _AIInterviewScreenState();
}

class _AIInterviewScreenState extends State<AIInterviewScreen> {
  final InterviewController interviewController = Get.find();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  bool _started = false;

  @override
  void dispose() {
    _roleController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _startInterview() {
    final role = _roleController.text.trim();
    if (role.isEmpty) return;
    interviewController.generateQuestions(role);
    setState(() => _started = true);
  }

  void _submitAnswer() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;
    interviewController.submitResponse(answer);
    _answerController.clear();
    interviewController.nextQuestion();
    setState(() {});
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
        title: const Text('AI Mock Interview'),
      ),
      body: _started ? _buildInterviewView() : _buildRoleSelectionView(),
    );
  }

  Widget _buildRoleSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Hero area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF9C8FFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.smart_toy_rounded,
                      size: 40, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'AI-Powered Interview',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your target role and get personalized interview questions generated just for you.',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14, height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Features
          Row(
            children: [
              _FeatureChip(icon: Icons.auto_awesome_rounded, label: 'AI-generated'),
              const SizedBox(width: 8),
              _FeatureChip(icon: Icons.person_outline_rounded, label: 'Role-specific'),
              const SizedBox(width: 8),
              _FeatureChip(icon: Icons.score_rounded, label: 'Scored'),
            ],
          ),
          const SizedBox(height: 28),
          // Input
          TextField(
            controller: _roleController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Your Target Role',
              hintText: 'e.g. Flutter Developer, Data Scientist',
              prefixIcon: Icon(Icons.work_outline_rounded, color: AppColors.primary),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _startInterview(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startInterview,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Begin Interview'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewView() {
    return Obx(() {
      final questions = interviewController.questions;
      final currentIndex = interviewController.currentIndex;

      if (questions.isEmpty) {
        return const Center(
          child: Text('No questions generated.',
              style: TextStyle(color: AppColors.textSecondary)),
        );
      }

      if (currentIndex >= questions.length) {
        return _buildInterviewComplete();
      }

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / questions.length,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${currentIndex + 1}/${questions.length}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // AI Question card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    const Color(0xFF9C8FFF).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF9C8FFF)],
                      ),
                    ),
                    child: const Icon(Icons.smart_toy_rounded,
                        size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      questions[currentIndex],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Answer',
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
                  hintText: 'Share your experience, walk through your thought process...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitAnswer,
                child: Text(currentIndex < questions.length - 1
                    ? 'Next Question'
                    : 'Finish Interview'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInterviewComplete() {
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
              gradient: LinearGradient(
                colors: [
                  AppColors.amber.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(color: AppColors.amber, width: 2),
            ),
            child: const Icon(Icons.celebration_rounded,
                size: 52, color: AppColors.amber),
          ),
          const SizedBox(height: 24),
          const Text(
            'Interview Complete!',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Here\'s how you performed',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 32),
          // Score breakdown
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                _buildScoreRow('Communication',
                    interviewController.communicationScore, AppColors.primary),
                const Divider(color: AppColors.cardBorder, height: 24),
                _buildScoreRow('Technical',
                    interviewController.technicalScore, AppColors.mint),
                const Divider(color: AppColors.cardBorder, height: 24),
                _buildScoreRow('Confidence',
                    interviewController.confidenceScore, AppColors.amber),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    interviewController.reset();
                    setState(() => _started = false);
                  },
                  child: const Text('New Interview'),
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

  Widget _buildScoreRow(String label, int score, Color color) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score / 10,
                  minHeight: 5,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Text(
          '$score/10',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}