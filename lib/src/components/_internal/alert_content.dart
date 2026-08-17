import 'package:flutter/material.dart';

import '../../../icon_native/status_icons.dart';
import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_typography.dart';
import '../alert/dga_alert_severity.dart';
import '../close_button/dga_close_button.dart';

/// Metrics for inline alert and the toast.
const double kAlertAccentWidth = 8;
const double kAlertIconChip = 40;
const double kAlertIconGlyph = 24;
const double kAlertVPadding = DgaSpacing.xl; // notification-padding: 16
const double kAlertHPadding = DgaSpacing.xl3; // notification-h-padding: 24
const double kAlertGap = DgaSpacing.xl; // notification-gap: 16

/// Below this the layout switches to the Figma "Mobile" arrangement.
const double kAlertStackBreakpoint = 480;

/// The seven colours an alert surface needs, resolved from one severity.
typedef AlertPalette = ({
  Color surface,
  Color border,
  Color accent,
  Color iconGlyph,
  Color iconChip,
  Color title,
  Color description,
});

/// Maps a severity onto design tokens.
///
/// [tinted] selects Figma's `Background Color=Color` variant. Note the title
/// colour follows the *surface*: white surfaces use the neutral display
/// colour, tinted ones take the severity hue.
AlertPalette resolveAlertPalette(
  DgaAlertSeverity severity,
  DgaSemanticColors c, {
  required bool tinted,
}) {
  return switch (severity) {
    DgaAlertSeverity.neutral => (
      surface: tinted ? c.backgroundNeutral25 : c.backgroundNotificationWhite,
      border: c.borderNeutralPrimary,
      accent: c.backgroundNeutral200,
      iconGlyph: c.iconDefault,
      iconChip: c.backgroundNeutral50,
      // No "text-neutral" exists; neutral keeps the display colour either way.
      title: c.textDisplay,
      description: c.textPrimaryParagraph,
    ),
    DgaAlertSeverity.info => (
      surface: tinted ? c.backgroundInfo25 : c.backgroundNotificationWhite,
      border: tinted ? c.borderInfoLight : c.borderNeutralPrimary,
      accent: c.backgroundInfo,
      iconGlyph: c.iconInfo,
      iconChip: c.backgroundInfoLight,
      title: tinted ? c.textInfo : c.textDisplay,
      description: c.textPrimaryParagraph,
    ),
    DgaAlertSeverity.error => (
      surface: tinted ? c.backgroundError25 : c.backgroundNotificationWhite,
      border: tinted ? c.borderErrorLight : c.borderNeutralPrimary,
      accent: c.backgroundError,
      iconGlyph: c.iconError,
      iconChip: c.backgroundErrorLight,
      title: tinted ? c.textError : c.textDisplay,
      description: c.textPrimaryParagraph,
    ),
    DgaAlertSeverity.warning => (
      surface: tinted ? c.backgroundWarning25 : c.backgroundNotificationWhite,
      border: tinted ? c.borderWarningLight : c.borderNeutralPrimary,
      accent: c.backgroundWarning,
      iconGlyph: c.iconWarning,
      iconChip: c.backgroundWarningLight,
      title: tinted ? c.textWarning : c.textDisplay,
      description: c.textPrimaryParagraph,
    ),
    DgaAlertSeverity.success => (
      surface: tinted ? c.backgroundSuccess25 : c.backgroundNotificationWhite,
      border: tinted ? c.borderSuccessLight : c.borderNeutralPrimary,
      accent: c.backgroundSuccess,
      iconGlyph: c.iconSuccess,
      iconChip: c.backgroundSuccessLight,
      title: tinted ? c.textSuccess : c.textDisplay,
      description: c.textPrimaryParagraph,
    ),
  };
}

StatusIconType alertIconFor(DgaAlertSeverity severity) => switch (severity) {
  DgaAlertSeverity.neutral => StatusIconType.info,
  DgaAlertSeverity.info => StatusIconType.info,
  DgaAlertSeverity.error => StatusIconType.error,
  DgaAlertSeverity.warning => StatusIconType.triangleWarning,
  DgaAlertSeverity.success => StatusIconType.success,
};

/// The surface shared by the inline alert and the toast: rounded card, 1px
/// border, leading accent bar, and the icon/title/description/actions/close
/// content in either the wide or the stacked arrangement.
class AlertSurface extends StatelessWidget {
  const AlertSurface({
    super.key,
    required this.palette,
    required this.severity,
    required this.title,
    required this.description,
    required this.actions,
    required this.dismissible,
    required this.onDismiss,
    required this.showIcon,
    required this.icon,
    required this.stacked,
    this.elevated = false,
    this.showBorder = true,
  });

  final AlertPalette palette;
  final DgaAlertSeverity severity;
  final String title;
  final String? description;
  final List<Widget> actions;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final bool showIcon;
  final Widget? icon;
  final bool stacked;
  final bool elevated;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: DgaRadius.brMd,
        border: showBorder ? Border.all(color: palette.border) : null,
        // Figma's shadow-3xl.
        boxShadow: elevated ? DgaShadows.xl3 : null,
      ),
      // Clips the accent bar to the card's rounded corners.
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            // The accent bar sits on the leading edge when wide and across
            // the top when stacked, so the padding it displaces flips too.
            padding: stacked
                ? const EdgeInsetsDirectional.fromSTEB(
                    kAlertHPadding,
                    kAlertVPadding + kAlertAccentWidth,
                    kAlertHPadding,
                    kAlertVPadding,
                  )
                : const EdgeInsetsDirectional.fromSTEB(
                    kAlertHPadding + kAlertAccentWidth,
                    kAlertVPadding,
                    kAlertHPadding,
                    kAlertVPadding,
                  ),
            child: stacked ? _stacked(context) : _wide(context),
          ),
          if (stacked)
            // Full-width top bar — direction-agnostic, so a plain Positioned.
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: kAlertAccentWidth,
              child: ColoredBox(color: palette.accent),
            )
          else
            // Leading vertical strip. PositionedDirectional flips it under
            // RTL, and top/bottom stretching avoids an IntrinsicHeight.
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              width: kAlertAccentWidth,
              child: ColoredBox(color: palette.accent),
            ),
        ],
      ),
    );
  }

  Widget _wide(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showIcon) ...[_iconChip(), const SizedBox(width: kAlertGap)],
        Expanded(child: _textBlock()),
        if (dismissible) ...[const SizedBox(width: kAlertGap), _closeButton()],
      ],
    );
  }

  Widget _stacked(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon || dismissible) ...[
          Row(
            children: [
              if (showIcon) _iconChip(),
              const Spacer(),
              if (dismissible) _closeButton(),
            ],
          ),
          const SizedBox(height: DgaSpacing.md),
        ],
        _textBlock(),
      ],
    );
  }

  Widget _textBlock() {
    return Column(
      // Text is always start-aligned; only the actions change arrangement
      // between layouts.
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: DgaTypography.textMd.semibold.copyWith(color: palette.title),
        ),
        if (description != null) ...[
          // Figma `text-content-gap`.
          const SizedBox(height: DgaSpacing.md),
          Text(
            description!,
            style: DgaTypography.textSm.regular.copyWith(
              color: palette.description,
            ),
          ),
        ],
        if (actions.isNotEmpty) ...[
          const SizedBox(height: DgaSpacing.lg),
          if (stacked)
            // Stacked and centred. Deliberately NOT stretched — each button
            // keeps its own width, so a caller wanting a full-width one wraps
            // it in a SizedBox(width: double.infinity).
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(height: DgaSpacing.md),
                    actions[i],
                  ],
                ],
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: DgaSpacing.md),
                  actions[i],
                ],
              ],
            ),
        ],
      ],
    );
  }

  Widget _iconChip() {
    return Container(
      width: kAlertIconChip,
      height: kAlertIconChip,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.iconChip,
        shape: BoxShape.circle,
      ),
      child:
          icon ??
          StatusIcon(
            type: alertIconFor(severity),
            size: kAlertIconGlyph,
            color: palette.iconGlyph,
            // The glyph's cutouts show this through, so it has to be the
            // chip's own fill. Left at the default white, a white glyph
            // (neutral in dark mode) would render as a solid disc.
            backgroundColor: palette.iconChip,
          ),
    );
  }

  Widget _closeButton() => DgaCloseButton(
    size: DgaCloseButtonSize.small,
    onPressed: onDismiss ?? () {},
  );
}
