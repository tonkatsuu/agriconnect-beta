# Quick Start Guide

## If Flutter is NOT Installed

1. **Install Flutter** (see `SETUP_GUIDE.md` for detailed instructions)
   - Download from: https://docs.flutter.dev/get-started/install/windows
   - Extract to `C:\src\flutter` (or similar)
   - Add `C:\src\flutter\bin` to your PATH
   - Restart PowerShell

2. **Verify Installation**
   ```powershell
   flutter --version
   flutter doctor
   ```

3. **Install Dependencies**
   ```powershell
   cd "C:\Users\fenfe\Documents\Taylors BCS Programme\Sem 4\HCI GA2 BetaVersion"
   flutter pub get
   ```

4. **Run the App**
   ```powershell
   flutter run
   ```

## If Flutter IS Installed (but not in PATH)

### Temporary Fix (Current Session Only)
```powershell
# Replace with your actual Flutter installation path
$env:PATH += ";C:\src\flutter\bin"
flutter --version
```

### Permanent Fix
1. Open "Environment Variables" (search in Windows Start)
2. Edit "Path" under User variables
3. Add your Flutter bin directory (e.g., `C:\src\flutter\bin`)
4. Restart PowerShell

## Testing Without Physical Device

### Option 1: Android Emulator
```powershell
# Start Android Studio
# Tools → Device Manager → Create Virtual Device
# Then run: flutter run
```

### Option 2: Windows Desktop (Limited - some features won't work)
```powershell
flutter run -d windows
# Note: Camera and some features require mobile device
```

## Project Structure

```
HCI GA2 BetaVersion/
├── lib/
│   ├── main.dart                    # App entry
│   ├── screens/                     # UI screens
│   ├── renderers/                   # Overlay renderers
│   └── services/                    # Alert service
├── android/                         # Android native code
├── pubspec.yaml                     # Dependencies
└── README.md                        # Full documentation
```

## Next Steps

1. Install Flutter (if not done)
2. Run `flutter pub get`
3. Connect Android device or start emulator
4. Run `flutter run`
5. Test AR Crop Guidance and Smart Alerts features



