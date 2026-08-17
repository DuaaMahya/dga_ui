import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaHorizontalTabSize {
  small,
  medium,
  large;

  double get height => switch (this) {
    DgaHorizontalTabSize.small => 36,
    DgaHorizontalTabSize.medium => 44,
    DgaHorizontalTabSize.large => 52,
  };

  double get horizontalPadding => switch (this) {
    DgaHorizontalTabSize.small => DgaSpacing.lg, // 12
    DgaHorizontalTabSize.medium => DgaSpacing.xl, // 16
    DgaHorizontalTabSize.large => DgaSpacing.xl, // 16
  };

  TextStyle get textStyle => switch (this) {
    DgaHorizontalTabSize.small => DgaTypography.textSm.medium,
    DgaHorizontalTabSize.medium => DgaTypography.textMd.medium,
    DgaHorizontalTabSize.large => DgaTypography.textMd.medium,
  };
}

/// A single horizontal tab item. Selected shows a brand-colored bottom
/// indicator (pill) + bold text; unselected uses muted text. The app owns
/// selection and lays items out in a Row.
class DgaHorizontalTab extends StatefulWidget {
  const DgaHorizontalTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.size = DgaHorizontalTabSize.medium,
    this.leadingIcon,
    this.disabled = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final DgaHorizontalTabSize size;
  final Widget? leadingIcon;
  final bool disabled;

  @override
  State<DgaHorizontalTab> createState() => _DgaHorizontalTabState();
}

class _DgaHorizontalTabState extends State<DgaHorizontalTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final textColor = widget.disabled
        ? c.textDefaultDisabled
        : (widget.selected ? c.textDefault : c.unselectedTabIcon);
    final style =
        (widget.selected
                ? widget.size.textStyle.copyWith(fontWeight: FontWeight.w700)
                : widget.size.textStyle)
            .copyWith(color: textColor);

    return Semantics(
      selected: widget.selected,
      button: true,
      enabled: !widget.disabled,
      label: widget.label,
      child: MouseRegion(
        cursor: widget.disabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.disabled ? null : widget.onTap,
          child: Container(
            height: widget.size.height,
            padding: EdgeInsets.symmetric(
              horizontal: widget.size.horizontalPadding,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hovered && !widget.disabled && !widget.selected
                  ? c.backgroundNeutral100
                  : null,
              borderRadius: DgaRadius.brSm,
            ),
            child: Stack(
              children: [
                Container(height: double.infinity),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leadingIcon != null) ...[
                        IconTheme.merge(
                          data: IconThemeData(color: textColor, size: 20),
                          child: widget.leadingIcon!,
                        ),
                        const SizedBox(width: DgaSpacing.xs),
                      ],
                      Text(widget.label, style: style),
                    ],
                  ),
                ),
                // Selected indicator — brand-green segment on top of the track.
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: widget.selected ? 1 : 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: c.backgroundPrimary,
                        borderRadius: DgaRadius.brFull,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
