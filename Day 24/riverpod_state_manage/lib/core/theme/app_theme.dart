import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Palette ─────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const bg            = Color(0xFF0F1923);   // deep slate
  static const surface       = Color(0xFF1C2B3A);   // navy surface
  static const surfaceHigh   = Color(0xFF243447);   // elevated card
  static const cardBorder    = Color(0xFF2A3D52);   // subtle border

  static const teal          = Color(0xFF00C9A7);   // electric teal — projector light
  static const tealDim       = Color(0x2800C9A7);   // 16% teal fill
  static const tealGlow      = Color(0x0D00C9A7);   // 5% teal glow

  static const textPrimary   = Color(0xFFF0F4F8);
  static const textSecondary = Color(0xFF8FA8BE);
  static const textMuted     = Color(0xFF4A6278);

  static const heartRed      = Color(0xFFFF6B81);
  static const bookmarkGold  = Color(0xFFFFD166);
  static const errorRed      = Color(0xFFFF6B6B);
}

// ─── Theme ────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.teal,
      secondary: AppColors.teal,
      surface: AppColors.surface,
      background: AppColors.bg,
      onPrimary: AppColors.bg,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      error: AppColors.errorRed,
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.tealDim,
      labelTextStyle: MaterialStateProperty.resolveWith((s) {
        final sel = s.contains(MaterialState.selected);
        return TextStyle(
          color: sel ? AppColors.teal : AppColors.textMuted,
          fontSize: 11,
          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.4,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((s) {
        final sel = s.contains(MaterialState.selected);
        return IconThemeData(
          color: sel ? AppColors.teal : AppColors.textMuted,
          size: 22,
        );
      }),
      height: 70,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.bg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.teal,
        side: const BorderSide(color: AppColors.teal, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceHigh,
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      prefixIconColor: AppColors.textMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.cardBorder, thickness: 1, space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((s) =>
          s.contains(MaterialState.selected) ? AppColors.teal : AppColors.textMuted),
      trackColor: MaterialStateProperty.resolveWith((s) =>
          s.contains(MaterialState.selected) ? AppColors.tealDim : AppColors.surfaceHigh),
      trackOutlineColor: MaterialStateProperty.all(AppColors.cardBorder),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.teal),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F4F8),
    colorScheme: const ColorScheme.light(
      primary: AppColors.teal,
      surface: Colors.white,
      background: Color(0xFFF0F4F8),
      onPrimary: Colors.white,
      onSurface: Color(0xFF0F1923),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF0F4F8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );

  static const _textTheme = TextTheme(
    // Bebas Neue for display/poster titles — cinematic vernacular
    displayLarge: TextStyle(
      color: AppColors.textPrimary, fontSize: 54, letterSpacing: 2.0, height: 1.0,
    ),
    displayMedium: TextStyle(
      color: AppColors.textPrimary, fontSize: 40, letterSpacing: 1.5, height: 1.0,
    ),
    headlineLarge: TextStyle(
      color: AppColors.textPrimary, fontSize: 28, letterSpacing: 0.8,
    ),
    // DM Sans for UI headlines
    headlineMedium: TextStyle(
      color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3,
    ),
    headlineSmall: TextStyle(
      color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.2,
    ),
    titleLarge: TextStyle(
      color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.1,
    ),
    titleMedium: TextStyle(
      color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textSecondary, fontSize: 15, height: 1.6,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textSecondary, fontSize: 13, height: 1.5,
    ),
    bodySmall: TextStyle(
      color: AppColors.textMuted, fontSize: 12,
    ),
    labelLarge: TextStyle(
      color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.3,
    ),
    labelMedium: TextStyle(
      color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8,
    ),
    labelSmall: TextStyle(
      color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.0,
    ),
  );
}