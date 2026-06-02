# JWT Auth App

This app demonstrates a complete JWT authentication flow in Flutter using ReqRes, secure token storage, protected routes, and auto-login on restart.

## What It Includes

- Login and registration screens
- Token storage with `flutter_secure_storage`
- Dio-based API client with ReqRes `x-api-key` support
- Protected home screen and splash screen session check
- Auto-login after restart
- Logout and token clearing

## API

The app uses the ReqRes demo auth endpoints and sends the provided API key on every request:

- `POST /api/login`
- `POST /api/register`

ReqRes requires an `x-api-key` header. This project uses the key you provided:

- `reqres_7a94c5e129cc4c36bae212d5dda06e38`

## Demo Login

The login screen is prefilled with the ReqRes fixture credentials:

- Email: `eve.holt@reqres.in`
- Password: `cityslicka`

The registration screen also uses a ReqRes fixture email by default:

- Email: `eve.holt@reqres.in`
- Password: `pistol`

## Authentication Flow

1. `main.dart` boots the app and creates an `AuthController`.
2. The controller reads the saved token from secure storage.
3. If a token exists, the app restores the authenticated state immediately.
4. Login and registration store the returned ReqRes token securely.
5. Logout clears the stored session.

## Dependencies

The app uses:

- `dio` for API calls and request headers
- `flutter_secure_storage` for token persistence

## Running

Use the standard Flutter commands:

```bash
flutter pub get
flutter run
```

## Notes

- The protected home screen keeps the token visible in truncated form so you can confirm storage and session restoration during development.
- The register form includes first/last name fields for the UI, but ReqRes only receives email and password.
