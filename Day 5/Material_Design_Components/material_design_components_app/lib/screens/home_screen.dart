import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.username = 'Guest', this.email});

  final String username;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: cs.onPrimary,
                        child: Icon(Icons.palette, color: cs.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, $username',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: cs.onPrimary),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              email == null
                                  ? 'You are now inside the dashboard.'
                                  : 'Signed in with $email',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: cs.onPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _navCard(context, 'Buttons', '/buttons', Icons.smart_button, cs),
            _navCard(context, 'Cards & Lists', '/cards', Icons.view_agenda, cs),
            _navCard(
              context,
              'Dialogs & Snackbars',
              '/dialogs',
              Icons.forum,
              cs,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Account summary'),
                subtitle: Text('Username: $username'),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged in as $username')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/', (route) => false),
        label: const Text('Logout'),
        icon: const Icon(Icons.logout),
      ),
    );
  }

  Widget _navCard(
    BuildContext context,
    String title,
    String route,
    IconData icon,
    ColorScheme cs,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.primary,
          child: Icon(icon, color: cs.onPrimary),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
