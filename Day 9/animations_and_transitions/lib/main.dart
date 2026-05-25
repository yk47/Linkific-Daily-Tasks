import 'package:flutter/material.dart';
import 'screens/implicit_examples.dart';
import 'screens/explicit_examples.dart';
import 'screens/hero_examples.dart';
import 'screens/animated_builder_examples.dart';
import 'screens/animated_ui_examples.dart';

void main() {
  runApp(const AnimationsCatalogApp());
}

class AnimationsCatalogApp extends StatelessWidget {
  const AnimationsCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = Colors.deepPurple;
    return MaterialApp(
      title: 'Flutter Animations Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        appBarTheme: AppBarTheme(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations Catalog')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore animation examples',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _card(
                    context,
                    Icons.auto_awesome,
                    'Implicit animations',
                    'AnimatedContainer, opacity, cross-fade',
                    const ImplicitExamples(),
                  ),
                  _card(
                    context,
                    Icons.timeline,
                    'Explicit animations',
                    'AnimationController & Tween',
                    const ExplicitExamples(),
                  ),
                  _card(
                    context,
                    Icons.airplane_ticket,
                    'Hero & transitions',
                    'Hero, flight shuttles, custom paths',
                    const HeroExamples(),
                  ),
                  _card(
                    context,
                    Icons.build_circle,
                    'AnimatedBuilder',
                    'Optimized rebuilds & transforms',
                    const AnimatedBuilderExamples(),
                  ),
                  _card(
                    context,
                    Icons.devices,
                    'Animated UIs',
                    'Login reveal, loading states',
                    const AnimatedUiExamples(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget page,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}
