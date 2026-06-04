import 'package:flutter/material.dart';
import 'package:supabase_auth_app/screens/home_screen.dart';
import 'package:supabase_auth_app/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign Up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  /// Sign In
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Google Sign In
  Future<bool> signInWithGoogle() async {
    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback',
    );
  }

  /// Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Current User
  User? get currentUser => _supabase.auth.currentUser;

  /// Current Session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Auth State Changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Create/Update Profile after Google Login
  Future<void> saveGoogleUserProfile() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return;

    await _supabase.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'name':
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          'Google User',
    });
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
