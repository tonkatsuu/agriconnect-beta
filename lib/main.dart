import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_screen.dart';
import 'screens/test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request necessary permissions on startup (non-blocking)
  _requestPermissions();
  
  runApp(const AgriConnectApp());
}

Future<void> _requestPermissions() async {
  try {
    // Request camera permission for AR overlay
    await Permission.camera.request();
    
    // Request notification permission
    await Permission.notification.request();
  } catch (e) {
    // Permissions may not be available on all platforms
    print('Permission request failed: $e');
  }
}

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect Beta',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

