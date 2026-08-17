import 'package:flutter/material.dart';

import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaAccordionSize {
  small,
  medium,
  large;

  double get headerHeight => switch (this) {
    DgaAccordionSize.small => 40,
    DgaAccordionSize.medium => 48,
    DgaAccordionSize.large => 56,
  };

  TextStyle get titleStyle => switch (this) {
    DgaAccordionSize.small => DgaTypography.textSm.semibold,
    DgaAccordionSize.medium => DgaTypography.textMd.semibold,
    DgaAccordionSize.large => DgaTypography.textMd.semibold,
  };
}

/// Expandable disclosure panel.
///
/// Items are separated by a **top divider** — set [isFirst] on the first
/// item in a list to hide its divider. Three states: default, hover, and
/// disabled. The chevron rotates and the body animates open/closed.
class DgaAccordion extends StatefulWidget {
  const DgaAccordion({
    super.key,
    required this.title,
    required this.child,
    this.size = DgaAccordionSize.medium,
    this.iconLeading = false,
    this.isFirst = false,
    this.initiallyExpanded = false,
    this.disabled = false,
    this.leadingIcon,
    this.onExpansionChanged,
  });

  final String title;
  final Widget child;
  final DgaAccordionSize size;

  /// When true the chevron sits at the start; otherwise at the end.
  final bool iconLeading;

  /// Hides the top divider — pass true for the first item in a stacked list.
  final bool isFirst;
  final bool initiallyExpanded;
  final bool disabled;
  final Widget? leadingIcon;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<DgaAccordion> createState() => _DgaAccordionState();
}

class _DgaAccordionState extends State<DgaAccordion> {
  late bool _expanded = widget.initiallyExpanded;
  bool _hovered = false;
  bool _pressed = false;

  void _toggle() {
    if (widget.disabled) return;
    setState(() => _expanded = !_expanded);
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final titleColor = widget.disabled ? c.textDefaultDisabled : c.textDefault;

    final chevron = AnimatedRotation(
      turns: _expanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: Icon(Icons.keyboard_arrow_down, color: titleColor, size: 20),
    );

    // Feedback wash on press (works on touch) and hover (desktop). The "off"
    // color is an alpha-0 version of the wash (NOT Colors.transparent) so
    // AnimatedContainer only fades opacity — fading to transparent-black
    // would flash grey.
    final wash = c.backgroundNeutral100;
    final active = (_pressed || _hovered) && !widget.disabled;
    final headerBg = active ? wash : wash.withValues(alpha: 0);

    final header = MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Listener(
        onPointerDown: widget.disabled
            ? null
            : (_) => setState(() => _pressed = true),
        onPointerUp: widget.disabled
            ? null
            : (_) => setState(() => _pressed = false),
        onPointerCancel: widget.disabled
            ? null
            : (_) => setState(() => _pressed = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: widget.size.headerHeight,
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: DgaSpacing.xl),
            child: Row(
              children: [
                if (widget.iconLeading) ...[
                  chevron,
                  const SizedBox(width: DgaSpacing.md),
                ],
                if (widget.leadingIcon != null) ...[
                  IconTheme.merge(
                    data: IconThemeData(color: titleColor, size: 20),
                    child: widget.leadingIcon!,
                  ),
                  const SizedBox(width: DgaSpacing.md),
                ],
                Expanded(
                  child: Text(
                    widget.title,
                    style: widget.size.titleStyle.copyWith(color: titleColor),
                  ),
                ),
                if (!widget.iconLeading) chevron,
              ],
            ),
          ),
        ),
      ),
    );

    final body = AnimatedCrossFade(
      firstChild: const SizedBox(width: double.infinity, height: 0),
      secondChild: Padding(
        padding: const EdgeInsets.fromLTRB(
          DgaSpacing.xl,
          0,
          DgaSpacing.xl,
          DgaSpacing.xl,
        ),
        child: DefaultTextStyle.merge(
          style: DgaTypography.textSm.regular.copyWith(
            color: c.textPrimaryParagraph,
          ),
          child: widget.child,
        ),
      ),
      crossFadeState: _expanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );

    return Semantics(
      button: true,
      expanded: _expanded,
      enabled: !widget.disabled,
      label: widget.title,
      child: DecoratedBox(
        // Top divider separates items; hidden for the first item in a list.
        decoration: BoxDecoration(
          border: widget.isFirst
              ? null
              : Border(top: BorderSide(color: c.borderNeutralSecondary)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [header, body],
        ),
      ),
    );
  }
}
