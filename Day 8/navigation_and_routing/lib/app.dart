import 'package:flutter/material.dart';

import 'models/navigation_models.dart';
import 'screens/navigation_screens.dart';
import 'themes/app_theme.dart';

export 'models/navigation_models.dart';
export 'screens/navigation_screens.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Showcase',
      theme: buildAppTheme(),
      initialRoute: NavigationRoutes.shellHome,
      onGenerateRoute: buildRootRoute,
    );
  }
}
