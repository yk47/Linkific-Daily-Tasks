import 'package:flutter/material.dart';

import 'pages/notes_page.dart';
import 'src/database_initializer.dart';

void main() {
  initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFF1F4E79);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: baseColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F4EE),
      ),
      home: const NotesPage(),
    );
  }
}
