import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<AuthStatus> status = Rx<AuthStatus>(AuthStatus.uninitialized);
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final Rx<String?> errorMessage = Rx<String?>(null);

  bool get isAuthenticated => status.value == AuthStatus.authenticated;
  bool get isLoading => status.value == AuthStatus.loading;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() {
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser == null) {
        status.value = AuthStatus.unauthenticated;
        user.value = null;
      } else {
        status.value = AuthStatus.loading;
        try {
          user.value = await _authService.getCurrentUserData();
          status.value = AuthStatus.authenticated;
        } catch (e) {
          status.value = AuthStatus.authenticated;
          user.value = null;
        }
      }
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      user.value = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      status.value = AuthStatus.authenticated;
    } catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e);
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      user.value = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      status.value = AuthStatus.authenticated;
    } catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      user.value = await _authService.signInWithGoogle();

      status.value = AuthStatus.authenticated;
    } catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    status.value = AuthStatus.unauthenticated;
    user.value = null;
    errorMessage.value = null;
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? bio,
    String? phoneNumber,
  }) async {
    try {
      await _authService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
        bio: bio,
        phoneNumber: phoneNumber,
      );

      if (user.value != null) {
        user.value = user.value!.copyWith(
          displayName: displayName,
          photoURL: photoURL,
          bio: bio,
          phoneNumber: phoneNumber,
        );
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
      rethrow;
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('google sign in was cancelled')) {
      return 'Google sign in was cancelled.';
    } else if (errorString.contains('sign_in_canceled')) {
      return 'Google sign in was cancelled.';
    } else if (errorString.contains('network_error')) {
      return 'Network error. Check your internet connection.';
    } else if (errorString.contains('email-already-in-use')) {
      return 'This email is already registered.';
    } else if (errorString.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (errorString.contains('weak-password')) {
      return 'Password should be at least 6 characters.';
    } else if (errorString.contains('user-not-found')) {
      return 'No account found with this email.';
    } else if (errorString.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (errorString.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    }

    return 'An error occurred. Please try again.';
  }

  void clearError() {
    errorMessage.value = null;
  }
}