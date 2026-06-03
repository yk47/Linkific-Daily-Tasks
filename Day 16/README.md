# 🔥 Firebase Auth — Flutter App

A fully functional cross-platform mobile authentication app built with **Flutter** and **Firebase**. Supports Email/Password and Google Sign-In with real-time auth state management and a polished dark-themed UI.

---

## 📱 Screenshots

| Login | Register | Home / Profile |
|-------|----------|----------------|
| Dark UI with gradient Sign In button | Step-indicator form with confirm password | Avatar, stats, profile info cards |

---

## ✨ Features

- 📧 **Email & Password** — Register and sign in with credentials
- 🔵 **Google Sign-In** — One-tap OAuth login via Google account
- 🔄 **Auth State Stream** — Auto-navigates based on Firebase `authStateChanges()`
- 👤 **User Profile Screen** — Displays name, email, avatar, UID, and auth provider
- 🎨 **Animated UI** — Fade + slide entry animations on every screen
- 🧩 **Reusable Widgets** — `CustomTextField` with focus animations, `GoogleSignInButton` with Canvas-painted logo
- 🌐 **Multi-platform Config** — Firebase configured for Android, iOS, Web, macOS, and Windows

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart ^3.11.5) |
| Auth Backend | Firebase Authentication |
| Firebase Core | firebase_core ^4.10.0 |
| Auth SDK | firebase_auth ^6.1.1 |
| Google OAuth | google_sign_in ^7.2.0 |
| Config Tool | FlutterFire CLI |
| Android Build | Gradle + google-services plugin |

---

## 📁 Project Structure

```
lib/
├── main.dart                  # Entry point — Firebase init
├── firebase_options.dart      # Auto-generated platform config (FlutterFire CLI)
├── models/
│   └── user_model.dart        # UserModel data class
├── services/
│   └── auth_service.dart      # All Firebase Auth API calls
├── screens/
│   ├── auth_wrapper.dart      # Stream-based route guard
│   ├── login_screen.dart      # Sign-in UI
│   ├── register_screen.dart   # Registration UI
│   └── home_screen.dart       # Authenticated user profile
└── widgets/
    ├── custom_textfield.dart   # Animated, focus-aware input field
    └── google_signin_button.dart # Custom-painted Google button
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.11.5`
- A Firebase account with a project created
- Android Studio or VS Code with the Flutter extension

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/firebase_auth_app.git
cd firebase_auth_app
```

### 2. Set Up Firebase

1. Go to [Firebase Console](https://console.firebase.google.com) and create a project.
2. Navigate to **Authentication → Sign-in method** and enable:
   - Email/Password
   - Google
3. Register an **Android app** with package name `com.example.firebase_auth`.
4. Download `google-services.json` and place it at:
   ```
   android/app/google-services.json
   ```
5. *(Optional)* Register an **iOS app** with bundle ID `com.example.firebaseAuth` and add `GoogleService-Info.plist` to the iOS runner.

### 3. Configure with FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_PROJECT_ID
```

This regenerates `lib/firebase_options.dart` for all platforms.

### 4. Install Dependencies & Run

```bash
flutter pub get
flutter run
```

---

## 🔑 Google Sign-In — Android Setup

Google Sign-In requires your debug keystore SHA-1 to be registered in the Firebase Console.

```bash
keytool -list -v -keystore ~/.android/debug.keystore \
        -alias androiddebugkey \
        -storepass android -keypass android
```

Copy the **SHA-1** value and add it under:
**Firebase Console → Project Settings → Your Android App → Add Fingerprint**

---

## 🏗️ Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires Xcode on macOS)
flutter build ios --release
```

---

## 🔐 Authentication Flow

```
App Launch
    │
    ▼
AuthWrapper (StreamBuilder)
    │
    ├── authStateChanges() → null   →  LoginScreen
    │       ├── Email/Password Login
    │       ├── Google Sign-In
    │       └── Navigate to Register
    │
    └── authStateChanges() → User   →  HomeScreen
            └── Sign Out → back to LoginScreen
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^4.10.0
  firebase_auth: ^6.1.1
  google_sign_in: ^7.2.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

---

## ⚠️ Known Limitations

- No form validation (empty fields pass through to Firebase)
- "Forgot Password" button is a placeholder (not yet implemented)
- Edit Profile, Notifications, Privacy & Security rows are UI stubs
- `UserModel` is defined but not yet wired into state management

---

## 🔮 Planned Improvements

- [ ] Form validation with `GlobalKey<FormState>`
- [ ] Password reset via `sendPasswordResetEmail()`
- [ ] Email verification after registration
- [ ] State management with Riverpod or Provider
- [ ] Unit and widget tests

---

## 📄 License

This project is for educational purposes. See [LICENSE](LICENSE) for details.

---

> Built with ❤️ using Flutter & Firebase
