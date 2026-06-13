import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'PREFERENCES',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                          color: AppColors.teal,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Settings',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 26),
                  ),
                ],
              ),
            ),

            // Settings tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.dark_mode_rounded,
                      iconColor: AppColors.teal,
                      title: 'Dark Mode',
                      subtitle: 'Use dark colour scheme',
                      trailing: Switch(
                        value: true,
                        onChanged: (_) {
                          // Theme toggle - always dark mode now
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Account section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'ACCOUNT',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  letterSpacing: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    GetBuilder<AuthService>(
                      builder: (auth) {
                        final user = auth.user;
                        return _SettingsTile(
                          icon: Icons.person_outline_rounded,
                          iconColor: AppColors.teal,
                          title: user?.email ?? 'Not signed in',
                          subtitle: user != null ? 'Signed in' : 'Sign in to save preferences',
                          trailing: const SizedBox.shrink(),
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.logout_rounded,
                      iconColor: AppColors.errorRed,
                      title: 'Sign Out',
                      subtitle: 'Log out of your account',
                      trailing: const SizedBox.shrink(),
                      onTap: () async {
                        final auth = Get.find<AuthService>();
                        await auth.signOut();
                        if (context.mounted) context.go('/login');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // App info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'ABOUT',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  letterSpacing: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.textMuted,
                  title: 'Version',
                  subtitle: '1.0.0',
                  trailing: SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}