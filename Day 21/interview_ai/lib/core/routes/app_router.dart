import 'package:go_router/go_router.dart';
import 'package:top_5_packages_app/screens/splash_screen.dart';
import 'package:top_5_packages_app/screens/home_screen.dart';
import 'package:top_5_packages_app/screens/quiz_screen.dart';
import 'package:top_5_packages_app/screens/aptitude_screen.dart';
import 'package:top_5_packages_app/screens/hr_interview_screen.dart';
import 'package:top_5_packages_app/screens/ai_interview_screen.dart';
import 'package:top_5_packages_app/screens/daily_challenge_screen.dart';
import 'package:top_5_packages_app/screens/dashboard_screen.dart';
import 'package:top_5_packages_app/screens/history_screen.dart';


class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/quiz/:category',
        name: 'quiz',
        builder: (context, state) => QuizScreen(
          category: state.pathParameters['category']!,
        ),
      ),
      GoRoute(
        path: '/aptitude',
        name: 'aptitude',
        builder: (context, state) => const AptitudeScreen(),
      ),
      GoRoute(
        path: '/hr-interview',
        name: 'hr-interview',
        builder: (context, state) => const HRInterviewScreen(),
      ),
      GoRoute(
        path: '/ai-interview',
        name: 'ai-interview',
        builder: (context, state) => const AIInterviewScreen(),
      ),
      GoRoute(
        path: '/daily-challenge',
        name: 'daily-challenge',
        builder: (context, state) => const DailyChallengeScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
}