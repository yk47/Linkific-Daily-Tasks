# SharedPreferences Lab 🗂️

A Flutter demonstration app covering every core capability of the [`shared_preferences`](https://pub.dev/packages/shared_preferences) package — all five data types, read/write patterns, selective removal, and a full preference reset.

---

## What It Does

The app is a single settings screen that persists seven categories of user data across app restarts using device-local key-value storage:

| Preference | Type | Default |
|---|---|---|
| Dark mode | `bool` | `false` |
| Notifications enabled | `bool` | `true` |
| Remember login | `bool` | `true` |
| Logged in | `bool` | `false` |
| Language code | `String` | `"en"` |
| Display name | `String` | `"Guest"` |
| Font scale | `double` | `1.0` |
| Launch count | `int` | `0` |
| Favourite topics | `List<String>` | `["Flutter", "SharedPreferences"]` |

Every change is written immediately — settings survive a force-quit at any point.

---

## Getting Started

**Prerequisites:** Flutter SDK with Dart ^3.11.5

```bash
# Clone / unzip the project, then:
flutter pub get
flutter run
```

The `shared_preferences` package is already declared in `pubspec.yaml` — no extra setup needed.

---

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── pref_keys.dart        # All SharedPreferences key strings
│   │   └── app_strings.dart      # Localised UI strings (en + es)
│   ├── services/
│   │   └── preferences_service.dart  # All SharedPreferences I/O
│   └── theme/
│       └── app_theme.dart        # Light + dark ThemeData
├── features/
│   └── settings/
│       ├── models/
│       │   └── settings_state.dart   # Immutable preference state
│       ├── screens/
│       │   └── settings_screen.dart  # Main (and only) screen
│       └── widgets/
│           └── info_banner.dart
├── shared/
│   └── widgets/
│       ├── hero_card.dart        # Top status banner
│       ├── hero_stat.dart
│       ├── section_card.dart     # Reusable section wrapper
│       └── storage_badge.dart    # API method label chips
└── main.dart
```

---

## Storage Patterns Guide

### Getting the instance

```dart
final SharedPreferences prefs = await SharedPreferences.getInstance();
```

Call this once per operation. The package caches the instance internally so repeated calls are cheap.

---

### Writing data

```dart
await prefs.setBool('theme_mode', true);
await prefs.setString('language_code', 'es');
await prefs.setInt('launch_count', 5);
await prefs.setDouble('font_scale', 1.2);
await prefs.setStringList('favourite_topics', ['Flutter', 'Dart']);
```

All setters are `async` and return `Future<bool>`. Await them to confirm the write completed before reading back.

---

### Reading data

Always provide a default with `??` — the key may not exist yet (e.g. first launch):

```dart
final bool isDark    = prefs.getBool('theme_mode')           ?? false;
final String lang    = prefs.getString('language_code')      ?? 'en';
final int launches   = prefs.getInt('launch_count')          ?? 0;
final double scale   = prefs.getDouble('font_scale')         ?? 1.0;
final List<String> topics = prefs.getStringList('topics')    ?? [];
```

Centralise your defaults in one place (see `SettingsState.defaults()`) rather than scattering them across call sites.

---

### Removing data

```dart
// Remove a single key
await prefs.remove('logged_in');

// Wipe everything in the app's namespace
await prefs.clear();
```

Prefer `remove()` over writing a sentinel value (e.g. `""` or `-1`). Absent keys are cleaner and easier to reason about.

---

### Checking if a key exists

```dart
final bool hasName = prefs.containsKey('display_name');
```

Useful for first-launch detection or migrating old key names.

---

## Key Naming Conventions

- Use `snake_case` — storage layers are case-sensitive across platforms.
- Centralise all key strings in a constants class (see `PrefKeys`) to prevent typo bugs and make renaming safe.
- Prefix with your app name in multi-module projects: `myapp_theme_mode`.

---

## When to Use SharedPreferences

**Good fit:**
- Simple on/off toggles, language codes, theme choices
- First-launch flags, tutorial completion booleans
- Small counters or scalar values
- Non-sensitive user preferences

**Not a good fit:**
- Lists of complex objects → use [Hive](https://pub.dev/packages/hive) or [Isar](https://pub.dev/packages/isar)
- Data that needs querying or sorting → use [sqflite](https://pub.dev/packages/sqflite)
- Secrets, tokens, or credentials → use [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- Large data sets (> ~50 KB) — the entire preference file loads into memory on each `getInstance()` call

---

## Features Demonstrated

- [x] `setBool` / `getBool` — theme, notifications, login flags
- [x] `setString` / `getString` — language code, display name
- [x] `setInt` / `getInt` — persistent launch counter
- [x] `setDouble` / `getDouble` — font scale slider
- [x] `setStringList` / `getStringList` — favourite topic chips
- [x] `remove(key)` — selective credential erasure
- [x] `clear()` — full preference reset
- [x] Safe null-coalescing defaults on every read
- [x] Immutable state model (`SettingsState` + `copyWith`)
- [x] Theme applied on cold restart
- [x] Bilingual UI (English / Spanish) driven by persisted locale
- [x] Font scale applied globally via `MediaQuery.copyWith`

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.5.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```
