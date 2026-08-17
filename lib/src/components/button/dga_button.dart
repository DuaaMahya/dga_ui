import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import 'dga_button_size.dart';
import 'dga_button_style.dart';

/// DGA design-system button.
///
/// Style is chosen at the call site via named factories — `.primary`,
/// `.neutral`, `.secondarySolid`, `.secondaryOutline`, `.subtle`,
/// `.transparent`. There is no default constructor.
///
/// Icon-only mode is inferred when `label == null` and an icon is supplied;
/// in that mode a non-empty [tooltip] is required and used as the Semantics
/// label (asserted in debug).
class DgaButton extends StatefulWidget {
  const DgaButton._({
    super.key,
    required this.style,
    required this.onPressed,
    required this.label,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.size,
    required this.destructive,
    required this.disabled,
    required this.onColor,
    required this.selected,
    required this.focusNode,
    required this.autofocus,
    required this.tooltip,
  }) : assert(
         label != null || leadingIcon != null || trailingIcon != null,
         'DgaButton needs a label or at least one icon',
       ),
       assert(
         label != null || tooltip != null,
         'Icon-only DgaButton requires a tooltip for accessibility',
       );

  factory DgaButton.primary({
    Key? key,
    required VoidCallback onPressed,
    String? label,
    Widget? leadingIcon,
    Widget? trailingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool destructive = false,
    bool disabled = false,
    bool onColor = false,
    bool selected = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaButton._(
    key: key,
    style: DgaButtonStyle.primary,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    size: size,
    destructive: destructive,
    disabled: disabled,
    onColor: onColor,
    selected: selected,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaButton.neutral({
    Key? key,
    required VoidCallback onPressed,
    String? label,
    Widget? leadingIcon,
    Widget? trailingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool destructive = false,
    bool disabled = false,
    bool onColor = false,
    bool selected = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaButton._(
    key: key,
    style: DgaButtonStyle.neutral,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    size: size,
    destructive: destructive,
    disabled: disabled,
    onColor: onColor,
    selected: selected,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaButton.secondarySolid({
    Key? key,
    required VoidCallback onPressed,
    String? label,
    Widget? leadingIcon,
    Widget? trailingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool destructive = false,
    bool disabled = false,
    bool onColor = false,
    bool selected = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaButton._(
    key: key,
    style: DgaButtonStyle.secondarySolid,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    size: size,
    destructive: destructive,
    disabled: disabled,
    onColor: onColor,
    selected: selected,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaButton.secondaryOutline({
    Key? key,
    required VoidCallback onPressed,
    String? label,
    Widget? leadingIcon,
    Widget? trailingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool destructive = false,
    bool disabled = false,
    bool onColor = false,
    bool selected = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaButton._(
    key: key,
    style: DgaButtonStyle.secondaryOutline,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    size: size,
    destructive: destructive,
    disabled: disabled,
    onColor: onColor,
    selected: selected,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaButton.subtle({
    Key? key,
    required VoidCallback onPressed,
    String? label,
    Widget? leadingIcon,
    Widget? trailingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool destructive = false,
    bool disabled = false,
    bool onColor = false,
    bool selected = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaButton._(
    key: key,
    style: DgaButtonStyle.subtle,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    size: size,
    destructive: destructive,
    disabled: disabled,
    onColor: onColor,
    selected: selected,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaButton.transparent({
    Key? key,
    required VoidCallback onPressed,
    String? label,
    Widget? leadingIcon,
    Widget? trailingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool destructive = false,
    bool disabled = false,
    bool onColor = false,
    bool selected = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaButton._(
    key: key,
    style: DgaButtonStyle.transparent,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    size: size,
    destructive: destructive,
    disabled: disabled,
    onColor: onColor,
    selected: selected,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  final DgaButtonStyle style;
  final VoidCallback onPressed;
  final String? label;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final DgaButtonSize size;
  final bool destructive;
  final bool disabled;
  final bool onColor;
  final bool selected;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;

  bool get _isIconOnly =>
      label == null && (leadingIcon != null || trailingIcon != null);

  @override
  State<DgaButton> createState() => _DgaButtonState();
}

class _DgaButtonState extends State<DgaButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  DgaButtonInteractionState get _state {
    if (widget.disabled) return DgaButtonInteractionState.disabled;
    if (_pressed) return DgaButtonInteractionState.pressed;
    if (widget.selected) return DgaButtonInteractionState.selected;
    if (_hovered) return DgaButtonInteractionState.hovered;
    if (_focused) return DgaButtonInteractionState.focused;
    return DgaButtonInteractionState.defaultState;
  }

  double get _horizontalPadding => switch (widget.size) {
    DgaButtonSize.small => DgaSpacing.md, // 8
    DgaButtonSize.medium => DgaSpacing.lg, // 12
    DgaButtonSize.large => DgaSpacing.xl, // 16
  };

  TextStyle get _labelStyle => switch (widget.size) {
    DgaButtonSize.small => DgaTypography.textXs.medium,
    DgaButtonSize.medium => DgaTypography.textSm.medium,
    DgaButtonSize.large => DgaTypography.textMd.medium,
  };

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final paint = resolveButtonPaint(
      colors: colors,
      style: widget.style,
      state: _state,
      destructive: widget.destructive,
      onColor: widget.onColor,
    );

    final children = <Widget>[
      if (widget.leadingIcon != null)
        IconTheme.merge(
          data: IconThemeData(color: paint.foreground, size: DgaSpacing.xl),
          child: widget.leadingIcon!,
        ),
      if (widget.label != null)
        Text(
          widget.label!,
          style: _labelStyle.copyWith(color: paint.foreground),
        ),
      if (!widget._isIconOnly && widget.trailingIcon != null)
        IconTheme.merge(
          data: IconThemeData(color: paint.foreground, size: DgaSpacing.xl),
          child: widget.trailingIcon!,
        ),
    ];

    // Show a focus ring only when actually focused. Uses the style's brand
    // border for non-destructive, error-light for destructive. See plan
    // Open Question #1 — final destructive-icon-only-on-color color TBD.
    final focusRingColor = widget.destructive
        ? colors.borderErrorLight
        : (widget.onColor ? colors.borderWhite : colors.borderPrimary);

    Widget content = Semantics(
      button: true,
      enabled: !widget.disabled,
      selected: widget.selected,
      // Only set label when icon-only — otherwise the inner Text's semantics
      // already carries it and merging would duplicate.
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
            // Fixed height per Figma spec — small 24, medium 32, large 40.
            // Icon-only becomes a square of the same dimension.
            height: widget.size.height,
            width: widget._isIconOnly ? widget.size.height : null,
            child: Container(
              padding: widget._isIconOnly
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: _horizontalPadding),
              decoration: BoxDecoration(
                color: paint.background,
                borderRadius: DgaRadius.brSm,
                border: paint.border != null
                    ? Border.all(color: paint.border!, width: 1)
                    : (_focused
                          ? Border.all(
                              color: focusRingColor,
                              width: DgaSpacing.xxs,
                            )
                          : null),
              ),
              child: Center(
                widthFactor: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < children.length; i++) ...[
                      if (i > 0) const SizedBox(width: DgaSpacing.xs),
                      children[i],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null && !widget._isIconOnly) {
      content = Tooltip(message: widget.tooltip!, child: content);
    } else if (widget.tooltip != null) {
      // Icon-only: tooltip still shown on long-press / hover, but the
      // Semantics label is already set above so we don't double-announce.
      content = Tooltip(message: widget.tooltip!, child: content);
    }

    return content;
  }
}
