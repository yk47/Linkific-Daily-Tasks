import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/models/settings_state.dart';
import '../constants/pref_keys.dart';

class PreferencesService {
  PreferencesService._();

  static Future<SettingsState> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SettingsState defaults = SettingsState.defaults();
    final String languageCode =
        preferences.getString(PrefKeys.languageCode) ?? defaults.languageCode;
    final bool rememberLogin =
        preferences.getBool(PrefKeys.rememberLogin) ?? defaults.rememberLogin;
    final String storedName = preferences.getString(PrefKeys.displayName) ?? '';
    final List<String> favoriteTopics =
        preferences.getStringList(PrefKeys.favoriteTopics) ??
        defaults.favoriteTopics;
    final int launchCount =
        (preferences.getInt(PrefKeys.launchCount) ?? defaults.launchCount) + 1;

    await preferences.setInt(PrefKeys.launchCount, launchCount);

    return SettingsState(
      isDarkMode:
          preferences.getBool(PrefKeys.themeMode) ?? defaults.isDarkMode,
      notificationsEnabled:
          preferences.getBool(PrefKeys.notificationsEnabled) ??
          defaults.notificationsEnabled,
      rememberLogin: rememberLogin,
      isLoggedIn: rememberLogin
          ? (preferences.getBool(PrefKeys.loggedIn) ?? defaults.isLoggedIn)
          : false,
      languageCode: languageCode,
      displayName: storedName.isEmpty ? defaults.displayName : storedName,
      fontScale:
          preferences.getDouble(PrefKeys.fontScale) ?? defaults.fontScale,
      launchCount: launchCount,
      favoriteTopics: favoriteTopics
          .where(
            (String topic) =>
                defaults.favoriteTopics.contains(topic) ||
                _knownTopics.contains(topic),
          )
          .toList(),
    );
  }

  static Future<void> save(SettingsState state) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PrefKeys.themeMode, state.isDarkMode);
    await preferences.setBool(
      PrefKeys.notificationsEnabled,
      state.notificationsEnabled,
    );
    await preferences.setBool(PrefKeys.rememberLogin, state.rememberLogin);
    await preferences.setString(PrefKeys.languageCode, state.languageCode);
    await preferences.setDouble(PrefKeys.fontScale, state.fontScale);
    await preferences.setInt(PrefKeys.launchCount, state.launchCount);
    await preferences.setStringList(
      PrefKeys.favoriteTopics,
      List<String>.from(state.favoriteTopics),
    );

    if (state.rememberLogin) {
      await preferences.setBool(PrefKeys.loggedIn, state.isLoggedIn);
      await preferences.setString(PrefKeys.displayName, state.displayName);
    } else {
      await preferences.remove(PrefKeys.loggedIn);
      await preferences.remove(PrefKeys.displayName);
    }
  }

  static Future<void> forgetLogin() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(PrefKeys.loggedIn);
    await preferences.remove(PrefKeys.displayName);
  }

  static Future<void> clearAll() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static const List<String> _knownTopics = <String>[
    'Flutter',
    'SharedPreferences',
    'Local storage',
    'Settings',
  ];
}
