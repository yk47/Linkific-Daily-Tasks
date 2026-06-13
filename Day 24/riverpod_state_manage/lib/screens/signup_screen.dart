import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _obscurePassword = true.obs;
  final _obscureConfirm = true.obs;
  final _isLoading = false.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    _isLoading.value = true;
    final authService = Get.find<AuthService>();
    final error = await authService.signUpWithEmail(
      _emailController.text, _passwordController.text,
    );
    _isLoading.value = false;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.errorRed.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account created successfully'),
          backgroundColor: AppColors.teal,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      context.go('/home');
    }
  }

  Future<void> _signUpWithGoogle() async {
    _isLoading.value = true;
    final authService = Get.find<AuthService>();
    final error = await authService.signInWithGoogle();
    _isLoading.value = false;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.errorRed.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.tealDim, shape: BoxShape.circle,
                      border: Border.all(color: AppColors.teal.withOpacity(0.4), width: 2),
                    ),
                    child: const Icon(Icons.movie_filter_rounded, color: AppColors.teal, size: 42),
                  ),
                  const SizedBox(height: 24),
                  Text('Create Account', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text('Join Movie Explorer today', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController, keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!value.contains('@')) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(() => TextFormField(
                    controller: _passwordController, obscureText: _obscurePassword.value,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword.value ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                        onPressed: () => _obscurePassword.toggle(),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter a password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  )),
                  const SizedBox(height: 16),
                  Obx(() => TextFormField(
                    controller: _confirmPasswordController, obscureText: _obscureConfirm.value,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password', prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm.value ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                        onPressed: () => _obscureConfirm.toggle(),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                    onFieldSubmitted: (_) => _signUp(),
                  )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                      onPressed: _isLoading.value ? null : _signUp,
                      child: _isLoading.value
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bg))
                          : const Text('Create Account'),
                    )),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => OutlinedButton.icon(
                      onPressed: _isLoading.value ? null : _signUpWithGoogle,
                      icon: Image.asset('assets/google_logo.png', height: 20, width: 20,
                        errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata_rounded, size: 24),
                      ),
                      label: const Text('Sign up with Google'),
                    )),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text('Sign In', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.teal)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}