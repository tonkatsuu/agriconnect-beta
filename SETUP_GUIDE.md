# Flutter Setup Guide for Windows

## Quick Installation Steps

### Option 1: Using Flutter SDK (Recommended)

1. **Download Flutter SDK**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download the latest stable Flutter SDK ZIP file
   - Extract to a location like `C:\src\flutter` (avoid spaces in path)

2. **Add Flutter to PATH**
   - Open "Environment Variables" (search in Windows Start menu)
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\src\flutter\bin` (or your Flutter installation path)
   - Click "OK" on all dialogs
   - **Restart your terminal/PowerShell** for changes to take effect

3. **Verify Installation**
   ```powershell
   flutter --version
   flutter doctor
   ```

### Option 2: Using Git (Alternative)

```powershell
# Navigate to where you want Flutter installed
cd C:\src

# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (same as Option 1, step 2)
```

### Option 3: Using Chocolatey (Package Manager)

```powershell
# Install Chocolatey if not already installed
# Then run:
choco install flutter
```

## Post-Installation Setup

### 1. Run Flutter Doctor
```powershell
flutter doctor
```

This will show what's missing. Common items to install:

### 2. Install Android Studio
- Download from: https://developer.android.com/studio
- Install Android Studio
- Open Android Studio → More Actions → SDK Manager
- Install Android SDK (API 21 or higher)
- Install Android SDK Platform-Tools
- Accept Android licenses: `flutter doctor --android-licenses`

### 3. Install Visual Studio (for Windows Desktop development - optional)
- Download Visual Studio 2022 Community
- Install "Desktop development with C++" workload

### 4. Install VS Code (Recommended IDE)
- Download from: https://code.visualstudio.com/
- Install Flutter extension from VS Code marketplace

## Verify Everything Works

```powershell
# Check Flutter installation
flutter doctor -v

# Create a test project
flutter create test_app
cd test_app
flutter run
```

## Common Issues

### Issue: "flutter is not recognized"
**Solution**: 
- Make sure Flutter is added to PATH
- Restart terminal/PowerShell
- Verify: `$env:PATH` should contain your Flutter bin directory

### Issue: Android licenses not accepted
**Solution**:
```powershell
flutter doctor --android-licenses
# Press 'y' to accept all licenses
```

### Issue: No devices found
**Solution**:
- For Android: Enable USB debugging on your phone, or start an Android emulator
- For testing: You can use `flutter run -d windows` to test on Windows desktop

## Quick Start for This Project

Once Flutter is installed:

```powershell
# Navigate to project directory
cd "C:\Users\fenfe\Documents\Taylors BCS Programme\Sem 4\HCI GA2 BetaVersion"

# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Or list available devices
flutter devices
```

## Minimum Requirements

- **Windows 10 or later**
- **Disk Space**: ~2.8 GB (Flutter SDK + Android tools)
- **RAM**: 4 GB minimum, 8 GB recommended
- **Git**: For version control (usually comes with Flutter)

## Need Help?

- Flutter Documentation: https://docs.flutter.dev/
- Flutter Community: https://flutter.dev/community
- Stack Overflow: Tag questions with `flutter`
