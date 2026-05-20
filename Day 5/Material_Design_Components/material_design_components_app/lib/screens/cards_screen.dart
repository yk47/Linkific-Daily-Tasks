import 'package:flutter/material.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cards & Lists')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: 6,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final cs = Theme.of(context).colorScheme;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.primary,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: cs.onPrimary),
                ),
              ),
              title: Text('Item ${index + 1}'),
              subtitle: const Text('Subtitle example'),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Item ${index + 1}'),
                  content: const Text('This is a Card + ListTile example.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
