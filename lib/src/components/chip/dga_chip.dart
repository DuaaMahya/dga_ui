import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaChipStyle { primary, neutral }

enum DgaChipSize {
  small,
  medium,
  large;

  double get height => switch (this) {
    DgaChipSize.small => DgaSpacing.xl2,
    DgaChipSize.medium => DgaSpacing.xl3,
    DgaChipSize.large => DgaSpacing.xl4,
  };

  double get horizontalPadding => switch (this) {
    DgaChipSize.small => DgaSpacing.md, // 8
    DgaChipSize.medium => DgaSpacing.md,
    DgaChipSize.large => DgaSpacing.lg, // 12
  };
}

/// Interactive pill/chip with selection semantics.
class DgaChip extends StatefulWidget {
  const DgaChip({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = DgaChipStyle.neutral,
    this.size = DgaChipSize.medium,
    this.rounded = false,
    this.selected = false,
    this.disabled = false,
    this.onColor = false,
    this.leadingIcon,
    this.trailingIcon,
    this.onDeleted,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final String label;
  final DgaChipStyle style;
  final DgaChipSize size;
  final bool rounded;
  final bool selected;
  final bool disabled;
  final bool onColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final VoidCallback? onDeleted;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;

  @override
  State<DgaChip> createState() => _DgaChipState();
}

class _DgaChipState extends State<DgaChip> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  ({Color background, Color foreground}) _paint(DgaSemanticColors c) {
    if (widget.disabled) {
      return (
        background: widget.onColor
            ? c.chipBackgroundOnColorDiabled
            : c.backgroundDisabled,
        foreground: widget.onColor
            ? c.textDefaultOncolorDisabled
            : c.textDefaultDisabled,
      );
    }

    if (widget.onColor) {
      final bg = switch ((_pressed, widget.selected, _hovered)) {
        (true, _, _) => c.chipBackgroundOnColorPressed,
        (_, true, _) => c.chipBackgroundOnColorSelected,
        (_, _, true) => c.chipBackgroundOnColorHovered,
        _ => c.chipBackgroundOnColorDefault,
      };
      return (background: bg, foreground: c.textDefault);
    }

    switch (widget.style) {
      case DgaChipStyle.primary:
        // The official export only defines a focus-state primary chip
        // token; the default/hover/pressed/selected progression reuses the
        // Background section's brand-green tint scale instead.
        final bg = switch ((_pressed, widget.selected, _hovered)) {
          (true, _, _) => c.backgroundPrimary400,
          (_, true, _) => c.backgroundPrimary,
          (_, _, true) => c.backgroundPrimary200,
          _ => c.backgroundPrimary50,
        };
        final fg = widget.selected ? c.textOncolorPrimary : c.textPrimary;
        return (background: bg, foreground: fg);
      case DgaChipStyle.neutral:
        // No dedicated "pressed" neutral-chip token in the export; reuse the
        // selected fill for pressed feedback.
        final bg = switch ((_pressed, widget.selected, _hovered)) {
          (true, _, _) => c.chipBackgroundNeutralSelected,
          (_, true, _) => c.chipBackgroundNeutralSelected,
          (_, _, true) => c.chipBackgroundNeutralHovered,
          _ => c.chipBackgroundNeutralDefault,
        };
        final fg = widget.selected ? c.textOncolorPrimary : c.textDefault;
        return (background: bg, foreground: fg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final p = _paint(colors);

    final labelStyle =
        (widget.size == DgaChipSize.large
                ? DgaTypography.textSm.medium
                : DgaTypography.textXs.medium)
            .copyWith(color: p.foreground);

    final iconSize = widget.size == DgaChipSize.large ? 16.0 : 12.0;

    final trailing =
        widget.trailingIcon ??
        (widget.onDeleted != null
            ? GestureDetector(
                onTap: widget.disabled ? null : widget.onDeleted,
                child: Icon(Icons.close, size: iconSize, color: p.foreground),
              )
            : null);

    Widget content = Semantics(
      button: true,
      enabled: !widget.disabled,
      selected: widget.selected,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: !widget.disabled,
        mouseCursor: widget.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.disabled
              ? null
              : (_) => setState(() => _pressed = true),
          onTapCancel: widget.disabled
              ? null
              : () => setState(() => _pressed = false),
          onTapUp: widget.disabled
              ? null
              : (_) => setState(() => _pressed = false),
          onTap: widget.disabled ? null : widget.onPressed,
          child: SizedBox(
            height: widget.size.height,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.size.horizontalPadding,
              ),
              decoration: BoxDecoration(
                color: p.background,
                borderRadius: widget.rounded
                    ? DgaRadius.brFull
                    : DgaRadius.brSm,
                border: _focused
                    ? Border.all(color: colors.borderPrimary, width: 2)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leadingIcon != null) ...[
                    IconTheme.merge(
                      data: IconThemeData(color: p.foreground, size: iconSize),
                      child: widget.leadingIcon!,
                    ),
                    const SizedBox(width: DgaSpacing.xs),
                  ],
                  Text(widget.label, style: labelStyle),
                  if (trailing != null) ...[
                    const SizedBox(width: DgaSpacing.xs),
                    trailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      content = Tooltip(message: widget.tooltip!, child: content);
    }
    return content;
  }
}
