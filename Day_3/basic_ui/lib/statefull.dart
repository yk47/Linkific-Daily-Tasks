import 'package:flutter/material.dart';

class StatefulCounterScreen extends StatefulWidget {
  static const routeName = '/stateful';

  const StatefulCounterScreen({super.key});

  @override
  State<StatefulCounterScreen> createState() => _StatefulCounterScreenState();
}

class _StatefulCounterScreenState extends State<StatefulCounterScreen> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StatefulWidget demo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 220,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Stateful counter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('setState rebuilds this screen'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: decrement,
                    child: const Text('Decrease'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: increment,
                    child: const Text('Increase'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
