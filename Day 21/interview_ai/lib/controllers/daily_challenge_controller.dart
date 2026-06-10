import 'package:get/get.dart';
import 'package:top_5_packages_app/core/data/question_data.dart';
import 'package:top_5_packages_app/models/question.dart';

class DailyChallengeController extends GetxController {
  final Rx<Question?> _technicalQuestion = Rx<Question?>(null);
  final Rx<Question?> _aptitudeQuestion = Rx<Question?>(null);
  final RxString _hrQuestion = ''.obs;
  final RxBool _isLoaded = false.obs;

  Question? get technicalQuestion => _technicalQuestion.value;
  Question? get aptitudeQuestion => _aptitudeQuestion.value;
  String get hrQuestion => _hrQuestion.value;
  bool get isLoaded => _isLoaded.value;

  @override
  void onInit() {
    super.onInit();
    loadDailyChallenge();
  }

  void loadDailyChallenge() {
    _technicalQuestion.value = QuestionData.getDailyTechnical();
    _aptitudeQuestion.value = QuestionData.getDailyAptitude();
    _hrQuestion.value = QuestionData.getDailyHR();
    _isLoaded.value = true;
  }
}