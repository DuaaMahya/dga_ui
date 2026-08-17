import 'package:flutter/painting.dart';

/// Typography tokens from Foundations (`2:3`).
///
/// Font family is `IBM Plex Sans Arabic`. This package does NOT bundle the
/// font asset; host apps declare it in their own `pubspec.yaml` or use
/// `google_fonts`. See README.
abstract final class DgaTypography {
  const DgaTypography._();

  static const String fontFamily = 'IBM Plex Sans Arabic';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Display ramp (family: display, same as text in Foundations)
  static const DgaTextRamp displayXs = DgaTextRamp(size: 24, lineHeight: 32);
  static const DgaTextRamp displaySm = DgaTextRamp(size: 30, lineHeight: 38);
  static const DgaTextRamp displayXl = DgaTextRamp(
    size: 60,
    lineHeight: 72,
    letterSpacing: -2,
  );

  // Text ramp. Foundations misnames `text-lg` as `text-Ig` (capital I) —
  // normalized to `textLg` here and flagged upstream.
  static const DgaTextRamp textXs = DgaTextRamp(size: 12, lineHeight: 18);
  static const DgaTextRamp textSm = DgaTextRamp(size: 14, lineHeight: 20);
  static const DgaTextRamp textMd = DgaTextRamp(size: 16, lineHeight: 24);
  static const DgaTextRamp textLg = DgaTextRamp(size: 18, lineHeight: 28);
  static const DgaTextRamp textXl = DgaTextRamp(size: 20, lineHeight: 30);
}

class DgaTextRamp {
  const DgaTextRamp({
    required this.size,
    required this.lineHeight,
    this.letterSpacing = 0,
  });

  final double size;
  final double lineHeight;
  final double letterSpacing;

  TextStyle get regular => _style(DgaTypography.regular);
  TextStyle get medium => _style(DgaTypography.medium);
  TextStyle get semibold => _style(DgaTypography.semibold);
  TextStyle get bold => _style(DgaTypography.bold);

  TextStyle _style(FontWeight weight) => TextStyle(
    fontFamily: DgaTypography.fontFamily,
    fontSize: size,
    height: lineHeight / size,
    letterSpacing: letterSpacing,
    fontWeight: weight,
    package: null,
  );
}
