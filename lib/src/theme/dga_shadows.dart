import 'package:flutter/painting.dart';

/// Shadow tokens from Foundations (`2:3`).
///
/// Only `xs` and `3xl` are exposed on the Colors page today; more are added
/// when a component references them.
abstract final class DgaShadows {
  const DgaShadows._();

  /// `Shadows/shadow-xs`: offset (0, 1), radius 2, spread 0, color `#1018280D`.
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0D101828), // new: not in the attached token files
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// `Shadows/shadow-sm`: subtle two-layer shadow used by switch thumbs.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D101828),
      offset: Offset(0, 1),
      blurRadius: 2,
    ), // new: not in the attached token files
    BoxShadow(
      color: Color(0x0D101828),
      offset: Offset(0, 1),
      blurRadius: 3,
    ), // new: not in the attached token files
  ];

  /// `Shadows/shadow-lg`: elevated two-layer shadow used by tooltips/popovers.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x08101828),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ), // new: not in the attached token files
    BoxShadow(
      color: Color(0x14101828),
      offset: Offset(0, 12),
      blurRadius: 16,
      spreadRadius: -4,
    ), // new: not in the attached token files
  ];

  /// `Shadows/shadow-md`: two-layer drop shadow used by focused inputs.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x0F101828), // new: not in the attached token files
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Color(0x1A101828), // new: not in the attached token files
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  /// `Shadows/shadow-2xl`: offset (0, 24), radius 48, spread -12, color
  /// `#1018282E`. Used by the calendar popover.
  static const List<BoxShadow> xl2 = [
    BoxShadow(
      color: Color(0x2E101828), // new: not in the attached token files
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
    ),
  ];

  /// `Shadows/shadow-3xl`: offset (0, 32), radius 64, spread -12, color `#10182824`.
  static const List<BoxShadow> xl3 = [
    BoxShadow(
      color: Color(0x24101828), // new: not in the attached token files
      offset: Offset(0, 32),
      blurRadius: 64,
      spreadRadius: -12,
    ),
  ];
}
