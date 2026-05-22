import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Quest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        scaffoldBackgroundColor: const Color(0xFFF7F3E8),
        useMaterial3: true,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
}

const List<QuizQuestion> _questions = [
  QuizQuestion(
    prompt: 'What method wraps a state change so Flutter rebuilds the UI?',
    options: ['build()', 'setState()', 'dispose()', 'initState()'],
    correctIndex: 1,
  ),
  QuizQuestion(
    prompt: 'Which widget type is designed to hold mutable local state?',
    options: [
      'StatelessWidget',
      'InheritedWidget',
      'StatefulWidget',
      'TextField',
    ],
    correctIndex: 2,
  ),
  QuizQuestion(
    prompt: 'What should usually be cleaned up in dispose()?',
    options: [
      'Theme data',
      'TextEditingController',
      'AppBar title',
      'BuildContext',
    ],
    correctIndex: 1,
  ),
];

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _showFeedback = false;

  QuizQuestion get _currentQuestion => _questions[_currentQuestionIndex];

  bool get _isFinished => _currentQuestionIndex >= _questions.length;

  void _selectAnswer(int index) {
    if (_showFeedback) {
      return;
    }

    setState(() {
      _selectedAnswerIndex = index;
      _showFeedback = true;
      if (index == _currentQuestion.correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (!_showFeedback) {
      return;
    }

    setState(() {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _showFeedback = false;
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswerIndex = null;
      _showFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F3E8), Color(0xFFDDEFE8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: _isFinished
                          ? _buildResults(textTheme)
                          : _buildQuiz(textTheme),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuiz(TextTheme textTheme) {
    final question = _currentQuestion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quiz Quest',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF0F766E),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          color: Colors.white.withValues(alpha: 0.92),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  question.prompt,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(question.options.length, (index) {
                  final isSelected = _selectedAnswerIndex == index;
                  final isCorrect = index == question.correctIndex;
                  final isActive = _showFeedback && isSelected;
                  final backgroundColor = isActive
                      ? (isCorrect
                            ? const Color(0xFFD1FAE5)
                            : const Color(0xFFFEE2E2))
                      : const Color(0xFFF8FAFC);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => _selectAnswer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0F766E)
                                : const Color(0xFFE5E7EB),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isSelected
                                  ? const Color(0xFF0F766E)
                                  : const Color(0xFFE2E8F0),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isActive)
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect
                                    ? const Color(0xFF047857)
                                    : const Color(0xFFB91C1C),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                if (_showFeedback)
                  Text(
                    _selectedAnswerIndex == question.correctIndex
                        ? 'Correct answer. Nice work.'
                        : 'Not quite. Tap next to continue.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: _selectedAnswerIndex == question.correctIndex
                          ? const Color(0xFF047857)
                          : const Color(0xFFB91C1C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _showFeedback ? _nextQuestion : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex == _questions.length - 1
                        ? 'Finish quiz'
                        : 'Next question',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Color(0xFF0F766E),
            ),
            const SizedBox(height: 16),
            Text(
              'Quiz complete',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You scored $_score out of ${_questions.length}.',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _restartQuiz,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Restart quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
