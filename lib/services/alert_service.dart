import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

/// Risk levels for crop alerts
enum RiskLevel {
  low,
  medium,
  high,
}

/// Smart Alert Service
/// 
/// This service handles visual and audio alerts for crop risk notifications.
/// 
/// APIs used:
/// - flutter_local_notifications: For local push notifications
/// - flutter_tts: For Text-to-Speech audio cues
/// - audioplayers: For beep sound alternative
/// 
/// Why these APIs:
/// - flutter_local_notifications: Standard Flutter plugin for cross-platform notifications
/// - flutter_tts: Provides natural voice alerts, better for accessibility
/// - audioplayers: Lightweight alternative for simple beep sounds
class AlertService {
  static final AlertService _instance = AlertService._internal();
  factory AlertService() => _instance;
  AlertService._internal();
  
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isInitialized = false;
  
  /// Initialize the alert service
  /// Sets up notifications and TTS
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Initialize notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Initialize TTS
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    
    _isInitialized = true;
  }
  
  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap if needed
    print('Notification tapped: ${response.payload}');
  }
  
  /// Trigger a crop risk alert
  /// 
  /// This function:
  /// 1. Shows an in-app banner (visual cue)
  /// 2. Triggers a local push notification
  /// 3. Plays an audio cue (TTS or beep)
  /// 
  /// Parameters:
  /// - riskLevel: LOW, MEDIUM, or HIGH
  /// - message: The alert message to display
  /// - context: BuildContext for showing in-app banner
  /// - useTTS: If true, uses TTS; if false, uses beep sound
  Future<void> triggerCropRiskAlert({
    required RiskLevel riskLevel,
    required String message,
    required BuildContext context,
    bool useTTS = true,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    // 1. Show in-app banner
    _showInAppBanner(context, riskLevel, message);
    
    // 2. Trigger local notification
    await _showNotification(riskLevel, message);
    
    // 3. Play audio cue
    if (useTTS) {
      await _playTTS(message);
    } else {
      await _playBeep(riskLevel);
    }
  }
  
  /// Show in-app banner with color-coded risk level
  void _showInAppBanner(
    BuildContext context,
    RiskLevel riskLevel,
    String message,
  ) {
    final color = _getRiskColor(riskLevel);
    final title = _getRiskTitle(riskLevel);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _BannerContent(
          title: title,
          message: message,
          color: color,
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  /// Show local push notification
  Future<void> _showNotification(RiskLevel riskLevel, String message) async {
    final title = _getRiskTitle(riskLevel);
    final color = _getRiskColor(riskLevel);
    
    const androidDetails = AndroidNotificationDetails(
      'crop_alerts',
      'Crop Risk Alerts',
      channelDescription: 'Notifications for crop risk alerts',
      importance: Importance.high,
      priority: Priority.high,
      color: Colors.green,
      playSound: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    try {
      await _notifications.show(
        riskLevel.index,
        title,
        message,
        details,
      );
    } catch (e) {
      print('Failed to show notification: $e');
      // Gracefully handle missing permissions
    }
  }
  
  /// Play Text-to-Speech audio cue
  Future<void> _playTTS(String message) async {
    try {
      await _tts.speak(message);
    } catch (e) {
      print('TTS failed: $e');
      // Fallback to beep if TTS fails
      await _playBeep(RiskLevel.medium);
    }
  }
  
  /// Play beep sound based on risk level
  Future<void> _playBeep(RiskLevel riskLevel) async {
    try {
      // Different beep patterns for different risk levels
      // For demo, we'll use a simple approach
      // In production, you'd load actual sound files
      
      // Note: This is a placeholder - in a real app, you'd use actual sound files
      // For now, we'll just print a message
      print('Playing beep for ${riskLevel.name} risk');
      
      // Example: You could use audioplayers to play a beep file
      // await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    } catch (e) {
      print('Beep failed: $e');
    }
  }
  
  /// Get color based on risk level
  Color _getRiskColor(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.red;
    }
  }
  
  /// Get title based on risk level
  String _getRiskTitle(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Low Risk Alert';
      case RiskLevel.medium:
        return 'Medium Risk Alert';
      case RiskLevel.high:
        return 'High Risk Alert';
    }
  }
}

/// Custom banner content widget
class _BannerContent extends StatelessWidget {
  final String title;
  final String message;
  final Color color;
  
  const _BannerContent({
    required this.title,
    required this.message,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



