import 'package:get/get.dart';

class InterviewController extends GetxController {
  final RxList<String> _questions = <String>[].obs;
  final RxInt _currentIndex = 0.obs;
  final RxBool _isGenerating = false.obs;
  final RxList<Map<String, dynamic>> _responses = <Map<String, dynamic>>[].obs;

  List<String> get questions => _questions;
  int get currentIndex => _currentIndex.value;
  bool get isGenerating => _isGenerating.value;
  List<Map<String, dynamic>> get responses => _responses;

  void generateQuestions(String role) {
    _isGenerating.value = true;
    _questions.value = _getAIQuestions(role);
    _currentIndex.value = 0;
    _responses.clear();
    _isGenerating.value = false;
  }

  List<String> _getAIQuestions(String role) {
    final base = [
      'Tell me about your experience with $role.',
      'What projects have you worked on as a $role?',
      'How do you handle tight deadlines as a $role?',
      'Describe a challenging bug you fixed.',
      'What $role technologies are you most proficient in?',
      'How do you stay updated with $role trends?',
      'Describe your ideal team collaboration.',
      'What is your approach to code review?',
      'How do you handle conflicts in a team?',
      'Where do you see your $role career in 3 years?',
    ];
    return base;
  }

  void nextQuestion() {
    if (_currentIndex.value < _questions.length - 1) {
      _currentIndex.value++;
    }
  }

  void submitResponse(String answer) {
    _responses.add({
      'question': _questions[_currentIndex.value],
      'answer': answer,
    });
  }

  void reset() {
    _questions.clear();
    _currentIndex.value = 0;
    _responses.clear();
  }

  int get communicationScore => 8;
  int get technicalScore => 7;
  int get confidenceScore => 9;
}