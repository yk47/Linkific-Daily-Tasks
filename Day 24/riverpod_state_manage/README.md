# Movie Explorer - Flutter App

A Flutter movie discovery app with Firebase Authentication and GetX state management.

## Features

- **Authentication**: Firebase Email/Password & Google OAuth sign-in
- **Movie Search**: Search movies via WatchMode API
- **Favorites**: Save favorite movies (persisted locally)
- **Watchlist**: Build a watchlist (persisted locally)
- **Dark Theme**: Cinematic dark UI with custom branding

## State Management: Riverpod → GetX Migration

The project was migrated from **Riverpod** to **GetX** for state management.

### Migration Benefits

- **Simpler syntax**: No need for ConsumerWidget/ConsumerState
- **Built-in routing**: Get.toNamed() / Get.back() / Get.offAllNamed()
- **Reactive state**: `.obs` variables with automatic UI updates
- **Dependency injection**: Get.put() / Get.find() / Get.lazyPut()
- **Smaller app size**: GetX is ~100KB vs Riverpod's larger footprint
- **Better performance**: Lower method count, faster compilation

## Project Architecture

```
lib/
├── main.dart                    # App entry point with Firebase init
├── core/
│   └── theme/
│       └── app_theme.dart       # Custom dark/light themes
├── controllers/
│   ├── movie_controller.dart    # Movie search & details
│   ├── favorite_controller.dart # Favorites with persistence
│   ├── watchlist_controller.dart# Watchlist with persistence
│   └── theme_controller.dart    # Theme toggle
├── models/
│   └── movie_model.dart         # Movie data model
├── routes/
│   └── app_routes.dart          # GetX route definitions
├── screens/
│   ├── login_screen.dart        # Email/password + Google login
│   ├── signup_screen.dart       # Registration screen
│   ├── home_screen.dart         # Main tab navigation
│   ├── search_screen.dart       # Movie search
│   ├── favorite_screen.dart     # Favorites list
│   ├── watchlist_screen.dart    # Watchlist list
│   ├── details_screen.dart      # Movie details
│   └── settings_screen.dart     # Settings & sign out
├── services/
│   ├── auth_service.dart        # Firebase Auth service
│   └── movie_service.dart       # WatchMode API service
└── widgets/
    ├── movie_card.dart          # Movie card widget
    ├── search_bar.dart          # Custom search bar
    └── empty_state.dart         # Empty state placeholder
```

## Performance Optimizations

### Code Organization
- **Feature-based folder structure**: Controllers, screens, services separated
- **Separate concerns**: Each class has a single responsibility
- **Reusable widgets**: MovieCard, EmptyState, SearchBar shared across screens
- **Constants file**: AppColors centralized in app_theme.dart
- **Theme file**: Complete Material 3 theme with custom colors

### Best Practices Implemented
- **Null safety**: Full null-safe Dart code
- **Error handling**: Try-catch on all async operations
- **Loading states**: CircularProgressIndicator during loading
- **Proper disposal**: TextEditingController.dispose() in stateful widgets
- **Const constructors**: Wherever possible for performance
- **ListView.builder**: For long lists (lazy loading)
- **Accessibility**: Semantic labels in theme

### Security
- **Firebase Remote Config**: For secrets management
- **HTTPS only**: All API calls use HTTPS
- **Input validation**: Email format and password strength validation
- **SQL injection prevention**: Not applicable (Firestore/API-based)

### App Size Optimization
- **ProGuard/R8**: Enabled for release builds
- **Split APKs by ABI**: Reduces per-device download size
- **Tree-shaking**: Material icons reduced 99.8% (3944 bytes from 1.6MB)
- **Remove unused resources**: Only essential assets included

## Getting Started

### Prerequisites
- Flutter SDK 3.11+
- Firebase project with Authentication enabled
- WatchMode API key

### Setup

1. **Clone the repository**
```bash
git clone <repo-url>
cd riverpod_state_manage
```

2. **Configure Firebase**
- Place `google-services.json` in `android/app/`
- Enable Email/Password and Google sign-in in Firebase Console

3. **Install dependencies**
```bash
flutter pub get
```

4. **Run the app**
```bash
flutter run
```

### Building Release APK

```bash
flutter build apk --release --split-per-abi
```

This generates split APKs:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

Or build a universal APK:
```bash
flutter build apk --release
```

## Version

**v1.0.0** - Initial release with GetX migration and Firebase Auth