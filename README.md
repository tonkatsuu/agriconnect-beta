# AgriConnect Beta - AR Crop Guidance & Smart Alerts

A Flutter prototype application demonstrating two key features for agricultural crop management:

1. **AR Crop Guidance Overlay** - Visual overlay using OpenGL ES on camera preview
2. **Smart Alerts** - Visual and audio alerts for crop risk notifications

## Features

### Function 1: AR Crop Guidance Overlay

- **Visual Overlay**: Real-time overlay guides (grid, markers, bounding box) on camera preview
- **OpenGL ES 2.0**: Uses OpenGL ES for rendering (with Flutter fallback)
- **Interactive Controls**:
  - Toggle overlay ON/OFF
  - Slider for spacing (cm) that updates grid in real-time
- **Beta-Friendly**: 2D overlay aligned to screen (no AR tracking required)

### Function 2: Smart Alert System

- **Visual Alerts**: In-app banner with color-coded risk levels (LOW/MED/HIGH)
- **Push Notifications**: Local notifications using `flutter_local_notifications`
- **Audio Cues**: Text-to-Speech (TTS) or beep sounds
- **Demo Screen**: Interactive interface to test alerts

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── screens/
│   ├── home_screen.dart         # Main navigation screen
│   ├── crop_guidance_screen.dart # AR Crop Guidance feature
│   └── alert_demo_screen.dart   # Smart Alerts demo
├── renderers/
│   ├── opengl_renderer.dart     # OpenGL ES renderer (platform channel)
│   └── flutter_overlay_renderer.dart # Flutter fallback renderer
└── services/
    └── alert_service.dart       # Alert service with notifications & TTS
```

## Dependencies

- `camera: ^0.10.5+9` - Camera preview
- `flutter_local_notifications: ^16.3.0` - Local push notifications
- `flutter_tts: ^4.0.2` - Text-to-Speech
- `audioplayers: ^5.2.1` - Audio playback
- `permission_handler: ^11.3.0` - Permission management

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator (API 21+)
- iOS device or simulator (optional)

### Installation Steps

1. **Clone or navigate to the project directory**
   ```bash
   cd "HCI GA2 BetaVersion"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Android Setup

1. **Permissions**: The app automatically requests camera and notification permissions on startup.

2. **OpenGL ES Integration** (Optional):
   - The app includes a Flutter-based overlay renderer that works out of the box
   - For full OpenGL ES integration, you'll need to implement the native Android code in:
     - `android/app/src/main/kotlin/.../MainActivity.kt`
     - Create a method channel handler for OpenGL rendering
   - See `lib/renderers/opengl_renderer.dart` for the Flutter-side interface

### iOS Setup (Optional)

1. **Permissions**: Add to `ios/Runner/Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera access for AR crop guidance</string>
   ```

2. **Notifications**: iOS notifications are handled automatically by the plugin.

## How It Works

### AR Crop Guidance Overlay

**Rendering Pipeline:**
1. Camera preview is displayed using `CameraController`
2. Overlay is rendered using `CustomPaint` (Flutter) or OpenGL ES (native)
3. Grid spacing is calculated from slider value (cm → pixels)
4. Markers and bounding box are drawn at fixed positions
5. Real-time updates: `setState()` triggers `shouldRepaint()` → new frame

**How Flutter passes spacing to renderer:**
- User moves slider → `onSpacingChanged()` callback
- `setState()` updates `_spacing` value
- `FlutterOverlayRenderer.shouldRepaint()` detects change
- `paint()` method is called with new spacing
- For OpenGL: `updateSpacing()` called via platform channel

### Smart Alerts

**Alert Flow:**
1. User triggers alert via `triggerCropRiskAlert()`
2. **Visual**: In-app banner shown using `SnackBar` with custom content
3. **Notification**: Local push notification sent via `flutter_local_notifications`
4. **Audio**: TTS speaks message OR beep sound plays

**APIs Used:**
- `flutter_local_notifications`: Cross-platform notification API
- `flutter_tts`: Text-to-Speech for natural voice alerts
- `audioplayers`: Alternative for simple beep sounds

## Usage

### AR Crop Guidance

1. Navigate to "AR Crop Guidance" from home screen
2. Camera preview will start automatically
3. Toggle overlay ON/OFF using the switch
4. Adjust spacing using the slider (10-100 cm)
5. Observe:
   - Green grid lines (spacing guide)
   - Blue circles (planting point markers)
   - Red bounding box (affected area)

### Smart Alerts

1. Navigate to "Smart Alerts" from home screen
2. Select risk level (LOW/MEDIUM/HIGH)
3. Enter alert message
4. Choose audio type (TTS or Beep)
5. Tap "Trigger Alert"
6. Observe:
   - In-app banner appears
   - Notification appears in system tray
   - Audio cue plays

## Code Comments

The code includes extensive comments explaining:
- How OpenGL surface is created (in `opengl_renderer.dart`)
- How rendering loop works (in `flutter_overlay_renderer.dart`)
- How Flutter passes updated spacing values (in `crop_guidance_screen.dart`)
- What APIs are used and why (in `alert_service.dart`)

## Beta Limitations

- **AR Overlay**: Currently uses Flutter `CustomPaint` for rendering. Full OpenGL ES requires native Android implementation.
- **Audio Beep**: Placeholder implementation. Add actual sound files for production.
- **Permissions**: App requests permissions but may need manual grant on some devices.

## Troubleshooting

### Camera not working
- Check camera permissions in device settings
- Ensure device has a camera
- Try restarting the app

### Notifications not showing
- Check notification permissions in device settings
- For Android: Ensure notifications are enabled for the app
- For iOS: Check notification settings in iOS Settings

### TTS not working
- Check device language settings
- Ensure device has TTS engine installed
- Try switching to beep mode

## Future Enhancements

- Full OpenGL ES native implementation
- Real AR tracking (ARKit/ARCore integration)
- Custom sound files for beep alerts
- More sophisticated grid calculations
- Save/load alert configurations

## License

This is a beta prototype for educational/demonstration purposes.



