import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/layout_showcase_screen.dart';
import 'statefull.dart';
import 'stateless.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic UI Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routes: {
        StatelessBasicsScreen.routeName: (context) =>
            const StatelessBasicsScreen(),
        StatefulCounterScreen.routeName: (context) =>
            const StatefulCounterScreen(),
        LayoutShowcaseScreen.routeName: (context) =>
            const LayoutShowcaseScreen(),
      },
      home: const LearningHomeScreen(),
    );
  }
}
