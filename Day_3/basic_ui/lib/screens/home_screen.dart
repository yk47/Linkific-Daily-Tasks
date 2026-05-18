import 'package:flutter/material.dart';

import '../statefull.dart';
import '../stateless.dart';
import 'layout_showcase_screen.dart';

class LearningHomeScreen extends StatelessWidget {
  const LearningHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic UI Lab')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flutter widget tree basics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Everything in Flutter is a widget. This app shows the difference between stateless and stateful widgets and how layout widgets work together.',
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _TopicChip(label: 'Widget tree'),
                    _TopicChip(label: 'MaterialApp'),
                    _TopicChip(label: 'Scaffold'),
                    _TopicChip(label: 'Navigation'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Widget tree snapshot'),
          const SizedBox(height: 12),
          const _TreeCard(),
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Open a demo screen'),
          const SizedBox(height: 12),
          _DemoButton(
            title: 'Stateless widget example',
            subtitle: 'Learn how UI is built without mutable state.',
            onPressed: () =>
                Navigator.pushNamed(context, StatelessBasicsScreen.routeName),
          ),
          const SizedBox(height: 12),
          _DemoButton(
            title: 'Stateful widget example',
            subtitle: 'See how setState updates the interface.',
            onPressed: () =>
                Navigator.pushNamed(context, StatefulCounterScreen.routeName),
          ),
          const SizedBox(height: 12),
          _DemoButton(
            title: 'Layout widget example',
            subtitle: 'Practice Row, Column, Stack, Expanded, and ListView.',
            onPressed: () =>
                Navigator.pushNamed(context, LayoutShowcaseScreen.routeName),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _TreeCard extends StatelessWidget {
  const _TreeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'MyApp\n  └─ MaterialApp\n      └─ LearningHomeScreen\n          └─ Scaffold\n              ├─ AppBar\n              └─ ListView\n                  ├─ Widget tree card\n                  └─ Demo buttons',
        style: TextStyle(height: 1.5),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(18),
        alignment: Alignment.centerLeft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}
