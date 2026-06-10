import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:top_5_packages_app/models/quiz_result.dart';

class ProgressController extends GetxController {
  late Box<QuizResult> _box;
  final RxList<QuizResult> _results = <QuizResult>[].obs;

  List<QuizResult> get results => _results;

  @override
  void onInit() {
    super.onInit();
    _initBox();
  }

  Future<void> _initBox() async {
    _box = await Hive.openBox<QuizResult>('quizResults');
    _results.assignAll(_box.values.toList());
  }

  Future<void> saveResult(QuizResult result) async {
    await _box.add(result);
    _results.add(result);
  }

  int get totalQuizzes => _results.length;
  int get totalCorrect => _results.fold(0, (sum, r) => sum + r.score);
  int get totalQuestions => _results.fold(0, (sum, r) => sum + r.totalQuestions);

  double get overallAccuracy =>
      totalQuestions > 0 ? totalCorrect / totalQuestions * 100 : 0;

  double getAverageScore(String category) {
    final filtered = _results.where((r) => r.category == category).toList();
    if (filtered.isEmpty) return 0;
    return filtered.fold(0.0, (sum, r) => sum + r.accuracy) / filtered.length;
  }

  Map<String, double> get categoryAverages {
    final categories = _results.map((r) => r.category).toSet();
    final map = <String, double>{};
    for (final cat in categories) {
      map[cat] = getAverageScore(cat);
    }
    return map;
  }
}