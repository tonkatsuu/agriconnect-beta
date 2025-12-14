# OpenGL ES Integration Guide

This document explains how to implement the native OpenGL ES renderer for the AR Crop Guidance overlay.

## Current Implementation

The app currently uses `FlutterOverlayRenderer` (Flutter CustomPaint) as a beta-friendly fallback. This works well for demonstration but can be replaced with native OpenGL ES for better performance.

## Architecture

### Flutter Side (`lib/renderers/opengl_renderer.dart`)

The `OpenGLRenderer` class communicates with native code via method channels:
- `initialize(textureId, width, height)` - Creates OpenGL surface
- `updateSpacing(spacing)` - Updates grid spacing parameter
- `setOverlayVisible(visible)` - Toggles overlay
- `render()` - Triggers render call
- `dispose()` - Cleans up resources

### Native Android Side (To Be Implemented)

#### 1. Create OpenGL Renderer Class

```kotlin
class CropOverlayRenderer : GLSurfaceView.Renderer {
    private var spacing = 30.0f
    private var visible = true
    
    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        // Initialize OpenGL state
        gl?.glClearColor(0.0f, 0.0f, 0.0f, 0.0f) // Transparent
        gl?.glEnable(GL10.GL_BLEND)
        gl?.glBlendFunc(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA)
    }
    
    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        gl?.glViewport(0, 0, width, height)
    }
    
    override fun onDrawFrame(gl: GL10?) {
        if (!visible) return
        
        gl?.glClear(GL10.GL_COLOR_BUFFER_BIT)
        
        // Draw grid
        drawGrid(gl, spacing)
        
        // Draw markers
        drawMarkers(gl)
        
        // Draw bounding box
        drawBoundingBox(gl)
    }
    
    fun setSpacing(spacing: Float) {
        this.spacing = spacing
    }
    
    fun setVisible(visible: Boolean) {
        this.visible = visible
    }
    
    private fun drawGrid(gl: GL10?, spacing: Float) {
        // Implementation for drawing grid lines
    }
    
    private fun drawMarkers(gl: GL10?) {
        // Implementation for drawing planting point markers
    }
    
    private fun drawBoundingBox(gl: GL10?) {
        // Implementation for drawing bounding box
    }
}
```

#### 2. Add Method Channel Handler in MainActivity

```kotlin
class MainActivity: FlutterActivity() {
    private var glSurfaceView: GLSurfaceView? = null
    private var renderer: CropOverlayRenderer? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "opengl_renderer")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    val textureId = call.argument<Int>("textureId")
                    val width = call.argument<Int>("width")
                    val height = call.argument<Int>("height")
                    initializeOpenGL(textureId, width, height)
                    result.success(null)
                }
                "updateSpacing" -> {
                    val spacing = call.argument<Double>("spacing")?.toFloat()
                    renderer?.setSpacing(spacing ?: 30.0f)
                    result.success(null)
                }
                "setOverlayVisible" -> {
                    val visible = call.argument<Boolean>("visible") ?: true
                    renderer?.setVisible(visible)
                    result.success(null)
                }
                "render" -> {
                    // Trigger render (usually automatic with GLSurfaceView)
                    result.success(null)
                }
                "dispose" -> {
                    disposeOpenGL()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
    
    private fun initializeOpenGL(textureId: Int?, width: Int?, height: Int?) {
        glSurfaceView = GLSurfaceView(this)
        glSurfaceView?.setEGLContextClientVersion(2) // OpenGL ES 2.0
        renderer = CropOverlayRenderer()
        glSurfaceView?.setRenderer(renderer)
        glSurfaceView?.renderMode = GLSurfaceView.RENDERMODE_CONTINUOUSLY
        
        // Add GLSurfaceView to view hierarchy
        // Note: This needs to be integrated with Flutter's view system
    }
    
    private fun disposeOpenGL() {
        glSurfaceView?.onPause()
        glSurfaceView = null
        renderer = null
    }
}
```

## Integration Challenges

1. **View Hierarchy**: OpenGL SurfaceView needs to be integrated with Flutter's view system. Consider using `PlatformView` or `Texture` widget.

2. **Rendering Loop**: GLSurfaceView handles the render loop automatically. The `render()` method in Flutter is mainly for triggering immediate updates.

3. **Coordinate System**: OpenGL uses normalized coordinates (-1 to 1), while Flutter uses pixel coordinates. Conversion is needed.

4. **Transparency**: Ensure OpenGL surface is transparent to show camera preview underneath.

## Alternative: Texture Widget Approach

Instead of GLSurfaceView, you can:
1. Create an OpenGL texture
2. Render to that texture
3. Pass texture ID to Flutter
4. Display using Flutter's `Texture` widget

This approach is more compatible with Flutter's rendering pipeline.

## Testing

1. Test on physical Android device (emulators may have OpenGL ES limitations)
2. Verify transparency works correctly
3. Test performance with different grid densities
4. Ensure overlay aligns with camera preview

## Resources

- [Android OpenGL ES Guide](https://developer.android.com/guide/topics/graphics/opengl)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Flutter Texture Widget](https://api.flutter.dev/flutter/widgets/Texture-class.html)



