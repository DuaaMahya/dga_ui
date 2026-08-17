import 'package:flutter/material.dart';

/// Single Slider Track Shape
class CustomEqualTrackShape extends RoundedRectSliderTrackShape {
  const CustomEqualTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 0,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Canvas canvas = context.canvas;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;
    final Paint activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    // 1. Draw full background track
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, trackRadius),
      inactivePaint,
    );

    // 2. Overlay active track using exact same vertical bounds
    final bool isLeftToRight = textDirection == TextDirection.ltr;
    final double activeLeft = isLeftToRight ? trackRect.left : thumbCenter.dx;
    final double activeRight = isLeftToRight ? thumbCenter.dx : trackRect.right;

    final Rect activeRect = Rect.fromLTRB(
      activeLeft,
      trackRect.top,
      activeRight,
      trackRect.bottom,
    );

    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(trackRect, trackRadius));
    canvas.drawRect(activeRect, activePaint);
    canvas.restore();
  }
}

/// Range Slider Track Shape
class CustomEqualRangeTrackShape extends RoundedRectRangeSliderTrackShape {
  const CustomEqualRangeTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 0,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Canvas canvas = context.canvas;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;
    final Paint activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    // 1. Draw full background track
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, trackRadius),
      inactivePaint,
    );

    // 2. Overlay active portion between thumbs
    final Rect activeRect = Rect.fromLTRB(
      startThumbCenter.dx,
      trackRect.top,
      endThumbCenter.dx,
      trackRect.bottom,
    );

    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(trackRect, trackRadius));
    canvas.drawRect(activeRect, activePaint);
    canvas.restore();
  }
}
