import 'package:flutter/painting.dart';

/// Severity shared by [DgaInlineAlert] and [DgaNotificationToast].
///
/// Figma names the error level "Destructive" on Inline Alert but
/// "Critical/Error" on Notification Toast. Since the design isn't
/// self-consistent, both components use one vocabulary here, matching the
/// existing `DgaStatusTagColor`.
enum DgaAlertSeverity { neutral, info, error, warning, success }

/// Surface treatment for [DgaInlineAlert] — Figma's `Background Color` axis.
///
/// The title colour follows the *surface*, not the component: on [white] it's
/// the neutral display colour, on [color] it takes the severity hue.
enum DgaInlineAlertBackground { white, color }

/// Where [DgaNotificationToast.show] anchors the toast.
enum DgaToastPlacement {
  topStart,
  topCenter,
  topEnd,
  bottomStart,
  bottomCenter,
  bottomEnd;

  bool get isTop => this == topStart || this == topCenter || this == topEnd;

  /// Cross-axis alignment within the overlay, resolved for text direction.
  AlignmentDirectional get alignment => switch (this) {
    topStart => AlignmentDirectional.topStart,
    topCenter => AlignmentDirectional.topCenter,
    topEnd => AlignmentDirectional.topEnd,
    bottomStart => AlignmentDirectional.bottomStart,
    bottomCenter => AlignmentDirectional.bottomCenter,
    bottomEnd => AlignmentDirectional.bottomEnd,
  };
}
