import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../renderers/flutter_overlay_renderer.dart';
import '../renderers/opengl_renderer.dart';

/// Crop Guidance Screen with AR Overlay
/// 
/// This screen demonstrates the AR Crop Guidance feature:
/// - Shows live camera preview
/// - Renders OpenGL ES overlay (or Flutter fallback) on top
/// - Provides UI controls for overlay visibility and spacing
/// 
/// How Flutter passes updated spacing values to the renderer:
/// 1. User moves the slider -> onSpacingChanged callback
/// 2. setState() updates the spacing value
/// 3. CustomPaint's shouldRepaint detects the change
/// 4. FlutterOverlayRenderer repaints with new spacing
/// 5. For OpenGL ES: updateSpacing() is called via platform channel
class CropGuidanceScreen extends StatefulWidget {
  const CropGuidanceScreen({super.key});

  @override
  State<CropGuidanceScreen> createState() => _CropGuidanceScreenState();
}

class _CropGuidanceScreenState extends State<CropGuidanceScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _overlayVisible = true;
  double _spacing = 30.0; // Spacing in cm
  OpenGLRenderer? _openglRenderer;
  bool _useOpenGL = false; // Toggle between OpenGL and Flutter renderer
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _openglRenderer = OpenGLRenderer();
  }
  
  /// Initialize the camera for preview
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          
          // Initialize OpenGL renderer if using OpenGL
          if (_useOpenGL && _cameraController != null) {
            final size = _cameraController!.value.size;
            // Note: In a real implementation, you'd get the texture ID from the camera
            // For now, we'll use the Flutter renderer as the default
          }
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera initialization failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    _openglRenderer?.dispose();
    super.dispose();
  }
  
  /// Handle spacing slider changes
  /// This updates the spacing value which triggers a repaint
  void _onSpacingChanged(double value) {
    setState(() {
      _spacing = value;
    });
    
    // Update OpenGL renderer if using OpenGL
    if (_useOpenGL) {
      _openglRenderer?.updateSpacing(value);
    }
  }
  
  /// Toggle overlay visibility
  void _toggleOverlay() {
    setState(() {
      _overlayVisible = !_overlayVisible;
    });
    
    // Update OpenGL renderer if using OpenGL
    if (_useOpenGL) {
      _openglRenderer?.setOverlayVisible(_overlayVisible);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Crop Guidance'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isInitialized && _cameraController != null
          ? Stack(
              children: [
                // Camera preview
                SizedBox.expand(
                  child: CameraPreview(_cameraController!),
                ),
                
                // Overlay renderer (Flutter-based for beta)
                CustomPaint(
                  painter: FlutterOverlayRenderer(
                    spacing: _spacing,
                    visible: _overlayVisible,
                    screenSize: MediaQuery.of(context).size,
                  ),
                  child: Container(),
                ),
                
                // Control panel
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildControlPanel(),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
  
  /// Build the control panel with toggle and slider
  Widget _buildControlPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Overlay toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overlay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _overlayVisible,
                onChanged: (value) => _toggleOverlay(),
                activeColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Spacing slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Spacing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_spacing.toStringAsFixed(1)} cm',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Slider(
                value: _spacing,
                min: 10.0,
                max: 100.0,
                divisions: 90,
                label: '${_spacing.toStringAsFixed(1)} cm',
                activeColor: Colors.green,
                onChanged: _onSpacingChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Info text
          Text(
            'Grid spacing: ${_spacing.toStringAsFixed(1)} cm\n'
            'Blue circles: Planting points\n'
            'Red box: Affected area',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



