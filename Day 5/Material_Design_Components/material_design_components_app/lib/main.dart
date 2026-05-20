import 'package:flutter/material.dart';
import 'screens/buttons_screen.dart';
import 'screens/cards_screen.dart';
import 'screens/forms_screen.dart';
import 'screens/dialogs_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF00695C);
    final cs = ColorScheme.fromSeed(seedColor: seed);
    return MaterialApp(
      title: 'Material Showcase',
      theme: ThemeData(
        colorScheme: cs,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: cs.surface,
          foregroundColor: cs.onSurface,
          elevation: 1,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.primary,
            side: BorderSide(color: cs.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: cs.primary),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: cs.secondary,
          foregroundColor: cs.onSecondary,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: cs.surfaceVariant,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cs.surfaceVariant,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: cs.primaryContainer,
          contentTextStyle: TextStyle(color: cs.onPrimaryContainer),
          behavior: SnackBarBehavior.floating,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: cs.surface,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FormsScreen(),
        '/buttons': (context) => const ButtonsScreen(),
        '/cards': (context) => const CardsScreen(),
        '/forms': (context) => const FormsScreen(),
        '/dialogs': (context) => const DialogsScreen(),
      },
    );
  }
}
