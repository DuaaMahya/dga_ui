import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Paints a circular progress ring: a full track plus a foreground arc that
/// sweeps `value` (0..1) clockwise from the top (12 o'clock).
class DgaRingPainter extends CustomPainter {
  const DgaRingPainter({
    required this.value,
    required this.trackColor,
    required this.fillColor,
    required this.strokeWidth,
  });

  final double value;
  final Color trackColor;
  final Color fillColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor;
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = fillColor;

    canvas.drawCircle(center, radius, track);

    final sweep = 2 * math.pi * value.clamp(0.0, 1.0);
    if (sweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // start at top
        sweep,
        false,
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(DgaRingPainter old) =>
      old.value != value ||
      old.trackColor != trackColor ||
      old.fillColor != fillColor ||
      old.strokeWidth != strokeWidth;
}
