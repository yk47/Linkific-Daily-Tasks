import 'package:flutter/material.dart';
import 'layouts/instagram_post_card.dart';
import 'layouts/whatsapp_chat_screen.dart';
import 'layouts/ecommerce_grid.dart';
import 'layouts/settings_page.dart';
import 'layouts/profile_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LayoutShowcase(),
    );
  }
}

class LayoutShowcase extends StatefulWidget {
  const LayoutShowcase({super.key});

  @override
  State<LayoutShowcase> createState() => _LayoutShowcaseState();
}

class _LayoutShowcaseState extends State<LayoutShowcase> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Layout Widgets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Instagram',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'WhatsApp'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'E-Commerce',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const InstagramPostCard();
      case 1:
        return const WhatsAppChatScreen();
      case 2:
        return const EcommerceGrid();
      case 3:
        return const SettingsPage();
      case 4:
        return const ProfileCard();
      default:
        return const InstagramPostCard();
    }
  }
}
