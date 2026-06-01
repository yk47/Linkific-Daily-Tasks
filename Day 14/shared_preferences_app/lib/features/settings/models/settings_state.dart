class SettingsState {
  const SettingsState({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.rememberLogin,
    required this.isLoggedIn,
    required this.languageCode,
    required this.displayName,
    required this.fontScale,
    required this.launchCount,
    required this.favoriteTopics,
  });

  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool rememberLogin;
  final bool isLoggedIn;
  final String languageCode;
  final String displayName;
  final double fontScale;
  final int launchCount;
  final List<String> favoriteTopics;

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? rememberLogin,
    bool? isLoggedIn,
    String? languageCode,
    String? displayName,
    double? fontScale,
    int? launchCount,
    List<String>? favoriteTopics,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      rememberLogin: rememberLogin ?? this.rememberLogin,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      languageCode: languageCode ?? this.languageCode,
      displayName: displayName ?? this.displayName,
      fontScale: fontScale ?? this.fontScale,
      launchCount: launchCount ?? this.launchCount,
      favoriteTopics: favoriteTopics ?? this.favoriteTopics,
    );
  }

  factory SettingsState.defaults() {
    return const SettingsState(
      isDarkMode: false,
      notificationsEnabled: true,
      rememberLogin: true,
      isLoggedIn: false,
      languageCode: 'en',
      displayName: 'Guest',
      fontScale: 1.0,
      launchCount: 0,
      favoriteTopics: <String>['Flutter', 'SharedPreferences'],
    );
  }
}
