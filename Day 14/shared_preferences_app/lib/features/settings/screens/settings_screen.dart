import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/hero_card.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/storage_badge.dart';
import '../models/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const List<String> _topicOptions = <String>[
    'Flutter',
    'SharedPreferences',
    'Local storage',
    'Settings',
  ];

  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = true;
  SettingsState _state = SettingsState.defaults();

  Map<String, String> get _strings =>
      AppStrings.localized[_state.languageCode] ?? AppStrings.localized['en']!;

  String _text(String key) => _strings[key] ?? key;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final SettingsState loaded = await PreferencesService.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _state = loaded;
      _nameController.text = loaded.displayName == 'Guest'
          ? ''
          : loaded.displayName;
      _isLoading = false;
    });
  }

  Future<void> _persist(SettingsState nextState) async {
    setState(() {
      _state = nextState;
    });
    await PreferencesService.save(nextState);
  }

  Future<void> _saveProfile() async {
    final String trimmedName = _nameController.text.trim();
    final SettingsState nextState = _state.copyWith(
      displayName: trimmedName.isEmpty ? _text('guest') : trimmedName,
    );
    await _persist(nextState);
  }

  Future<void> _setLanguage(String languageCode) async {
    await _persist(_state.copyWith(languageCode: languageCode));
  }

  Future<void> _setDarkMode(bool value) async {
    await _persist(_state.copyWith(isDarkMode: value));
  }

  Future<void> _setNotifications(bool value) async {
    await _persist(_state.copyWith(notificationsEnabled: value));
  }

  Future<void> _setRememberLogin(bool value) async {
    await _persist(_state.copyWith(rememberLogin: value));
  }

  Future<void> _toggleLogin() async {
    await _persist(_state.copyWith(isLoggedIn: !_state.isLoggedIn));
  }

  Future<void> _setFontScale(double value) async {
    await _persist(_state.copyWith(fontScale: value));
  }

  Future<void> _toggleTopic(String topic, bool isSelected) async {
    final List<String> updatedTopics = List<String>.from(_state.favoriteTopics);
    if (isSelected) {
      if (!updatedTopics.contains(topic)) {
        updatedTopics.add(topic);
      }
    } else {
      updatedTopics.remove(topic);
    }
    await _persist(_state.copyWith(favoriteTopics: updatedTopics));
  }

  Future<void> _forgetSavedLogin() async {
    await PreferencesService.forgetLogin();
    if (!mounted) {
      return;
    }
    setState(() {
      _state = _state.copyWith(isLoggedIn: false, displayName: _text('guest'));
      _nameController.clear();
    });
  }

  Future<void> _clearAllPreferences() async {
    await PreferencesService.clearAll();
    if (!mounted) {
      return;
    }
    setState(() {
      _state = SettingsState.defaults();
      _nameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _text('appTitle'),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (BuildContext context, Widget? child) {
        final Widget content = child ?? const SizedBox.shrink();
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(_state.fontScale)),
          child: content,
        );
      },
      home: _isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              appBar: AppBar(
                title: Text(_text('appTitle')),
                centerTitle: false,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HeroCard(
                          title: _text('heroTitle'),
                          subtitle: _text('heroSubtitle'),
                          launchCount: _state.launchCount,
                          currentUser: _state.displayName,
                          loggedIn: _state.isLoggedIn,
                          loggedInLabel: _text('loggedIn'),
                          loggedOutLabel: _text('loggedOut'),
                          launchesLabel: _text('launches'),
                          currentUserLabel: _text('currentUser'),
                        ),
                        const SizedBox(height: 16),
                        SectionCard(
                          title: _text('preferences'),
                          child: Column(
                            children: [
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: Text(_text('darkMode')),
                                subtitle: Text(_text('theme')),
                                value: _state.isDarkMode,
                                onChanged: _setDarkMode,
                              ),
                              const Divider(height: 1),
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: Text(_text('notifications')),
                                subtitle: const Text(
                                  'Push alerts and reminder preferences',
                                ),
                                value: _state.notificationsEnabled,
                                onChanged: _setNotifications,
                              ),
                              const Divider(height: 1),
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: Text(_text('rememberLogin')),
                                subtitle: Text(
                                  _state.rememberLogin
                                      ? 'Saved across restarts'
                                      : 'Session only',
                                ),
                                value: _state.rememberLogin,
                                onChanged: _setRememberLogin,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _state.languageCode,
                                decoration: InputDecoration(
                                  labelText: _text('language'),
                                  border: const OutlineInputBorder(),
                                ),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'en',
                                    child: Text(_text('defaultLanguage')),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'es',
                                    child: Text(_text('secondaryLanguage')),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  if (value != null) {
                                    _setLanguage(value);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${_text('fontSize')}: ${_state.fontScale.toStringAsFixed(1)}x',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              Slider(
                                value: _state.fontScale,
                                min: 0.9,
                                max: 1.4,
                                divisions: 5,
                                label: _state.fontScale.toStringAsFixed(1),
                                onChanged: (double value) {
                                  setState(() {
                                    _state = _state.copyWith(fontScale: value);
                                  });
                                },
                                onChangeEnd: _setFontScale,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SectionCard(
                          title: _text('profile'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: _text('displayName'),
                                  border: const OutlineInputBorder(),
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _saveProfile(),
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: _saveProfile,
                                icon: const Icon(Icons.save),
                                label: Text(_text('saveProfile')),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _toggleLogin,
                                      child: Text(
                                        _state.isLoggedIn
                                            ? _text('logout')
                                            : _text('login'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _forgetSavedLogin,
                                      child: Text(_text('forgetSavedLogin')),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SectionCard(
                          title: _text('topics'),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _topicOptions.map((String topic) {
                              final bool isSelected = _state.favoriteTopics
                                  .contains(topic);
                              return FilterChip(
                                label: Text(topic),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  _toggleTopic(topic, selected);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SectionCard(
                          title: _text('storagePatterns'),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              const StorageBadge(label: 'setString'),
                              const StorageBadge(label: 'setInt'),
                              const StorageBadge(label: 'setBool'),
                              const StorageBadge(label: 'setDouble'),
                              const StorageBadge(label: 'setStringList'),
                              const StorageBadge(label: 'remove(key)'),
                              const StorageBadge(label: 'clear()'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.tonalIcon(
                          onPressed: _clearAllPreferences,
                          icon: const Icon(Icons.delete_outline),
                          label: Text(_text('clearAll')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
