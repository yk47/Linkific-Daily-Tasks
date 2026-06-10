import 'package:get/get.dart';
import 'package:top_5_packages_app/core/data/question_data.dart';
import 'package:top_5_packages_app/models/question.dart';

class QuizController extends GetxController {
  final RxList<Question> _questions = <Question>[].obs;
  final RxInt _currentIndex = 0.obs;
  final RxInt _score = 0.obs;
  final RxInt _selectedOption = (-1).obs;
  final RxString _category = ''.obs;
  final RxBool _isCompleted = false.obs;
  final RxBool _showResult = false.obs;
  final RxInt _timeLeft = 30.obs;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex.value;
  int get score => _score.value;
  int get selectedOption => _selectedOption.value;
  String get category => _category.value;
  bool get isCompleted => _isCompleted.value;
  bool get showResult => _showResult.value;
  int get totalQuestions => _questions.length;
  int get timeLeft => _timeLeft.value;

  void startQuiz(String category) {
    _category.value = category;
    _questions.value = QuestionData.getQuestionsByCategory(category);
    _currentIndex.value = 0;
    _score.value = 0;
    _isCompleted.value = false;
    _showResult.value = false;
    _selectedOption.value = -1;
  }

  void startAptitudeQuiz() {
    _category.value = 'Aptitude';
    _questions.value = QuestionData.aptitudeQuestions;
    _currentIndex.value = 0;
    _score.value = 0;
    _isCompleted.value = false;
    _showResult.value = false;
    _selectedOption.value = -1;
    _timeLeft.value = 30;
  }

  void selectOption(int index) {
    if (_selectedOption.value == -1) {
      _selectedOption.value = index;
      if (index == _questions[_currentIndex.value].correctIndex) {
        _score.value++;
      }
    }
  }

  void nextQuestion() {
    if (_currentIndex.value < _questions.length - 1) {
      _currentIndex.value++;
      _selectedOption.value = -1;
    } else {
      _isCompleted.value = true;
    }
  }

  void showResults() {
    _showResult.value = true;
  }

  double get accuracy => totalQuestions > 0 ? score / totalQuestions * 100 : 0;

  void decrementTimer() {
    if (_timeLeft.value > 0) {
      _timeLeft.value--;
    }
  }

  void reset() {
    _currentIndex.value = 0;
    _score.value = 0;
    _selectedOption.value = -1;
    _isCompleted.value = false;
    _showResult.value = false;
    _questions.clear();
  }
}