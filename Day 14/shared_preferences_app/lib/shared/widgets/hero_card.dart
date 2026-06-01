import 'package:flutter/material.dart';

import 'hero_stat.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.launchCount,
    required this.currentUser,
    required this.loggedIn,
    required this.loggedInLabel,
    required this.loggedOutLabel,
    required this.launchesLabel,
    required this.currentUserLabel,
  });

  final String title;
  final String subtitle;
  final int launchCount;
  final String currentUser;
  final bool loggedIn;
  final String loggedInLabel;
  final String loggedOutLabel;
  final String launchesLabel;
  final String currentUserLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                HeroStat(
                  label: launchesLabel,
                  value: '$launchCount',
                  backgroundColor: colorScheme.onPrimary.withValues(
                    alpha: 0.16,
                  ),
                  foregroundColor: colorScheme.onPrimary,
                ),
                HeroStat(
                  label: currentUserLabel,
                  value: currentUser,
                  backgroundColor: colorScheme.onPrimary.withValues(
                    alpha: 0.16,
                  ),
                  foregroundColor: colorScheme.onPrimary,
                ),
                HeroStat(
                  label: 'Status',
                  value: loggedIn ? loggedInLabel : loggedOutLabel,
                  backgroundColor: colorScheme.onPrimary.withValues(
                    alpha: 0.16,
                  ),
                  foregroundColor: colorScheme.onPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
