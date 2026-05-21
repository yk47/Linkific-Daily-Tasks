import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('themeMode') ?? 'system';
  ThemeMode initialMode = ThemeMode.system;
  if (saved == 'light') initialMode = ThemeMode.light;
  if (saved == 'dark') initialMode = ThemeMode.dark;

  runApp(MyApp(initialMode: initialMode));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.initialMode});

  final ThemeMode initialMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialMode;
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _themeMode = mode);
    final value = mode == ThemeMode.system
        ? 'system'
        : (mode == ThemeMode.light ? 'light' : 'dark');
    await prefs.setString('themeMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Studio',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _themeMode,
      home: ThemeShowcasePage(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
    );
  }
}

class ThemeShowcasePage extends StatelessWidget {
  const ThemeShowcasePage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  static const List<(ThemeMode, IconData, String)> _segments = [
    (ThemeMode.system, Icons.brightness_auto_outlined, 'System'),
    (ThemeMode.light, Icons.light_mode_outlined, 'Light'),
    (ThemeMode.dark, Icons.dark_mode_outlined, 'Dark'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.14),
              colorScheme.surface,
              colorScheme.tertiary.withValues(alpha: 0.12),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('Theme Studio'),
                centerTitle: true,
                pinned: true,
                floating: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SegmentedButton<ThemeMode>(
                      segments: _segments
                          .map(
                            (segment) => ButtonSegment<ThemeMode>(
                              value: segment.$1,
                              icon: Icon(segment.$2),
                              label: Text(segment.$3),
                            ),
                          )
                          .toList(growable: false),
                      selected: {themeMode},
                      onSelectionChanged: (selection) {
                        onThemeModeChanged(selection.first);
                      },
                      showSelectedIcon: false,
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    _HeroCard(
                      title: 'Custom color scheme',
                      subtitle:
                          'This demo uses a seed-based Material 3 palette to keep light and dark surfaces visually connected.',
                      accent: colorScheme.primary,
                      secondaryAccent: colorScheme.tertiary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active theme: ${_modeLabel(themeMode)}',
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Switch the app theme from the segmented control above to see the interface adapt instantly.',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        _ColorTile(
                          label: 'Primary',
                          color: colorScheme.primary,
                        ),
                        _ColorTile(
                          label: 'Secondary',
                          color: colorScheme.secondary,
                        ),
                        _ColorTile(
                          label: 'Tertiary',
                          color: colorScheme.tertiary,
                        ),
                        _ColorTile(
                          label: 'Surface',
                          color: colorScheme.surface,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.palette_outlined,
                            title: 'Material 3',
                            description:
                                'Built with theme-driven surfaces, typography, and elevation.',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.brightness_6_outlined,
                            title: 'Modes',
                            description:
                                'Supports system, light, and dark modes with saved preferences.',
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _modeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.secondaryAccent,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final Color secondaryAccent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.18),
            secondaryAccent.withValues(alpha: 0.18),
          ],
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodyMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(subtitle),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorTile extends StatelessWidget {
  const _ColorTile({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final onColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      width: 132,
      height: 112,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label, style: TextStyle(color: onColor.withValues(alpha: 0.9))),
          Text(
            _hex(color),
            style: TextStyle(color: onColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  String _hex(Color color) {
    final value = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return '#${value.substring(2)}';
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
