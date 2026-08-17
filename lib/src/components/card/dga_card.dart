import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

/// Surface elevation treatment.
enum DgaCardEffect { shadow, none, stroke }

/// A general-purpose surface container — the most reusable building block in
/// the library. Wrap any [child]; opt into elevation via [effect]; make it
/// interactive by passing [onTap]; make it a selection target with
/// [selected]. Compose an expandable card by putting a `DgaAccordion` inside.
class DgaCard extends StatefulWidget {
  const DgaCard({
    super.key,
    this.text,
    this.helperText,
    this.icon,
    this.child,
    this.effect = DgaCardEffect.stroke,
    this.padding = const EdgeInsets.all(DgaSpacing.xl),
    this.borderRadius,
    this.onTap,
    this.selected = false,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.antiAlias,
  });

  final String? text;
  final String? helperText;
  final Widget? icon;
  final Widget? child;
  final DgaCardEffect effect;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  /// When set, the card becomes tappable with hover/press/focus feedback.
  final VoidCallback? onTap;

  /// Draws the brand selection border (use with [onTap] for selectable cards).
  final bool selected;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;

  bool get _interactive => onTap != null && !disabled;

  @override
  State<DgaCard> createState() => _DgaCardState();
}

class _DgaCardState extends State<DgaCard> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  ({Color background, Border? border, List<BoxShadow>? shadow}) _decoration(
    DgaSemanticColors c,
  ) {
    final radiusFocused = _focused && widget._interactive;

    Border? border;
    if (widget.selected) {
      border = Border.all(color: c.borderPrimary, width: 2);
    } else if (radiusFocused) {
      border = Border.all(color: c.borderPrimary, width: 2);
    } else if (widget.effect == DgaCardEffect.stroke) {
      border = Border.all(color: c.borderNeutralPrimary);
    }

    List<BoxShadow>? shadow;
    if (widget.effect == DgaCardEffect.shadow && !widget.disabled) {
      shadow = _pressed
          ? DgaShadows.sm
          : (_hovered ? DgaShadows.md : DgaShadows.xs);
    }

    // Background wash on hover/press — applies regardless of [effect], since
    // `stroke`/`none` otherwise had no visual feedback at all beyond the
    // cursor. Press reads as a deeper step than hover, same ladder used by
    // DgaAccordion's header wash.
    Color background;
    if (widget.disabled) {
      background = c.backgroundDisabled;
    } else if (widget._interactive && _pressed) {
      background = c.backgroundNeutral200;
    } else if (widget._interactive && _hovered) {
      background = c.backgroundNeutral100;
    } else {
      background = c.backgroundCard;
    }

    return (background: background, border: border, shadow: shadow);
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final d = _decoration(c);
    final radius = widget.borderRadius ?? DgaRadius.brLg;

    Widget surface = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      clipBehavior: widget.clipBehavior,
      decoration: BoxDecoration(
        color: d.background,
        borderRadius: radius,
        border: d.border,
        boxShadow: d.shadow,
      ),
      child: Padding(
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            if (widget.icon != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom:
                      widget.text != null ||
                          widget.helperText != null ||
                          widget.child != null
                      ? DgaSpacing.xl3
                      : 0,
                ),
                child: widget.icon!,
              ),
            // Title text
            if (widget.text != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom: widget.helperText != null || widget.child != null
                      ? DgaSpacing.sm
                      : 0,
                ),
                child: Text(
                  widget.text!,
                  style: DgaTypography.textLg.bold.copyWith(
                    color: c.textDisplay,
                  ),
                ),
              ),
            // Helper text
            if (widget.helperText != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom: widget.child != null ? DgaSpacing.xl : 0,
                ),
                child: Text(
                  widget.helperText!,
                  style: DgaTypography.textMd.regular.copyWith(
                    color: c.textDisplay,
                  ),
                ),
              ),
            //
            widget.child ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );

    if (!widget._interactive) return surface;

    return Semantics(
      button: true,
      selected: widget.selected,
      enabled: !widget.disabled,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: widget._interactive,
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: surface,
        ),
      ),
    );
  }
}
