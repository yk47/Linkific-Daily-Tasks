# Theming Guide

Learning objectives
- Understand Flutter theming and Material 3
- Implement custom light and dark themes
- Add a theme toggle and persist preference

Files of interest
- `lib/src/theme.dart` — color schemes and `ThemeData`
- `lib/main.dart` — theme initialization, toggle, persistence

How it works
- Uses Material 3 (`useMaterial3: true`) and `ColorScheme.fromSeed` for coherent palettes.
- Theme preference stored in `SharedPreferences` under key `themeMode` (values: `light`, `dark`, `system`).
- Toggle cycles: light → dark → system.

Run locally
```bash
flutter pub get
flutter run
```

Recommended learning (search on YouTube)
- "Flutter theming complete guide"
- "Flutter dark mode tutorial"
- "Material 3 theming Flutter"

Notes
- To adjust brand colors, edit `AppColors` in `lib/src/theme.dart` and rebuild.
- Extend component themes (cards, inputs, chips) inside `AppThemes`.
