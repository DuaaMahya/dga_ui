import 'package:flutter/material.dart';

import '../../theme/dga_theme.dart';
import '../_internal/alert_content.dart';
import 'dga_alert_severity.dart';

/// A full-width banner that sits in the page flow.
///
/// Five severities × two surface treatments ([DgaInlineAlertBackground]).
/// The layout collapses to the Figma "Mobile" arrangement — icon and close on
/// their own row, buttons stacked full-width — below
/// [kAlertStackBreakpoint], or whenever [mobile] is set explicitly.
///
/// For a floating, self-dismissing variant see `DgaNotificationToast`.
class DgaInlineAlert extends StatefulWidget {
  const DgaInlineAlert({
    super.key,
    required this.title,
    this.description,
    this.severity = DgaAlertSeverity.neutral,
    this.background = DgaInlineAlertBackground.white,
    this.actions = const [],
    this.dismissible = true,
    this.onDismiss,
    this.mobile,
    this.icon,
    this.showIcon = true,
  });

  final String title;
  final String? description;
  final DgaAlertSeverity severity;

  /// White keeps a neutral title; `color` tints the surface and takes the
  /// severity hue for the title.
  final DgaInlineAlertBackground background;

  /// Trailing action buttons — the design shows up to two.
  final List<Widget> actions;

  final bool dismissible;

  /// Called when the × is tapped. Supply this to control visibility yourself;
  /// without it the alert simply hides itself.
  final VoidCallback? onDismiss;

  /// Forces the stacked ("Mobile") layout. Null follows the available width.
  final bool? mobile;

  /// Replaces the severity's default status glyph.
  final Widget? icon;
  final bool showIcon;

  @override
  State<DgaInlineAlert> createState() => _DgaInlineAlertState();
}

class _DgaInlineAlertState extends State<DgaInlineAlert> {
  bool _dismissed = false;

  void _handleDismiss() {
    // Uncontrolled by default; a supplied onDismiss takes over entirely so
    // the host can animate or persist the decision.
    if (widget.onDismiss != null) {
      widget.onDismiss!();
      return;
    }
    setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final c = DgaTheme.of(context).colors;
    final tinted = widget.background == DgaInlineAlertBackground.color;
    final palette = resolveAlertPalette(widget.severity, c, tinted: tinted);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            widget.mobile ??
            (constraints.maxWidth.isFinite &&
                constraints.maxWidth < kAlertStackBreakpoint);

        return Semantics(
          container: true,
          liveRegion: true,
          label: widget.description == null
              ? widget.title
              : '${widget.title}. ${widget.description}',
          child: AlertSurface(
            palette: palette,
            severity: widget.severity,
            title: widget.title,
            description: widget.description,
            actions: widget.actions,
            dismissible: widget.dismissible,
            onDismiss: _handleDismiss,
            showIcon: widget.showIcon,
            icon: widget.icon,
            stacked: stacked,
          ),
        );
      },
    );
  }
}
