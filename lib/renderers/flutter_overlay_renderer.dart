import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Flutter-based Overlay Renderer (Beta-friendly alternative)
/// 
/// This is a Flutter-native implementation that draws the overlay
/// using CustomPaint. It provides the same visual effect as OpenGL ES
/// but uses Flutter's rendering pipeline.
/// 
/// How it works:
/// 1. Uses CustomPaint widget to draw on top of camera preview
/// 2. Draws grid, markers, and bounding box using Canvas API
/// 3. Updates in real-time when spacing or visibility changes
/// 4. Can be replaced with OpenGL ES renderer for better performance
class FlutterOverlayRenderer extends CustomPainter {
  final double spacing; // Spacing in cm (converted to pixels)
  final bool visible;
  final Size screenSize;
  
  // Conversion: assume 1cm ≈ 3.77 pixels at typical phone viewing distance
  // This is a simplified conversion for demo purposes
  static const double cmToPixelRatio = 3.77;
  
  FlutterOverlayRenderer({
    required this.spacing,
    required this.visible,
    required this.screenSize,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (!visible) return;
    
    // Convert spacing from cm to pixels
    final spacingPx = spacing * cmToPixelRatio;
    
    // Draw semi-transparent grid
    _drawGrid(canvas, size, spacingPx);
    
    // Draw planting point markers (circles)
    _drawMarkers(canvas, size, spacingPx);
    
    // Draw highlighted bounding box (affected area)
    _drawBoundingBox(canvas, size);
  }
  
  /// Draws a semi-transparent grid for planting spacing guidance
  void _drawGrid(Canvas canvas, Size size, double spacingPx) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Vertical lines
    for (double x = spacingPx; x < size.width; x += spacingPx) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Horizontal lines
    for (double y = spacingPx; y < size.height; y += spacingPx) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }
  
  /// Draws 2-3 circular markers showing recommended planting points
  void _drawMarkers(Canvas canvas, Size size, double spacingPx) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    
    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final markerRadius = 15.0;
    
    // Calculate marker positions based on grid spacing
    // Place markers at grid intersections
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Marker 1: Center
    canvas.drawCircle(
      Offset(centerX, centerY),
      markerRadius,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(centerX, centerY),
      markerRadius,
      paint,
    );
    
    // Marker 2: Offset by spacing
    if (centerX + spacingPx < size.width && centerY + spacingPx < size.height) {
      canvas.drawCircle(
        Offset(centerX + spacingPx, centerY + spacingPx),
        markerRadius,
        fillPaint,
      );
      canvas.drawCircle(
        Offset(centerX + spacingPx, centerY + spacingPx),
        markerRadius,
        paint,
      );
    }
    
    // Marker 3: Another offset
    if (centerX - spacingPx > 0 && centerY - spacingPx > 0) {
      canvas.drawCircle(
        Offset(centerX - spacingPx, centerY - spacingPx),
        markerRadius,
        fillPaint,
      );
      canvas.drawCircle(
        Offset(centerX - spacingPx, centerY - spacingPx),
        markerRadius,
        paint,
      );
    }
  }
  
  /// Draws a highlighted bounding box representing an "affected area"
  void _drawBoundingBox(Canvas canvas, Size size) {
    // Define bounding box (e.g., 30% of screen in center)
    final boxWidth = size.width * 0.3;
    final boxHeight = size.height * 0.3;
    final boxLeft = (size.width - boxWidth) / 2;
    final boxTop = (size.height - boxHeight) / 2;
    
    final rect = Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight);
    
    // Fill with semi-transparent color
    final fillPaint = Paint()
      ..color = Colors.red.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(rect, fillPaint);
    
    // Border
    final borderPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawRect(rect, borderPaint);
    
    // Corner markers for better visibility
    final cornerSize = 20.0;
    final cornerPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    
    // Top-left corner
    canvas.drawLine(
      Offset(boxLeft, boxTop),
      Offset(boxLeft + cornerSize, boxTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft, boxTop),
      Offset(boxLeft, boxTop + cornerSize),
      cornerPaint,
    );
    
    // Top-right corner
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop),
      Offset(boxLeft + boxWidth - cornerSize, boxTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop),
      Offset(boxLeft + boxWidth, boxTop + cornerSize),
      cornerPaint,
    );
    
    // Bottom-left corner
    canvas.drawLine(
      Offset(boxLeft, boxTop + boxHeight),
      Offset(boxLeft + cornerSize, boxTop + boxHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft, boxTop + boxHeight),
      Offset(boxLeft, boxTop + boxHeight - cornerSize),
      cornerPaint,
    );
    
    // Bottom-right corner
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop + boxHeight),
      Offset(boxLeft + boxWidth - cornerSize, boxTop + boxHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop + boxHeight),
      Offset(boxLeft + boxWidth, boxTop + boxHeight - cornerSize),
      cornerPaint,
    );
  }
  
  @override
  bool shouldRepaint(FlutterOverlayRenderer oldDelegate) {
    return oldDelegate.spacing != spacing ||
        oldDelegate.visible != visible ||
        oldDelegate.screenSize != screenSize;
  }
}



