import 'package:flutter/material.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F9FF), Color(0xFFE9F1FB), Color(0xFFF8FBFE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }
}

class PageSectionHeader extends StatelessWidget {
  const PageSectionHeader({
    super.key,
    required this.label,
    required this.title,
    required this.subtitle,
  });

  final String label;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F1FB),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF0F4C81),
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: Color(0xFF0A1D33),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF60748A), height: 1.45),
        ),
      ],
    );
  }
}

class NavigationHeroCard extends StatelessWidget {
  const NavigationHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.details = const [],
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> details;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFD7E6F4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F4C81),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              top: -48,
              right: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -56,
              left: -28,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF31A0F5).withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3FB),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          icon,
                          color: const Color(0xFF0F4C81),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Navigation showcase',
                              style: TextStyle(
                                color: Color(0xFF60748A),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Color(0xFF0A1D33),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.02,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: Color(0xFF526579),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (details.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F8FD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: details,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionPanel extends StatelessWidget {
  const ActionPanel({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDE8F3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F4C81),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFF0F4C81), width: 3)),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A1D33),
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPanel extends StatelessWidget {
  const ResultPanel({
    super.key,
    required this.title,
    required this.value,
    required this.emptyLabel,
  });

  final String title;
  final String? value;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return ActionPanel(
      title: title,
      child: Text(
        value ?? emptyLabel,
        style: TextStyle(
          color: value == null
              ? const Color(0xFF60748A)
              : const Color(0xFF0F4C81),
          fontWeight: value == null ? FontWeight.w500 : FontWeight.w700,
          height: 1.45,
        ),
      ),
    );
  }
}

class ExploreTabCard extends StatelessWidget {
  const ExploreTabCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.actionLabel,
    required this.actionIcon,
    required this.onPressed,
    this.showActionButton = true,
  });

  final String title;
  final String description;
  final IconData icon;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onPressed;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ActionPanel(
          title: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FB),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, color: const Color(0xFF0F4C81), size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        height: 1.45,
                        color: Color(0xFF30475D),
                      ),
                    ),
                  ),
                ],
              ),
              if (showActionButton) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onPressed,
                  icon: Icon(actionIcon),
                  label: Text(actionLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
