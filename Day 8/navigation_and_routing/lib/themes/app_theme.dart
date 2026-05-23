import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F4C81),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F7FB),
  );
}
