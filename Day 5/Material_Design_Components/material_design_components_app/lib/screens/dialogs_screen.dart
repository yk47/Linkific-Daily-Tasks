import 'package:flutter/material.dart';

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogs & Snackbars'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _showAlert(context),
              child: const Text('Use AlertDialog for going back.'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showSimple(context),
              child: const Text('Use SimpleDialog for going back.'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showBottomSheet(context),
              child: const Text('Use BottomSheet for going back.'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Are you sure you want to go back?'),

                    action: SnackBarAction(
                      label: 'GO BACK',
                      textColor: Colors.redAccent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              child: Text('Use SnackBar for going back.'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('What do you want to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Stay Here',
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // go back to previous screen
            },
            child: const Text(
              'Go Back',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showSimple(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choose'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Stay Here',
              style: TextStyle(color: Colors.green),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // navigate back to previous screen
            },
            child: const Text(
              'Go Back',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            ListTile(
              title: const Text('Bottom sheet'),
              subtitle: const Text('Choose an action'),
            ),
            ListTile(
              title: const Text('Stay Here'),
              subtitle: const Text(
                'Close this sheet and remain on this screen',
              ),
              trailing: TextButton(
                onPressed: () => Navigator.pop(ctx), // close bottom sheet
                child: const Text('STAY'),
              ),
            ),
            ListTile(
              title: const Text('Go Back'),
              subtitle: const Text('Close sheet and return to previous screen'),
              trailing: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                onPressed: () {
                  Navigator.pop(ctx); // close bottom sheet
                  Navigator.pop(context); // go back to previous screen
                },
                child: const Text('GO BACK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
