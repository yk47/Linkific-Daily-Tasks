# 🔐 Flutter Permission Handling App

A Flutter application that demonstrates **runtime permission handling** for both **Android and iOS** using the `permission_handler` package. This project showcases how to request, manage, and handle permissions such as **Camera, Photos/Gallery, Location, Microphone, and Contacts** with proper user experience and platform-specific configurations.

---

## 📌 Features

✅ Request permissions at runtime  
✅ Check permission status before access  
✅ Handle granted, denied, and permanently denied states  
✅ Open app settings for permanently denied permissions  
✅ Single and multiple permission requests  
✅ Permission rationale dialogs  
✅ Android & iOS permission configurations  
✅ Clean UI with permission status indicators  

---

## 📱 Permissions Implemented

| Permission | Purpose |
|------------|----------|
| 📷 Camera | Capture photos / scan documents |
| 🖼 Gallery / Photos | Pick images from gallery |
| 📍 Location | Access location-based services |
| 🎤 Microphone | Record audio / voice input |
| 👥 Contacts | Import or display contacts |

---

## 🛠 Tools & Tech

- **Flutter**
- **Dart**
- **permission_handler: ^12.0.1**
- **Material 3 UI**
- **Android Runtime Permissions**
- **iOS Runtime Permissions**

---

## 📂 Project Structure

```bash
lib/
├── main.dart
├── app.dart
├── routes/
│   ├── app_router.dart
│   └── app_routes.dart
├── screens/
│   └── permission_home_screen.dart
├── services/
│   └── permission_service.dart
├── models/
│   └── permission_spec.dart
├── utils/
│   └── permission_status_utils.dart
└── widgets/
    ├── permission_card.dart
    ├── status_chip.dart
    ├── section_header.dart
    └── setup_tile.dart
```

---

## 📦 Installation

### 1️⃣ Clone the Repository

```bash
git clone <your-repository-link>
cd permission_handling
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

---

## 🔧 Package Used

Add the following dependency in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^12.0.1
```

Then run:

```bash
flutter pub get
```

---

# ⚙️ Android Setup

Add permissions inside:

```xml
android/app/src/main/AndroidManifest.xml
```

Place the following permissions **above the `<application>` tag**:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

### Android Permissions Used

| Permission | Purpose |
|------------|----------|
| CAMERA | Camera access |
| ACCESS_FINE_LOCATION | Precise location |
| ACCESS_COARSE_LOCATION | Approximate location |
| READ_CONTACTS | Access contacts |
| RECORD_AUDIO | Microphone access |
| READ_MEDIA_IMAGES | Gallery access (Android 13+) |

---

# 🍎 iOS Setup

Add usage descriptions inside:

```xml
ios/Runner/Info.plist
```

Add the following keys:

```xml
<key>NSCameraUsageDescription</key>
<string>The app needs camera access to capture photos and scan documents.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>The app needs photo library access so users can pick an existing image.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>The app needs location access to show nearby or location-based content.</string>

<key>NSMicrophoneUsageDescription</key>
<string>The app needs microphone access to record audio and support voice features.</string>

<key>NSContactsUsageDescription</key>
<string>The app needs contacts access to import or display contact details.</string>
```

### iOS Podfile Configuration

Add permission macros inside the `Podfile`:

```ruby
post_install do |installer|
 installer.pods_project.targets.each do |target|
   flutter_additional_ios_build_settings(target)

   target.build_configurations.each do |config|
     config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
       '$(inherited)',
       'PERMISSION_CAMERA=1',
       'PERMISSION_PHOTOS=1',
       'PERMISSION_LOCATION=1',
       'PERMISSION_MICROPHONE=1',
       'PERMISSION_CONTACTS=1',
     ]
   end
 end
end
```

Then run:

```bash
cd ios
pod install
```

---

## 🚀 Permission Flow

### Single Permission Flow

1. Check permission status  
2. Show rationale dialog  
3. Request permission  
4. Handle result  

**Results Handling:**

- ✅ **Granted** → Proceed with functionality
- ❌ **Denied** → Show retry message
- ⚠️ **Permanently Denied** → Open App Settings
- 🔒 **Restricted** → Show information message
- 📌 **Limited** → Limited access granted (iOS)

---

### Multi Permission Flow

The app supports requesting multiple permissions at once:

- 📷 Camera Permission
- 📍 Location Permission

Flow:
1. Show shared rationale dialog  
2. Request permissions together  
3. Update permission statuses  
4. Handle granted/denied results  
5. Open settings if permanently denied  

---

## 📸 App Functionalities

- Request **Camera Permission**
- Request **Location Permission**
- Request **Gallery / Photos Permission**
- Request **Microphone Permission**
- Request **Contacts Permission**
- Check permission status
- Handle denied permissions gracefully
- Show permission rationale dialogs
- Open settings for permanently denied permissions
- Request multiple permissions together

---

## 🎯 Learning Objectives Covered

✔ Understand Android/iOS permissions  
✔ Request permissions at runtime  
✔ Handle permission results  
✔ Check permission status  
✔ Configure `AndroidManifest.xml`  
✔ Configure `Info.plist`  
✔ Implement rationale dialogs  
✔ Handle permanently denied permissions  
✔ Open settings for manual permission enablement  

---

## 🏗 Architecture

The application follows a **feature-first layered architecture**:

### Presentation Layer
- Screens
- Widgets
- UI Components

### Service Layer
- `PermissionService`
- Handles permission API interactions

### Domain / Utility Layer
- `PermissionSpec`
- Permission status extensions
- Utility helpers

---

## 📦 Output / Deliverables

✔ App with permission handling  
✔ All permissions configured  
✔ Request flows for camera, location, and storage/photos  
✔ Handle denied permissions  
✔ Open settings for permanently denied permissions  
✔ Permission rationale dialogs  
✔ Clean reusable architecture  
✔ README with permission setup guide  

---

## 🚀 Run the App

```bash
flutter pub get
flutter run
```

---

## 👨‍💻 Author

**Yash Karnik**

### 🌐 Connect With Me

- GitHub: **yk47**
- LinkedIn: **Yash Karnik**

---

## 📄 License

This project is created for **learning purposes** to understand Flutter runtime permission handling across Android and iOS platforms.
