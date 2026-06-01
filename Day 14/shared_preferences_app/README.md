# Shared Preferences App

A Flutter sample focused on local key-value storage with `shared_preferences`.

## What it demonstrates

- Theme persistence with `setBool` and `ThemeMode`
- Language selection stored as a string
- Login state persistence for a simple remember-me flow
- Notification settings saved locally
- Text size saved as a double and restored on startup
- Launch count stored with `setInt`
- Favorite topic selections stored with `setStringList`
- Targeted cleanup with `remove(key)` and full reset with `clear()`

## Storage patterns

`shared_preferences` is best for small, simple app data such as user settings and lightweight flags.

Use it for:

- First launch flags
- Theme or language choice
- Logged-in or remembered state
- Basic toggle preferences
- Small lists such as favorites or tags

Avoid it for:

- Large documents
- Search indexes
- Relational data
- Anything that needs complex querying

## Key APIs in this app

- `SharedPreferences.getInstance()`
- `setString`, `setInt`, `setBool`, `setDouble`, `setStringList`
- `getString`, `getInt`, `getBool`, `getDouble`, `getStringList`
- `remove(key)`
- `clear()`

## Run it

```bash
flutter pub get
flutter run
```

## Notes

The app updates its saved values as you interact with the UI, then restores them automatically after a restart.
