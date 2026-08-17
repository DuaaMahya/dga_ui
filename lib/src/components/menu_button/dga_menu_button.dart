import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import '../button/dga_button_size.dart';
import '../button/dga_button_style.dart';

/// Button variant that opens a menu — same six styles as DgaButton with a
/// trailing chevron. No destructive/on-color axes (Figma doesn't ship them).
class DgaMenuButton extends StatefulWidget {
  const DgaMenuButton._({
    super.key,
    required this.style,
    required this.onPressed,
    required this.label,
    required this.leadingIcon,
    required this.size,
    required this.disabled,
    required this.selected,
    required this.chevronOpen,
    required this.focusNode,
    required this.autofocus,
    required this.tooltip,
  });

  factory DgaMenuButton.primary({
    Key? key,
    required VoidCallback onPressed,
    required String label,
    Widget? leadingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool disabled = false,
    bool selected = false,
    bool chevronOpen = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaMenuButton._(
    key: key,
    style: DgaButtonStyle.primary,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    size: size,
    disabled: disabled,
    selected: selected,
    chevronOpen: chevronOpen,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaMenuButton.neutral({
    Key? key,
    required VoidCallback onPressed,
    required String label,
    Widget? leadingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool disabled = false,
    bool selected = false,
    bool chevronOpen = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaMenuButton._(
    key: key,
    style: DgaButtonStyle.neutral,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    size: size,
    disabled: disabled,
    selected: selected,
    chevronOpen: chevronOpen,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaMenuButton.secondarySolid({
    Key? key,
    required VoidCallback onPressed,
    required String label,
    Widget? leadingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool disabled = false,
    bool selected = false,
    bool chevronOpen = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaMenuButton._(
    key: key,
    style: DgaButtonStyle.secondarySolid,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    size: size,
    disabled: disabled,
    selected: selected,
    chevronOpen: chevronOpen,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaMenuButton.secondaryOutline({
    Key? key,
    required VoidCallback onPressed,
    required String label,
    Widget? leadingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool disabled = false,
    bool selected = false,
    bool chevronOpen = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaMenuButton._(
    key: key,
    style: DgaButtonStyle.secondaryOutline,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    size: size,
    disabled: disabled,
    selected: selected,
    chevronOpen: chevronOpen,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaMenuButton.subtle({
    Key? key,
    required VoidCallback onPressed,
    required String label,
    Widget? leadingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool disabled = false,
    bool selected = false,
    bool chevronOpen = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaMenuButton._(
    key: key,
    style: DgaButtonStyle.subtle,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    size: size,
    disabled: disabled,
    selected: selected,
    chevronOpen: chevronOpen,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  factory DgaMenuButton.transparent({
    Key? key,
    required VoidCallback onPressed,
    required String label,
    Widget? leadingIcon,
    DgaButtonSize size = DgaButtonSize.medium,
    bool disabled = false,
    bool selected = false,
    bool chevronOpen = false,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
  }) => DgaMenuButton._(
    key: key,
    style: DgaButtonStyle.transparent,
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    size: size,
    disabled: disabled,
    selected: selected,
    chevronOpen: chevronOpen,
    focusNode: focusNode,
    autofocus: autofocus,
    tooltip: tooltip,
  );

  final DgaButtonStyle style;
  final VoidCallback onPressed;
  final String label;
  final Widget? leadingIcon;
  final DgaButtonSize size;
  final bool disabled;
  final bool selected;

  /// Flips the trailing chevron 180° so callers can indicate "menu open".
  final bool chevronOpen;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;

  @override
  State<DgaMenuButton> createState() => _DgaMenuButtonState();
}

class _DgaMenuButtonState extends State<DgaMenuButton> {
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
    DgaButtonSize.small => DgaSpacing.md,
    DgaButtonSize.medium => DgaSpacing.lg,
    DgaButtonSize.large => DgaSpacing.xl,
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
      destructive: false,
      onColor: false,
    );

    final chevron = AnimatedRotation(
      turns: widget.chevronOpen ? 0.5 : 0,
      duration: const Duration(milliseconds: 150),
      child: Icon(Icons.keyboard_arrow_down, size: 16, color: paint.foreground),
    );

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
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              decoration: BoxDecoration(
                color: paint.background,
                borderRadius: DgaRadius.brSm,
                border: paint.border != null
                    ? Border.all(color: paint.border!, width: 1)
                    : (_focused
                          ? Border.all(color: colors.borderPrimary, width: 2)
                          : null),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leadingIcon != null) ...[
                    IconTheme.merge(
                      data: IconThemeData(color: paint.foreground, size: 16),
                      child: widget.leadingIcon!,
                    ),
                    const SizedBox(width: DgaSpacing.xs),
                  ],
                  Text(
                    widget.label,
                    style: _labelStyle.copyWith(color: paint.foreground),
                  ),
                  const SizedBox(width: DgaSpacing.xs),
                  chevron,
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
