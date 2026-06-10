import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_5_packages_app/controllers/connectivity_controller.dart';
import 'package:top_5_packages_app/controllers/daily_challenge_controller.dart';
import 'package:top_5_packages_app/controllers/interview_controller.dart';
import 'package:top_5_packages_app/controllers/progress_controller.dart';
import 'package:top_5_packages_app/controllers/quiz_controller.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';

import 'package:top_5_packages_app/models/quiz_result.dart';
import 'package:top_5_packages_app/screens/splash_screen.dart';
import 'package:top_5_packages_app/screens/home_screen.dart';
import 'package:top_5_packages_app/screens/quiz_screen.dart';
import 'package:top_5_packages_app/screens/aptitude_screen.dart';
import 'package:top_5_packages_app/screens/hr_interview_screen.dart';
import 'package:top_5_packages_app/screens/ai_interview_screen.dart';
import 'package:top_5_packages_app/screens/daily_challenge_screen.dart';
import 'package:top_5_packages_app/screens/dashboard_screen.dart';
import 'package:top_5_packages_app/screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QuizResultAdapter());

  Get.put(ConnectivityController());
  Get.put(QuizController());
  Get.put(ProgressController());
  Get.put(DailyChallengeController());
  Get.put(InterviewController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Interview Prep',
      debugShowCheckedModeBanner: false,
theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(
          name: '/quiz/:category',
          page: () => QuizScreen(
            category: Get.parameters['category'] ?? '',
          ),
        ),
        GetPage(name: '/aptitude', page: () => const AptitudeScreen()),
        GetPage(name: '/hr-interview', page: () => const HRInterviewScreen()),
        GetPage(name: '/ai-interview', page: () => const AIInterviewScreen()),
        GetPage(name: '/daily-challenge', page: () => const DailyChallengeScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/history', page: () => const HistoryScreen()),
      ],
    );
  }
}