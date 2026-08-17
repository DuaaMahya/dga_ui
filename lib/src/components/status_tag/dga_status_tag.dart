import 'package:flutter/widgets.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

/// Status Tag uses descriptive colour names
/// 'Neutral': light grey
/// 'Info': blue
/// 'Warning': yellow
/// 'Success': green
/// 'Error': red
enum DgaStatusTagColor { neutral, info, warning, success, error }

/// Visual treatment for the tag.
///
/// - `subtle`: light background + colored text
/// - `ghost`: transparent background + colored text (no fill)
/// - `inverted`: solid coloured background + white text
enum DgaStatusTagStatus { subtle, ghost, inverted }

enum DgaStatusTagSize {
  xSmall,
  small,
  medium;

  double get height => switch (this) {
    DgaStatusTagSize.xSmall => 20,
    DgaStatusTagSize.small => 24,
    DgaStatusTagSize.medium => 32,
  };

  double get horizontalPadding => switch (this) {
    DgaStatusTagSize.xSmall => DgaSpacing.md, // 8
    DgaStatusTagSize.small => DgaSpacing.md,
    DgaStatusTagSize.medium => DgaSpacing.lg, // 12
  };
}

class DgaStatusTag extends StatelessWidget {
  const DgaStatusTag({
    super.key,
    required this.label,
    this.type = DgaStatusTagColor.neutral,
    this.status = DgaStatusTagStatus.subtle,
    this.size = DgaStatusTagSize.small,
    this.leadingIcon,
  });

  final String label;
  final DgaStatusTagColor type;
  final DgaStatusTagStatus status;
  final DgaStatusTagSize size;
  final Widget? leadingIcon;

  /// (subtleBg, invertedBg, solidText) triplet per colour.
  ({Color subtleBg, Color invertedBg, Color colorText}) _colorTriplet(
    DgaSemanticColors c,
  ) {
    return switch (type) {
      DgaStatusTagColor.neutral => (
        subtleBg: c.tagBackgroundNeutralLight,
        invertedBg: c.tagBackgroundNeutral,
        colorText: c.tagTextNeutral,
      ),
      DgaStatusTagColor.info => (
        subtleBg: c.tagBackgroundInfoLight,
        invertedBg: c.tagBackgroundInfo,
        colorText: c.tagTextInfo,
      ),
      DgaStatusTagColor.warning => (
        subtleBg: c.tagBackgroundWarningLight,
        invertedBg: c.tagBackgroundWarning,
        colorText: c.tagTextWarning,
      ),
      DgaStatusTagColor.success => (
        subtleBg: c.tagBackgroundSuccessLight,
        invertedBg: c.tagBackgroundSuccess,
        colorText: c.tagTextSuccess,
      ),
      DgaStatusTagColor.error => (
        subtleBg: c.tagBackgroundErrorLight,
        invertedBg: c.tagBackgroundError,
        colorText: c.tagTextError,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final t = _colorTriplet(colors);

    final Color background;
    final Color foreground;
    switch (status) {
      case DgaStatusTagStatus.subtle:
        background = t.subtleBg;
        foreground = t.colorText;
      case DgaStatusTagStatus.ghost:
        background = const Color(0x00000000);
        foreground = t.colorText;
      case DgaStatusTagStatus.inverted:
        background = t.invertedBg;
        foreground = colors.textOncolorPrimary;
    }

    final labelStyle =
        (size == DgaStatusTagSize.medium
                ? DgaTypography.textSm.medium
                : DgaTypography.textXs.medium)
            .copyWith(color: foreground);

    final iconSize = size == DgaStatusTagSize.medium ? 16.0 : 12.0;

    return Semantics(
      label: label,
      container: true,
      child: SizedBox(
        height: size.height,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.horizontalPadding),
          decoration: BoxDecoration(
            color: background,
            borderRadius: DgaRadius.brFull,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dot indicator when no leading icon supplied.
              if (leadingIcon == null)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsetsDirectional.only(end: DgaSpacing.md),
                  decoration: BoxDecoration(
                    color: foreground,
                    shape: BoxShape.circle,
                  ),
                )
              else ...[
                IconTheme.merge(
                  data: IconThemeData(color: foreground, size: iconSize),
                  child: leadingIcon!,
                ),
                const SizedBox(width: DgaSpacing.xs),
              ],
              Text(label, style: labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}
