import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';

enum DgaCloseButtonSize {
  xSmall,
  small,
  medium,
  large;

  /// Fixed square dimension per Figma spec.
  double get side => switch (this) {
    DgaCloseButtonSize.xSmall => DgaSpacing.xl2,
    DgaCloseButtonSize.small => DgaSpacing.xl3,
    DgaCloseButtonSize.medium => DgaSpacing.xl4,
    DgaCloseButtonSize.large => DgaSpacing.xl5,
  };

  double get iconSize => switch (this) {
    DgaCloseButtonSize.xSmall => 12,
    DgaCloseButtonSize.small => 14,
    DgaCloseButtonSize.medium => 16,
    DgaCloseButtonSize.large => 20,
  };
}

/// A single-purpose "×" button used in dialogs, sheets, chips, etc.
///
/// Ships with light hover/press washes drawn from the SecondarySolid family
/// so it blends into any surface. Icon-only by design.
class DgaCloseButton extends StatefulWidget {
  const DgaCloseButton({
    super.key,
    required this.onPressed,
    this.size = DgaCloseButtonSize.medium,
    this.onColor = false,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.tooltip = 'Close',
  });

  final VoidCallback onPressed;
  final DgaCloseButtonSize size;
  final bool onColor;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;

  @override
  State<DgaCloseButton> createState() => _DgaCloseButtonState();
}

class _DgaCloseButtonState extends State<DgaCloseButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;

    // Wash tokens pulled from the SecondarySolid + On-color families.
    Color background;
    Color iconColor;
    if (widget.disabled) {
      background = widget.onColor
          ? colors.buttonBackgroundDisabledOnColor
          : colors.backgroundDisabled;
      iconColor = widget.onColor
          ? colors.iconDefaultOncolorDisabled
          : colors.iconDefaultDisabled;
    } else if (widget.onColor) {
      background = switch ((_pressed, _hovered, _focused)) {
        (true, _, _) => colors.buttonBackgroundOncolorPressed,
        (_, true, _) => colors.buttonBackgroundOncolorHovered,
        _ => const Color(0x00000000),
      };
      iconColor = colors.iconOncolor;
    } else {
      background = switch ((_pressed, _hovered, _focused)) {
        (true, _, _) => colors.buttonBackgroundNeutralPressed,
        (_, true, _) => colors.buttonBackgroundNeutralHovered,
        _ => const Color(0x00000000),
      };
      iconColor = colors.iconDefault;
    }

    Widget content = Semantics(
      button: true,
      enabled: !widget.disabled,
      label: widget.tooltip,
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
            width: widget.size.side,
            height: widget.size.side,
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: DgaRadius.brSm,
                border: _focused
                    ? Border.all(
                        color: widget.onColor
                            ? colors.borderWhite
                            : colors.borderPrimary,
                        width: 2,
                      )
                    : null,
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  size: widget.size.iconSize,
                  color: iconColor,
                ),
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
