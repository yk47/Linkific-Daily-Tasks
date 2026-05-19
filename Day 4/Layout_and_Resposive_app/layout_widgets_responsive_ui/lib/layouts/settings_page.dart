import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool locationEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Account Settings Section
        _buildSectionHeader('Account'),
        _buildSettingsTile(
          icon: Icons.person,
          title: 'Profile',
          subtitle: 'Edit your profile information',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.lock,
          title: 'Password',
          subtitle: 'Change your password',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'user@example.com',
          onTap: () {},
        ),
        const Divider(height: 16),

        // Privacy Settings Section
        _buildSectionHeader('Privacy & Security'),
        _buildToggleTile(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Receive push notifications',
          value: notificationsEnabled,
          onChanged: (value) {
            setState(() {
              notificationsEnabled = value;
            });
          },
        ),
        _buildToggleTile(
          icon: Icons.location_on,
          title: 'Location Services',
          subtitle: 'Allow location access',
          value: locationEnabled,
          onChanged: (value) {
            setState(() {
              locationEnabled = value;
            });
          },
        ),
        _buildSettingsTile(
          icon: Icons.visibility,
          title: 'Privacy',
          subtitle: 'Manage privacy settings',
          onTap: () {},
        ),
        const Divider(height: 16),

        // Display Settings Section
        _buildSectionHeader('Display'),
        _buildToggleTile(
          icon: Icons.dark_mode,
          title: 'Dark Mode',
          subtitle: 'Use dark theme',
          value: darkModeEnabled,
          onChanged: (value) {
            setState(() {
              darkModeEnabled = value;
            });
          },
        ),
        _buildDropdownTile(
          icon: Icons.language,
          title: 'Language',
          subtitle: selectedLanguage,
          items: ['English', 'Spanish', 'French', 'German', 'Chinese'],
          onChanged: (value) {
            setState(() {
              selectedLanguage = value;
            });
          },
        ),
        _buildSettingsTile(
          icon: Icons.text_fields,
          title: 'Font Size',
          subtitle: 'Medium',
          onTap: () {},
        ),
        const Divider(height: 16),

        // About Section
        _buildSectionHeader('About'),
        _buildSettingsTile(
          icon: Icons.info,
          title: 'About App',
          subtitle: 'Version 1.0.0',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.description,
          title: 'Terms & Conditions',
          subtitle: 'Read our terms',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.shield,
          title: 'Privacy Policy',
          subtitle: 'Read our policy',
          onTap: () {},
        ),
        const Divider(height: 16),

        // Logout Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[700],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton<String>(
        onSelected: onChanged,
        itemBuilder: (BuildContext context) {
          return items
              .map((item) => PopupMenuItem(value: item, child: Text(item)))
              .toList();
        },
        child: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
