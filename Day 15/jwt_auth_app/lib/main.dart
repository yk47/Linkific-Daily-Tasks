import 'dart:async';

import 'package:flutter/material.dart';

import 'auth/auth_repository.dart';
import 'screens/auth_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JwtAuthApp());
}

class JwtAuthApp extends StatefulWidget {
  const JwtAuthApp({super.key, this.bootstrapOnCreate = true, this.controller});

  final bool bootstrapOnCreate;
  final AuthController? controller;

  @override
  State<JwtAuthApp> createState() => _JwtAuthAppState();
}

class _JwtAuthAppState extends State<JwtAuthApp> {
  late final AuthController _controller = widget.controller ?? AuthController();
  late final bool _ownsController = widget.controller == null;

  @override
  void initState() {
    super.initState();
    if (widget.bootstrapOnCreate) {
      unawaited(_controller.bootstrap());
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _controller,
      child: MaterialApp(
        title: 'JWT Auth App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F766E),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            color: Colors.white.withOpacity(0.94),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: Colors.black.withOpacity(0.04)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}
