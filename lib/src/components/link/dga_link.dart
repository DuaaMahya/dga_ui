import 'package:flutter/material.dart';

import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaLinkStyle { primary, neutral, onColor }

enum DgaLinkSize {
  small,
  medium;

  double get iconSize => switch (this) {
    DgaLinkSize.small => 16,
    DgaLinkSize.medium => 20,
  };
}

/// Text-first link component.
///
/// - Underline: always shown when `inline: true`; hover-only otherwise.
/// - Adds a new `visited` state axis (no other DGA component has it).
class DgaLink extends StatefulWidget {
  const DgaLink({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = DgaLinkStyle.primary,
    this.size = DgaLinkSize.medium,
    this.inline = false,
    this.visited = false,
    this.disabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final String label;
  final DgaLinkStyle style;
  final DgaLinkSize size;
  final bool inline;
  final bool visited;
  final bool disabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;

  @override
  State<DgaLink> createState() => _DgaLinkState();
}

class _DgaLinkState extends State<DgaLink> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  Color _color(DgaSemanticColors c) {
    if (widget.disabled) {
      return widget.style == DgaLinkStyle.onColor
          ? c.linkOncolorDisabled
          : c.textDefaultDisabled;
    }
    switch (widget.style) {
      case DgaLinkStyle.primary:
        if (_pressed) return c.linkPrimaryPressed;
        if (_hovered) return c.linkPrimaryHovered;
        if (_focused) return c.linkPrimaryFocused;
        if (widget.visited) return c.linkPrimaryVisited;
        return c.linkPrimary;
      case DgaLinkStyle.neutral:
        if (_pressed) return c.linkNeutralPressed;
        if (_hovered) return c.linkNeutralHovered;
        if (_focused) return c.linkNeutralFocused;
        return c.linkNeutral;
      case DgaLinkStyle.onColor:
        if (_pressed) return c.linkOncolorPressed;
        if (_hovered) return c.linkOncolorHovered;
        if (_focused) return c.linkOncolorFocused;
        if (widget.visited) return c.linkOncolorVisited;
        return c.linkOncolor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final color = _color(colors);

    // Inline links are always underlined; standalone only on hover/focus.
    final showUnderline = widget.inline || _hovered || _focused;

    final textStyle =
        (widget.size == DgaLinkSize.small
                ? DgaTypography.textSm.medium
                : DgaTypography.textMd.medium)
            .copyWith(
              color: color,
              decoration: showUnderline
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: color,
            );

    final children = <Widget>[
      if (widget.leadingIcon != null)
        IconTheme.merge(
          data: IconThemeData(color: color, size: widget.size.iconSize),
          child: widget.leadingIcon!,
        ),
      Text(widget.label, style: textStyle),
      if (widget.trailingIcon != null)
        IconTheme.merge(
          data: IconThemeData(color: color, size: widget.size.iconSize),
          child: widget.trailingIcon!,
        ),
    ];

    Widget content = Semantics(
      link: true,
      enabled: !widget.disabled,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: !widget.disabled,
        mouseCursor: widget.disabled
            ? SystemMouseCursors.basic
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0)
                  SizedBox(
                    width: widget.size == DgaLinkSize.small
                        ? DgaSpacing.xs
                        : DgaSpacing.md,
                  ),
                children[i],
              ],
            ],
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
