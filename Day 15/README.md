# JWT Auth App

A Flutter application that demonstrates JWT-based authentication using the ReqRes API. The app includes login, registration, secure token storage, protected routes, auto-login functionality, and logout support.

## Features

- User Login
- User Registration
- JWT Token Authentication
- Secure Token Storage
- Auto Login on App Restart
- Protected Routes
- Logout Functionality
- API Integration using Dio
- Error Handling
- Material 3 UI

## Learning Objectives

- Understand JWT authentication
- Setup API integration
- Handle authentication flow
- Store tokens securely
- Manage authentication state
- Implement protected routes

## Tech Stack

- Flutter
- Dart
- Dio
- flutter_secure_storage
- ReqRes API
- Material 3
- ChangeNotifier
- InheritedNotifier

## Project Structure

```text
lib/
├── auth/
│   └── auth_repository.dart
├── screens/
│   └── auth_screens.dart
├── main.dart
```

## Installation

### Clone the Repository

```bash
git clone <repository-url>
cd jwt_auth_app
```

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.9.2
  flutter_secure_storage: ^10.3.1
```

## Authentication Flow

### Login

1. User enters email and password.
2. API request is sent to ReqRes API.
3. JWT token is received.
4. Token is securely stored.
5. User is redirected to Home Screen.

### Registration

1. User enters registration details.
2. API request is sent to ReqRes API.
3. JWT token is received.
4. User is automatically logged in.

### Auto Login

1. App checks for stored session on startup.
2. If a valid token exists, the user is redirected to Home Screen.
3. Otherwise, Login Screen is displayed.

### Logout

1. User taps Logout.
2. Session data is cleared.
3. Stored token is removed.
4. User is redirected to Login Screen.

## Security

- Secure token storage using `flutter_secure_storage`
- Android Keystore support
- iOS Keychain support
- Automatic Authorization header injection
- Session persistence across app restarts

## Screens

### Splash Screen
Checks authentication status during app startup.

### Login Screen
Allows users to sign in.

### Register Screen
Allows users to create an account.

### Home Screen
Protected screen accessible only to authenticated users.

## Deliverables

- Authentication System
- Login Screen
- Registration Screen
- JWT Token Storage
- Protected Routes
- Auto Login Functionality
- Logout Functionality
- API Integration
- Error Handling
- Documentation

## Future Enhancements

- Refresh Token Support
- Firebase Authentication
- Social Login (Google, Apple)
- User Profile Management
- BLoC/Riverpod State Management
- Unit Testing
- Widget Testing
- Certificate Pinning

## Author

**Yash Karnik**

Flutter Developer 
