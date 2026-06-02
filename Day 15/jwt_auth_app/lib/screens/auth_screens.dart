import 'package:flutter/material.dart';

import '../auth/auth_repository.dart';

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope not found in widget tree.');
    return scope!.notifier!;
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthScope.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isBootstrapping) {
          return const SplashScreen();
        }

        if (controller.isAuthenticated) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _GradientBackdrop(child: Center(child: _SplashBadge())),
    );
  }
}

class _SplashBadge extends StatelessWidget {
  const _SplashBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  Icons.verified_user_outlined,
                  color: scheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'JWT Auth App',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Checking your secure session...',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator.adaptive(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'eve.holt@reqres.in');
  final _passwordController = TextEditingController(text: 'cityslicka');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = AuthScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await controller.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on AuthApiException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AuthScope.of(context);
    return Scaffold(
      body: _GradientBackdrop(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _AuthHero(
                            title: 'Welcome back',
                            subtitle:
                                'Sign in with ReqRes demo credentials and resume your session securely.',
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email address',
                              hintText: 'eve.holt@reqres.in',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'cityslicka',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Enter at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: controller.isSubmitting ? null : _submit,
                            child: controller.isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Sign in'),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: controller.isSubmitting
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                            child: const Text('Create a new account'),
                          ),
                          const SizedBox(height: 16),
                          const _DemoCredentialsCard(
                            username: 'eve.holt@reqres.in',
                            password: 'cityslicka',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'Yash');
  final _lastNameController = TextEditingController(text: 'Karnik');
  final _usernameController = TextEditingController(text: 'yk47');
  final _emailController = TextEditingController(text: 'eve.holt@reqres.in');
  final _passwordController = TextEditingController(text: 'pistol');
  final _confirmPasswordController = TextEditingController(text: 'pistol');

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = AuthScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await controller.register(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthApiException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AuthScope.of(context);
    return Scaffold(
      body: _GradientBackdrop(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _AuthHero(
                            title: 'Create account',
                            subtitle:
                                'Register with ReqRes, store the token in secure storage, and auto-login on restart.',
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'First name',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Last name',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username (local only)',
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email address',
                              hintText: 'eve.holt@reqres.in',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (!text.contains('@') || !text.contains('.')) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'pistol',
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Use at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: controller.isSubmitting ? null : _submit,
                            child: controller.isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Create account'),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: controller.isSubmitting
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            child: const Text('I already have an account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthScope.of(context);
    final session = controller.session;
    final user = session?.user;
    final token = session?.accessToken ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Protected Home'),
        actions: [
          IconButton(
            onPressed: controller.isSubmitting
                ? null
                : () async {
                    await controller.logout();
                  },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          _ProfileHero(user: user),
          const SizedBox(height: 20),
          _InfoCard(
            title: 'Saved token',
            child: _TokenRow(label: 'ReqRes token', value: token),
          ),
          const SizedBox(height: 20),
          _InfoCard(
            title: 'Authentication flow',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _BulletLine(
                  text:
                      'ReqRes login/register returns a token that is saved securely.',
                ),
                _BulletLine(
                  text:
                      'The app restores the stored token on restart to keep the user signed in.',
                ),
                _BulletLine(
                  text: 'Logout clears the stored session from secure storage.',
                ),
              ],
            ),
          ),
          if (controller.isSubmitting) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator.adaptive()),
          ],
        ],
      ),
    );
  }
}

class _GradientBackdrop extends StatelessWidget {
  const _GradientBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF134E4A), Color(0xFF0B1120)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _DecorativeOrb(
              color: Colors.white.withOpacity(0.14),
              size: 180,
            ),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: _DecorativeOrb(
              color: Colors.white.withOpacity(0.08),
              size: 140,
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _DecorativeOrb extends StatelessWidget {
  const _DecorativeOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: scheme.primaryContainer,
          child: Icon(
            Icons.lock_outline_rounded,
            color: scheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54, height: 1.4),
        ),
      ],
    );
  }
}

class _DemoCredentialsCard extends StatelessWidget {
  const _DemoCredentialsCard({required this.username, required this.password});

  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F7F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB7E3DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo credentials',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('Username: $username'),
          Text('Password: $password'),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final displayName = user?.displayName ?? 'Authenticated user';
    final email = user?.email.isNotEmpty == true
        ? user!.email
        : 'Session restored from secure storage';
    final imageUrl = user?.image;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl == null || imageUrl.isEmpty
                  ? const Icon(Icons.person_rounded, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(email, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _StatusPill(label: 'Token stored securely'),
                      _StatusPill(label: 'Protected route'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _TokenRow extends StatelessWidget {
  const _TokenRow({required this.label, required this.value});

  final String label;
  final String value;

  String get preview {
    if (value.isEmpty) {
      return 'Not available';
    }
    if (value.length <= 28) {
      return value;
    }
    return '${value.substring(0, 14)}...${value.substring(value.length - 10)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        SelectableText(preview, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              Icons.check_circle_rounded,
              size: 16,
              color: Color(0xFF0F766E),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
