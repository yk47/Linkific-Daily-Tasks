import 'package:flutter/material.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buttons')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showSnack(context, 'Elevated button pressed'),
              icon: const Icon(Icons.check),
              label: const Text('Elevated'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _showSnack(context, 'Outlined button pressed'),
              child: const Text('Outlined'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _showSnack(context, 'Text button pressed'),
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 8),
            IconButton(
              onPressed: () => _showSnack(context, 'Icon button pressed'),
              icon: const Icon(Icons.thumb_up),
              tooltip: 'Like',
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Center(
              child: FloatingActionButton(
                onPressed: () => _showSnack(context, 'FAB pressed'),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
