import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceHigh = Color(0xFF252525);
  static const Color accent = Color(0xFFE8C97E); // warm gold
  static const Color accentDim = Color(0xFF8A7244);
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFF8A8880);
  static const Color border = Color(0xFF2A2A2A);

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.dark(surface: surface, primary: accent),
    fontFamily: 'serif',
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    useMaterial3: true,
  );
}
