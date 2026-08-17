import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaVerticalTabSize {
  small,
  medium,
  large;

  double get height => switch (this) {
    DgaVerticalTabSize.small => 24,
    DgaVerticalTabSize.medium => 32,
    DgaVerticalTabSize.large => 40,
  };

  TextStyle get textStyle => switch (this) {
    DgaVerticalTabSize.small => DgaTypography.textSm.medium,
    DgaVerticalTabSize.medium => DgaTypography.textMd.medium,
    DgaVerticalTabSize.large => DgaTypography.textMd.medium,
  };
}

/// A single vertical tab item. Selected shows a brand-colored indicator on
/// the start edge (flips under RTL) + bold text. The app owns selection and
/// stacks items in a Column.
class DgaVerticalTab extends StatefulWidget {
  const DgaVerticalTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.size = DgaVerticalTabSize.medium,
    this.leadingIcon,
    this.disabled = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final DgaVerticalTabSize size;
  final Widget? leadingIcon;
  final bool disabled;

  @override
  State<DgaVerticalTab> createState() => _DgaVerticalTabState();
}

class _DgaVerticalTabState extends State<DgaVerticalTab> {
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
          child: SizedBox(
            height: widget.size.height,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start-edge indicator — only when selected.
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 3,
                  decoration: BoxDecoration(
                    color: widget.selected
                        ? c.backgroundPrimary
                        : const Color(0x00000000),
                    borderRadius: DgaRadius.brFull,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DgaSpacing.lg,
                    ),
                    alignment: AlignmentDirectional.centerStart,
                    decoration: BoxDecoration(
                      color: _hovered && !widget.disabled && !widget.selected
                          ? c.backgroundNeutral100
                          : null,
                      borderRadius: DgaRadius.brSm,
                    ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
