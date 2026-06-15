import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/config/theme.dart';
import 'src/controllers/auth_controller.dart';
import 'src/controllers/chat_controller.dart';
import 'src/controllers/social_controller.dart';
import 'src/screens/auth/splash_screen.dart';
import 'src/screens/auth/login_screen.dart';
import 'src/screens/auth/register_screen.dart';
import 'src/screens/home_shell.dart';
import 'src/screens/feed/create_post_screen.dart';
import 'src/screens/feed/post_detail_screen.dart';
import 'src/screens/chat/chat_screen.dart';
import 'src/screens/profile/profile_screen.dart';
import 'src/screens/users/users_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize GetX controllers lazily (created when first accessed)
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => SocialController(), fenix: true);
  Get.lazyPut(() => ChatController(), fenix: true);

  runApp(const VibezApp());
}

class VibezApp extends StatelessWidget {
  const VibezApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vibez',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      defaultTransition: Transition.cupertino,
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeShell()),
        GetPage(name: '/create-post', page: () => const CreatePostScreen()),
        GetPage(
          name: '/post-detail',
          page: () {
            final post = Get.arguments;
            return PostDetailScreen(post: post);
          },
        ),
        GetPage(
          name: '/chat',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return ChatScreen(
              chatId: args['chatId'] as String,
              user: args['user'],
            );
          },
        ),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/users', page: () => const UsersScreen()),
      ],
    );
  }
}