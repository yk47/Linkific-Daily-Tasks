# Permission Handling

This Flutter app demonstrates runtime permission handling with the `permission_handler` package.

## What it covers

The app shows status checks, single-permission requests, multi-permission requests, rationale dialogs, denial handling, and the open-settings flow for permanently denied permissions.

## Permissions in the app

- Camera
- Gallery / Photos
- Location when in use
- Microphone
- Contacts

## Setup

1. Install dependencies with `flutter pub get`.
2. On Android, keep the permission declarations in `android/app/src/main/AndroidManifest.xml`.
3. On iOS, keep the usage descriptions in `ios/Runner/Info.plist`.
4. On iOS, keep the `ios/Podfile` macros enabled for the permissions you request.

## iOS notes

The Podfile enables these macros for the example app:

- `PERMISSION_CAMERA=1`
- `PERMISSION_CONTACTS=1`
- `PERMISSION_MICROPHONE=1`
- `PERMISSION_PHOTOS=1`
- `PERMISSION_LOCATION_WHENINUSE=1`

## Android notes

The manifest includes camera, contacts, microphone, location, and media declarations. Gallery access uses media permissions on Android 13+.

## Running the app

Run the app as usual with `flutter run`. Use the cards on the home screen to check a permission, request it, or open system settings after a permanent denial.
