import 'package:flutter/material.dart';
import 'package:riverpod_state_manage/core/theme/app_theme.dart';


class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with teal glow container
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.tealGlow,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.tealDim, width: 1.5),
              ),
              child: Icon(icon, color: AppColors.teal, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}