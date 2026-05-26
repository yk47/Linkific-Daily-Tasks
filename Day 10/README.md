# 📸 Flutter Image Handling & Assets

A Flutter application demonstrating complete **image handling and asset management**, built as **Day 10** of the **Linkific Daily Tasks** program.

This project covers local assets, network images, image caching, gallery/camera image picking, image transformations, and image preview workflows using production-ready Flutter packages.

---

## 🚀 Features

### ✅ Image Handling in Flutter
- Display local asset images using `Image.asset`
- Load network images using `Image.network`
- Display picked images using `Image.file`
- Support for different `BoxFit` properties

### ✅ Asset Management
- Configure image assets in `pubspec.yaml`
- Organize assets into folders
- Load local images from app bundle

### ✅ Image Picker
- Pick images from **Gallery**
- Capture images using **Camera**
- Permission handling for Android & iOS
- Preview selected images before upload

### ✅ Cached Network Images
- Network image caching
- Loading placeholders
- Error handling widgets
- Fade-in animations

### ✅ Image Transformations
- Resize images
- Crop images *(Bonus)*
- Apply grayscale filters *(Bonus)*
- Blur and brightness adjustments *(Bonus)*

### ✅ UI Features
- Profile picture upload flow
- Gallery grid view
- Full-screen image viewer with zoom
- Reusable widgets architecture

---

## 📦 Packages Used

```yaml
dependencies:
  image_picker: ^1.2.0
  cached_network_image: ^3.4.1
  image: ^4.5.4
  path_provider: ^2.1.5
```

### Package Purpose

| Package | Purpose |
|----------|----------|
| `image_picker` | Pick images from gallery/camera |
| `cached_network_image` | Cache network images |
| `image` | Image processing & transformations |
| `path_provider` | Access device storage paths |

---

## 📂 Project Structure

```text
image_handling_and_assets/
├── assets/
│   ├── images/
│   │   ├── sample_landscape.jpg
│   │   ├── sample_portrait.jpg
│   │   └── logo.png
│   ├── icons/
│   │   └── app_icon.png
│   └── placeholders/
│       └── default_avatar.png
├── lib/
│   ├── app.dart
│   ├── main.dart
│   ├── models/
│   │   └── gallery_entry.dart
│   ├── screens/
│   │   ├── image_showcase_page.dart
│   │   └── image_viewer_page.dart
│   └── widgets/
│       ├── cached_network_image_card.dart
│       ├── gallery_grid.dart
│       ├── image_fit_controls.dart
│       ├── image_frame.dart
│       └── section_card.dart
├── android/
├── ios/
└── pubspec.yaml
```

---

## 🖼️ Image Types Used

### 1. Local Asset Images
```dart
Image.asset(
  'assets/images/sample_landscape.jpg',
  fit: BoxFit.cover,
)
```

### 2. Network Images
```dart
Image.network(
  'https://picsum.photos/400/300',
)
```

### 3. Picked Images
```dart
Image.file(
  File(image.path),
)
```

### 4. Cached Network Images
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) =>
      const CircularProgressIndicator(),
  errorWidget: (context, url, error) =>
      const Icon(Icons.error),
)
```

---

## 📁 Asset Configuration

Add assets inside `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
    - assets/placeholders/
```

---

## 📸 Image Picker Setup

### Android Permissions

Add to:

```xml
android/app/src/main/AndroidManifest.xml
```

```xml
<uses-permission android:name="android.permission.CAMERA"/>

<uses-permission
    android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32"/>

<uses-permission
    android:name="android.permission.READ_MEDIA_IMAGES"/>
```

### iOS Permissions

Add to:

```xml
ios/Runner/Info.plist
```

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to take photos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Gallery access is required to pick images.</string>
```

---

## 🎯 Learning Objectives Covered

- ✅ Handle images in Flutter  
- ✅ Load network images  
- ✅ Pick images from gallery  
- ✅ Capture images from camera  
- ✅ Cache network images  
- ✅ Configure Flutter assets  
- ✅ Use image handling packages  
- ✅ Apply image transformations  
- ✅ Build image preview flow  

---

## ▶️ Getting Started

### 1. Clone Repository

```bash
git clone https://github.com/yk47/Linkific-Daily-Tasks.git
```

### 2. Navigate to Project

```bash
cd "Day 10/image_handling_and_assets"
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run App

```bash
flutter run
```

---

## 📱 Deliverables

- ✅ Image handling Flutter app  
- ✅ Gallery image picker  
- ✅ Camera integration  
- ✅ Cached network images  
- ✅ Asset image display  
- ✅ Image upload flow  
- ✅ README documentation  

---

## 🛠️ Technologies Used

- Flutter
- Dart
- Material Design
- Image Processing
- Local Assets
- Network Image Caching

---

## 👨‍💻 Author

**Yash Karnik**

GitHub: https://github.com/yk47

---

## 📌 Repository

Repository Path:

```text
Linkific-Daily-Tasks / Day 10 / image_handling_and_assets
```

---

## ⭐ Day 10 — Linkific Daily Tasks

This project is part of the **Linkific Daily Tasks** Flutter learning series focused on mastering Flutter development through hands-on implementation.
