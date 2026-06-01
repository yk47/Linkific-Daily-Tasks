import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
      cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
    );
  }

  const AppTheme._();
}
