import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String chat = '/chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      default:
        // OAuth callback route
        if (settings.name != null &&
            settings.name!.contains('login-callback')) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
