import 'package:flutter/widgets.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaTagStyle { neutral, success, error, warning, info, onColor }

enum DgaTagSize {
  xSmall,
  small,
  medium;

  double get height => switch (this) {
    DgaTagSize.xSmall => 20,
    DgaTagSize.small => 24,
    DgaTagSize.medium => 32,
  };

  double get horizontalPadding => switch (this) {
    DgaTagSize.xSmall => DgaSpacing.md, // 8
    DgaTagSize.small => DgaSpacing.md,
    DgaTagSize.medium => DgaSpacing.lg, // 12
  };
}

/// Static, non-interactive tag/label.
///
/// Interactive callers should reach for [DgaChip] instead.
class DgaTag extends StatelessWidget {
  const DgaTag({
    super.key,
    this.label,
    this.style = DgaTagStyle.neutral,
    this.size = DgaTagSize.small,
    this.outline = false,
    this.rounded = false,
    this.leadingIcon,
    this.tooltip,
  }) : assert(
         label != null || leadingIcon != null,
         'DgaTag needs a label or an icon',
       );

  final String? label;
  final DgaTagStyle style;
  final DgaTagSize size;
  final bool outline;
  final bool rounded;
  final Widget? leadingIcon;
  final String? tooltip;

  bool get _isIconOnly => label == null && leadingIcon != null;

  ({Color background, Color foreground, Color border}) _paint(
    DgaSemanticColors c,
  ) {
    return switch (style) {
      DgaTagStyle.neutral => (
        background: outline
            ? const Color(0x00000000)
            : c.tagBackgroundNeutralLight,
        foreground: c.tagTextNeutral,
        border: outline ? c.tagBorderNeutral : c.borderNeutralSecondary,
      ),
      DgaTagStyle.success => (
        background: outline
            ? const Color(0x00000000)
            : c.tagBackgroundSuccessLight,
        foreground: c.tagTextSuccess,
        border: outline ? c.tagBorderSuccess : c.tagBorderSuccessLight,
      ),
      DgaTagStyle.error => (
        background: outline
            ? const Color(0x00000000)
            : c.tagBackgroundErrorLight,
        foreground: c.tagTextError,
        border: outline ? c.tagBorderError : c.tagBorderErrorLight,
      ),
      DgaTagStyle.warning => (
        background: outline
            ? const Color(0x00000000)
            : c.tagBackgroundWarningLight,
        foreground: c.tagTextWarning,
        border: outline ? c.tagBorderWarning : c.tagBorderWarningLight,
      ),
      DgaTagStyle.info => (
        background: outline
            ? const Color(0x00000000)
            : c.tagBackgroundInfoLight,
        foreground: c.tagTextInfo,
        border: outline ? c.tagBorderInfo : c.tagBorderInfoLight,
      ),
      DgaTagStyle.onColor => (
        background: outline ? const Color(0x00000000) : c.tagBackgroundOnColor,
        foreground: c.textOncolorPrimary,
        border: c.tagBorderOnColor,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final p = _paint(colors);

    final labelStyle =
        (size == DgaTagSize.medium
                ? DgaTypography.textSm.medium
                : DgaTypography.textXs.medium)
            .copyWith(color: p.foreground);

    final iconSize = size == DgaTagSize.medium ? 16.0 : 12.0;

    return Semantics(
      label: tooltip ?? label,
      container: true,
      child: SizedBox(
        height: size.height,
        width: _isIconOnly ? size.height : null,
        child: Container(
          padding: _isIconOnly
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(horizontal: size.horizontalPadding),
          decoration: BoxDecoration(
            color: p.background,
            borderRadius: rounded ? DgaRadius.brFull : DgaRadius.brSm,
            border: Border.all(color: p.border, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null)
                IconTheme.merge(
                  data: IconThemeData(color: p.foreground, size: iconSize),
                  child: leadingIcon!,
                ),
              if (leadingIcon != null && label != null)
                const SizedBox(width: DgaSpacing.xs),
              if (label != null) Text(label!, style: labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}
