import 'package:flutter/material.dart';

import '../screens/permission_home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const PermissionHomeScreen(),
          settings: settings,
        );
    }
  }

  const AppRouter._();
}
