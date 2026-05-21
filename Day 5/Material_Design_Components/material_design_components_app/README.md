Material Design Components Showcase

This small Flutter app demonstrates Material 3 widgets and patterns:

- Buttons: `ElevatedButton`, `TextButton`, `OutlinedButton`, `IconButton`, `FloatingActionButton`
- Cards & Lists: `Card`, `ListTile`, `Divider`
- Dialogs: `AlertDialog`, `SimpleDialog`, `showModalBottomSheet`, `SnackBar`
- Forms: `Form`, `TextFormField`, validation
- Navigation: named routes and `Navigator` usage

How to run

1. Ensure Flutter is installed and SDK is configured.
2. From the project root run:

```bash
flutter pub get
flutter run
```

Learning resources

- Official docs: https://docs.flutter.dev/ui/widgets/material
- YouTube search terms: "Flutter Material Design tutorial", "Flutter Material 3", "Flutter buttons and cards", "Flutter dialogs and snackbars", "Flutter forms tutorial"
- Recommended channels: Flutter Official, The Flutter Way, Marcus Ng

Files of interest

- `lib/main.dart` - app entry and route definitions
- `lib/screens/home_screen.dart` - dashboard
- `lib/screens/buttons_screen.dart` - buttons showcase
- `lib/screens/cards_screen.dart` - cards & lists
- `lib/screens/forms_screen.dart` - forms and validation
- `lib/screens/dialogs_screen.dart` - dialogs and snackbars
 
lib project structure

```text
lib/
	main.dart                # app entry and route definitions
	screens/                 # per-screen UI pages
		home_screen.dart
		buttons_screen.dart
		cards_screen.dart
		forms_screen.dart
		dialogs_screen.dart
	widgets/                 # small reusable widgets/components
		(e.g. custom button, card item)
	themes/                  # app theming and colors
		theme.dart
	models/                  # data models used across the app
		(e.g. user.dart, item.dart)
```
# material_design_components_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
