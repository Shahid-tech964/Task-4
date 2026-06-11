# Little Explorer

A Flutter mobile app for children aged 3–5 that encourages kids to explore their surroundings by finding 5 electrical devices using the phone camera and Google ML Kit Image Labeling.

## Target Devices

- Television
- Laptop
- Fan
- Air Conditioner (AC)
- Refrigerator

## Features

- Mission home screen with progress tracking (0/5 to 5/5)
- Text-to-speech mission instructions via speaker button
- Camera capture with ML Kit object label detection
- Success, failure, and treasure reward screens
- Confetti animation on success
- Progress persists while the app remains open (Provider state management)
- Child-friendly Material 3 UI with bright colors and large buttons

## Requirements

- Flutter SDK (stable channel, 3.x+)
- Android device or emulator with camera (API 21+)
- Android Studio or VS Code with Flutter extensions

## Setup Instructions

### 1. Install Flutter

Ensure Flutter is installed and on your PATH:

```bash
flutter doctor
```

Fix any issues reported for Android toolchain.

### 2. Navigate to the project

```bash
cd task_4
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Connect an Android device

Enable **Developer Options** and **USB Debugging** on your phone, then connect via USB.

Verify the device is detected:

```bash
flutter devices
```

### 5. Run the app

```bash
flutter run
```

For release build on a connected device:

```bash
flutter run --release
```

## Permissions

The app requests **Camera** permission at runtime when you tap **Take Picture**. Grant permission when prompted.

## Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── camera_screen.dart
│   ├── success_screen.dart
│   ├── failure_screen.dart
│   └── reward_screen.dart
├── services/
│   ├── mlkit_service.dart
│   └── progress_provider.dart
├── models/
│   └── device_model.dart
└── widgets/
    ├── progress_card.dart
    └── device_illustration.dart
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `camera` | Device camera capture |
| `google_mlkit_image_labeling` | AI image label detection |
| `provider` | In-memory progress state |
| `flutter_tts` | Mission audio via speaker button |
| `confetti` | Success screen celebration |
| `permission_handler` | Camera permission handling |

## How It Works

1. Tap the **speaker** button to hear: *"Can you find 5 electrical devices around you?"*
2. Tap **Take Picture** to open the camera and capture a photo.
3. ML Kit analyzes the image and matches labels against predefined device keywords.
4. If a new device is found → **Success Screen** with confetti and +1 star.
5. If already found → snackbar message and return to home.
6. If no match → **Failure Screen** with Try Again.
7. After finding all 5 devices → unlock **Treasure Reward** with sticker and motivational quote.

## Notes

- No Firebase or backend is used.
- ML Kit detection accuracy depends on lighting, angle, and image quality.
- Progress resets when you tap **Play Again** on the reward screen or when the app process is killed.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Camera not working | Grant camera permission in Android Settings |
| Build fails on ML Kit | Ensure `minSdk` is 21+ in `android/app/build.gradle.kts` |
| No labels detected | Point camera clearly at the target device in good lighting |
| Gradle errors | Run `flutter clean && flutter pub get` then rebuild |
