import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../icon_native/status_icons.dart';
import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import '../close_button/dga_close_button.dart';

/// Notification uses descriptive colour names
/// 'Neutral': light grey
/// 'Info': blue
/// 'Warning': yellow
/// 'Success': green
/// 'Error': red
enum DgaNotificationType { neutral, info, warning, success, error }

class DgaNotification extends StatefulWidget {
  const DgaNotification({
    super.key,
    this.leadText,
    this.helperText,
    this.type = DgaNotificationType.neutral,
    this.dismissable = true,
    this.icon,
    this.hasIcon = true,
    this.onDismissPressed,
    this.action,
  });

  final String? leadText;
  final String? helperText;
  final DgaNotificationType type;
  final bool dismissable;
  final Widget? icon;
  final bool hasIcon;
  final Widget? action;
  final VoidCallback? onDismissPressed;

  @override
  State<DgaNotification> createState() => _DgaNotificationState();
}

class _DgaNotificationState extends State<DgaNotification> {
  final iconSize = 24.0;

  /// (forground, background) per color.
  ({Color textColor, Color stroke, Color background, Widget icon})
  _colorTriplet(DgaSemanticColors c) {
    return switch (widget.type) {
      DgaNotificationType.neutral => (
        textColor: c.textPrimaryParagraph,
        stroke: c.backgroundBlack,
        background: c.backgroundNeutral50,
        icon: StatusIcon(
          type: StatusIconType.info,
          color: c.iconNeutral,
          size: iconSize,
        ),
      ),
      DgaNotificationType.info => (
        textColor: c.textInfo,
        stroke: c.backgroundInfo,
        background: c.backgroundInfo50,
        icon: StatusIcon(
          type: StatusIconType.info,
          color: c.iconInfo,
          size: iconSize,
        ),
      ),
      DgaNotificationType.warning => (
        textColor: c.textWarning,
        stroke: c.backgroundWarning,
        background: c.backgroundWarning50,
        icon: StatusIcon(
          type: StatusIconType.triangleWarning,
          color: c.iconWarning,
          size: iconSize,
        ),
      ),
      DgaNotificationType.success => (
        textColor: c.textSuccess,
        stroke: c.backgroundSuccess,
        background: c.backgroundSuccess50,
        icon: StatusIcon(
          type: StatusIconType.success,
          color: c.iconSuccess,
          size: iconSize,
        ),
      ),
      DgaNotificationType.error => (
        textColor: c.textError,
        stroke: c.backgroundError,
        background: c.backgroundError50,
        icon: StatusIcon(
          type: StatusIconType.danger,
          color: c.iconError,
          size: iconSize,
        ),
      ),
    };
  }

  bool isDissmissed = false;

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final t = _colorTriplet(colors);
    return Visibility(
      visible: !isDissmissed,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: DgaSpacing.xl,
              vertical: DgaSpacing.xl2,
            ),
            decoration: BoxDecoration(
              color: t.background,
              borderRadius: BorderRadius.circular(DgaRadius.xs),
            ),
            child: Row(
              children: [
                if (widget.hasIcon) widget.icon ?? t.icon,
                SizedBox(width: DgaSpacing.md),
                if (widget.leadText != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: DgaSpacing.md),
                    child: Text(
                      widget.leadText!,
                      style: DgaTypography.textMd.bold.copyWith(
                        color: t.textColor,
                      ),
                    ),
                  ),
                if (widget.helperText != null)
                  Expanded(
                    child: Text(
                      widget.helperText!,
                      style: DgaTypography.textMd.regular.copyWith(
                        color: t.textColor,
                      ),
                    ),
                  ),
                if (widget.action != null) widget.action!,
              ],
            ),
          ),
          if (widget.dismissable)
            PositionedDirectional(
              top: DgaSpacing.xl,
              end: DgaSpacing.xl,
              child: DgaCloseButton(
                onPressed: () {
                  setState(() {
                    isDissmissed = !isDissmissed;
                  });
                  widget.onDismissPressed?.call();
                },
              ),
            ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: Container(height: 2, color: t.stroke.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
