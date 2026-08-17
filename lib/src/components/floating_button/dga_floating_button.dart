import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaFloatingButtonStyle { primaryNeutral, primaryBrand, secondarySolid }

enum DgaFloatingButtonSize {
  small,
  large;

  double get side => switch (this) {
    DgaFloatingButtonSize.small => 56,
    DgaFloatingButtonSize.large => 64,
  };

  double get iconSize => switch (this) {
    DgaFloatingButtonSize.small => 20,
    DgaFloatingButtonSize.large => 24,
  };

  double get horizontalPadding => switch (this) {
    DgaFloatingButtonSize.small => DgaSpacing.xl, // 16
    DgaFloatingButtonSize.large => DgaSpacing.xl2, // 20
  };
}

/// Material FAB counterpart in the DGA design system.
///
/// Icon-only when no label is supplied → circular. With a label → extended
/// pill (still using the same size height).
class DgaFloatingButton extends StatefulWidget {
  const DgaFloatingButton._({
    super.key,
    required this.style,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.size,
    required this.disabled,
    required this.selected,
    required this.onColor,
    required this.focusNode,
    required this.autofocus,
    required this.tooltip,
  });

  factory DgaFloatingButton.primaryBrand({
    Key? key,
    required VoidCallback onPressed,
    required Widget icon,
    String? label,
    DgaFloatingButtonSize size = DgaFloatingButtonSize.large,
    bool disabled = false,
    bool selected = false,
    bool onColor = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaFloatingButton._(
    key: key,
    style: DgaFloatingButtonStyle.primaryBrand,
    onPressed: onPressed,
    icon: icon,
    label: label,
    size: size,
    disabled: disabled,
    selected: selected,
    onColor: onColor,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaFloatingButton.primaryNeutral({
    Key? key,
    required VoidCallback onPressed,
    required Widget icon,
    String? label,
    DgaFloatingButtonSize size = DgaFloatingButtonSize.large,
    bool disabled = false,
    bool selected = false,
    bool onColor = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaFloatingButton._(
    key: key,
    style: DgaFloatingButtonStyle.primaryNeutral,
    onPressed: onPressed,
    icon: icon,
    label: label,
    size: size,
    disabled: disabled,
    selected: selected,
    onColor: onColor,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaFloatingButton.secondarySolid({
    Key? key,
    required VoidCallback onPressed,
    required Widget icon,
    String? label,
    DgaFloatingButtonSize size = DgaFloatingButtonSize.large,
    bool disabled = false,
    bool selected = false,
    bool onColor = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaFloatingButton._(
    key: key,
    style: DgaFloatingButtonStyle.secondarySolid,
    onPressed: onPressed,
    icon: icon,
    label: label,
    size: size,
    disabled: disabled,
    selected: selected,
    onColor: onColor,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  final DgaFloatingButtonStyle style;
  final VoidCallback onPressed;
  final Widget icon;
  final String? label;
  final DgaFloatingButtonSize size;
  final bool disabled;
  final bool selected;
  final bool onColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;

  bool get _isIconOnly => label == null;

  @override
  State<DgaFloatingButton> createState() => _DgaFloatingButtonState();
}

class _DgaFloatingButtonState extends State<DgaFloatingButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  ({Color background, Color foreground}) _paint(DgaSemanticColors c) {
    if (widget.disabled) {
      return (
        background: widget.onColor
            ? c.buttonBackgroundDisabledOnColor
            : c.backgroundDisabled,
        foreground: widget.onColor
            ? c.textDefaultOncolorDisabled
            : c.textDefaultDisabled,
      );
    }

    switch (widget.style) {
      case DgaFloatingButtonStyle.primaryBrand:
        return (
          background: switch ((_pressed, widget.selected, _hovered)) {
            (true, _, _) => c.buttonBackgroundPrimaryPressed,
            (_, true, _) => c.buttonBackgroundPrimarySelected,
            (_, _, true) => c.buttonBackgroundPrimaryHovered,
            _ => c.buttonBackgroundPrimaryDefault,
          },
          foreground: c.textOncolorPrimary,
        );
      case DgaFloatingButtonStyle.primaryNeutral:
        return (
          background: switch ((_pressed, widget.selected, _hovered)) {
            (true, _, _) => c.buttonBackgroundBlackPressed,
            (_, true, _) => c.buttonBackgroundBlackSelected,
            (_, _, true) => c.buttonBackgroundBlackHovered,
            _ => c.buttonBackgroundBlackDefault,
          },
          foreground: c.textOncolorPrimary,
        );
      case DgaFloatingButtonStyle.secondarySolid:
        return (
          background: switch ((_pressed, widget.selected, _hovered)) {
            (true, _, _) => c.buttonBackgroundNeutralPressed,
            (_, true, _) => c.buttonBackgroundNeutralSelected,
            (_, _, true) => c.buttonBackgroundNeutralHovered,
            _ => c.buttonBackgroundNeutralDefault,
          },
          foreground: c.textDefault,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final p = _paint(colors);

    final child = widget._isIconOnly
        ? Center(
            child: IconTheme.merge(
              data: IconThemeData(
                color: p.foreground,
                size: widget.size.iconSize,
              ),
              child: widget.icon,
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.size.horizontalPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme.merge(
                  data: IconThemeData(
                    color: p.foreground,
                    size: widget.size.iconSize,
                  ),
                  child: widget.icon,
                ),
                const SizedBox(width: DgaSpacing.md),
                Text(
                  widget.label!,
                  style: DgaTypography.textMd.medium.copyWith(
                    color: p.foreground,
                  ),
                ),
              ],
            ),
          );

    Widget content = Semantics(
      button: true,
      enabled: !widget.disabled,
      selected: widget.selected,
      label: widget._isIconOnly ? widget.tooltip : null,
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
            height: widget.size.side,
            width: widget._isIconOnly ? widget.size.side : null,
            child: Container(
              decoration: BoxDecoration(
                color: p.background,
                borderRadius: DgaRadius.brFull,
                boxShadow: widget.disabled
                    ? const []
                    : (_pressed ? DgaShadows.xs : DgaShadows.xl3),
                border: _focused
                    ? Border.all(color: colors.borderPrimary, width: 2)
                    : null,
              ),
              child: child,
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
