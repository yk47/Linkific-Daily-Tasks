# Image Handling And Assets (Flutter)

This project demonstrates end-to-end image workflows in Flutter:

- Local asset images with `Image.asset`
- Network images with caching using `cached_network_image`
- Gallery + camera image picking using `image_picker`
- Picked image preview using `Image.file`
- BoxFit behavior experiments
- Basic image transformation (resize + grayscale filter)
- Profile image preview-before-upload flow
- Gallery grid with tap-to-zoom image viewer

## Learning Objectives

- Handle images in Flutter
- Load network images
- Pick images from gallery
- Display and cache images
- Use image packages

## YouTube Search Terms

- `Flutter image tutorial`
- `Image picker Flutter`
- `Cached network image Flutter`
- `Flutter camera plugin`
- `Display images Flutter`

## Recommended Channels

- The Flutter Way
- Flutter Mapp
- Marcus Ng

## Suggested Study Plan (2-3 hours)

1. Watch one complete intro to Flutter image widgets.
2. Watch one dedicated `image_picker` tutorial.
3. Watch one `cached_network_image` tutorial.
4. Rebuild one section in this app from scratch without copying.

## Packages Used

- `image_picker`: pick from gallery and capture from camera.
- `cached_network_image`: cache network images with loading and error states.
- `image`: apply grayscale transformation and encode output image.
- `path_provider`: write transformed images to temporary storage.

## Setup

1. Get packages:

```bash
flutter pub get
```

2. Run the app:

```bash
flutter run
```

## Assets Setup

Asset folder used in this project:

- `assets/images/sample_asset.png`

`pubspec.yaml` includes:

```yaml
flutter:
	uses-material-design: true
	assets:
		- assets/images/
```

## Platform Permissions

### Android

- `android/app/src/main/AndroidManifest.xml` includes camera permission:
	- `android.permission.CAMERA`

### iOS

- `ios/Runner/Info.plist` includes:
	- `NSCameraUsageDescription`
	- `NSPhotoLibraryUsageDescription`
	- `NSPhotoLibraryAddUsageDescription`

## Implemented Features Checklist

- [x] Display local image with `Image.asset`
- [x] Display remote image with `CachedNetworkImage`
- [x] Placeholder while loading
- [x] Error widget on failed load
- [x] Fade-in animation for network image
- [x] Pick image from gallery
- [x] Take image from camera
- [x] Display picked image with `Image.file`
- [x] BoxFit demo (`ChoiceChip` controls)
- [x] Resize preview (`Slider` width control)
- [x] Apply grayscale filter (bonus)
- [ ] Crop image (bonus, not yet implemented)
- [x] Profile picture selection
- [x] Preview-before-upload flow
- [x] Gallery grid
- [x] Zoom image viewer (`InteractiveViewer`)

## Project Structure (Relevant Files)

- `lib/main.dart`: full image demo app.
- `pubspec.yaml`: packages and asset registration.
- `android/app/src/main/AndroidManifest.xml`: Android camera permission.
- `ios/Runner/Info.plist`: iOS image/camera usage descriptions.

## Notes

- Crop support can be added next with `image_cropper` if you want native crop UI.
- Current upload is a simulated flow (preview + fake network delay), ideal for learning UI/state handling before connecting to backend storage.
