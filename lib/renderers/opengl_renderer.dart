import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

/// OpenGL ES Renderer for AR Crop Guidance Overlay
/// 
/// This class handles the OpenGL ES rendering via platform channels.
/// For Android, it communicates with native OpenGL ES code.
/// 
/// How it works:
/// 1. Creates an OpenGL surface through platform channel
/// 2. Receives spacing and visibility parameters from Flutter
/// 3. Renders grid, markers, and bounding box in a rendering loop
/// 4. Updates are pushed from Flutter when slider/checkbox changes
class OpenGLRenderer {
  static const MethodChannel _channel = MethodChannel('opengl_renderer');
  
  bool _isInitialized = false;
  double _spacing = 30.0; // Default spacing in cm
  bool _overlayVisible = true;
  
  /// Initialize the OpenGL ES surface
  /// This creates the OpenGL context and sets up the rendering surface
  Future<void> initialize(int textureId, int width, int height) async {
    try {
      await _channel.invokeMethod('initialize', {
        'textureId': textureId,
        'width': width,
        'height': height,
      });
      _isInitialized = true;
      
      // Start the rendering loop
      _startRenderLoop();
    } catch (e) {
      print('Failed to initialize OpenGL: $e');
      // Fallback: continue without OpenGL (will use Flutter overlay)
    }
  }
  
  /// Update the grid spacing (in cm)
  /// This updates the uniform/parameter in the OpenGL shader
  Future<void> updateSpacing(double spacingCm) async {
    _spacing = spacingCm;
    if (_isInitialized) {
      try {
        await _channel.invokeMethod('updateSpacing', {
          'spacing': spacingCm,
        });
      } catch (e) {
        print('Failed to update spacing: $e');
      }
    }
  }
  
  /// Toggle overlay visibility
  Future<void> setOverlayVisible(bool visible) async {
    _overlayVisible = visible;
    if (_isInitialized) {
      try {
        await _channel.invokeMethod('setOverlayVisible', {
          'visible': visible,
        });
      } catch (e) {
        print('Failed to set overlay visibility: $e');
      }
    }
  }
  
  /// Start the rendering loop
  /// This continuously renders the overlay at 60fps
  void _startRenderLoop() {
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_isInitialized && _overlayVisible) {
        _channel.invokeMethod('render');
      }
    });
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    if (_isInitialized) {
      try {
        await _channel.invokeMethod('dispose');
        _isInitialized = false;
      } catch (e) {
        print('Failed to dispose OpenGL: $e');
      }
    }
  }
  
  double get spacing => _spacing;
  bool get overlayVisible => _overlayVisible;
}



