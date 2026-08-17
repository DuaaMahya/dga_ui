import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import '../text_input/dga_text_input_enums.dart';

/// One selectable option for [DgaDropdownInput].
class DgaDropdownEntry<T> {
  const DgaDropdownEntry({
    required this.value,
    required this.label,
    this.leadingIcon,
  });
  final T value;
  final String label;
  final Widget? leadingIcon;
}

/// A select field. Shares the DGA text-input chrome (fill/border by
/// [DgaTextInputStyle], `input*` tokens, center-expand focus underline) with
/// a trailing chevron and a popup menu of [items].
class DgaDropdownInput<T> extends StatefulWidget {
  const DgaDropdownInput({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.required = false,
    this.hintText,
    this.helperText,
    this.errorText,
    this.style = DgaTextInputStyle.standard,
    this.size = DgaTextInputSize.large,
    this.enabled = true,
    this.readOnly = false,
  });

  final List<DgaDropdownEntry<T>> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final String? label;
  final bool required;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final DgaTextInputStyle style;
  final DgaTextInputSize size;
  final bool enabled;
  final bool readOnly;

  bool get _hasError => errorText != null;

  @override
  State<DgaDropdownInput<T>> createState() => _DgaDropdownInputState<T>();
}

class _DgaDropdownInputState<T> extends State<DgaDropdownInput<T>>
    with SingleTickerProviderStateMixin {
  final _overlay = OverlayPortalController();
  final _link = LayerLink();
  late final AnimationController _underline;

  bool _pressed = false;
  bool _hovered = false;

  bool get _open => _overlay.isShowing;
  bool get _interactive => widget.enabled && !widget.readOnly;

  /// Pointer-down shows a short centred stub; opening the menu then carries
  /// it out to full width from wherever the stub got to.
  void _onPointerDown() {
    // Press is only a stepping stone into the open state. Pressing again
    // while the menu is open stays full-width — the tap that follows closes
    // the menu and retracts the underline.
    if (_open) return;
    setState(() => _pressed = true);
    _underline.animateTo(
      kDgaFieldPressStub,
      duration: kDgaFieldPressDuration,
      curve: Curves.easeOut,
    );
  }

  void _onPointerRelease() {
    setState(() => _pressed = false);
    // The tap that follows opens the menu and expands the stub; if it
    // didn't open (cancelled), retract.
    if (!_open) _underline.animateBack(0, curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    _underline = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _underline.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!_interactive) return;
    if (_open) {
      _overlay.hide();
      _underline.animateBack(0, curve: Curves.easeOut);
    } else {
      _overlay.show();
      _underline.animateTo(1, curve: Curves.easeOut);
    }
    setState(() {});
  }

  void _select(T value) {
    widget.onChanged(value);
    _overlay.hide();
    _underline.animateBack(0, curve: Curves.easeOut);
    setState(() {});
  }

  DgaDropdownEntry<T>? get _selected {
    for (final e in widget.items) {
      if (e.value == widget.value) return e;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;

    final fill = !widget.enabled
        ? c.backgroundDisabled
        : (_pressed && _interactive)
        ? c.fieldBackgroundPressed
        : switch (widget.style) {
            DgaTextInputStyle.standard => c.fieldBackgroundDefault,
            DgaTextInputStyle.filledDarker => c.fieldBackgroundDarker,
            DgaTextInputStyle.filledLighter => c.fieldBackgroundLighter,
          };
    // Press keeps the light stroke — the feedback is the stub + fill.
    final borderColor = widget._hasError
        ? c.fieldBorderError
        : (_hovered && _interactive && !_pressed)
        ? c.fieldBorderHovered
        : (widget.style == DgaTextInputStyle.standard
              ? c.fieldBorderDefault
              : null);
    final underlineColor = widget._hasError
        ? c.fieldBorderError
        : c.fieldBorderPressed;

    final selected = _selected;
    final valueColor = !widget.enabled
        ? c.textDefaultDisabled
        : (selected != null ? c.fieldTextFilled : c.fieldTextPlaceholder);
    final displayText = selected?.label ?? widget.hintText ?? '';

    final field = Stack(
      children: [
        Container(
          height: widget.size.fieldHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: DgaRadius.brSm,
            border: borderColor != null ? Border.all(color: borderColor) : null,
            boxShadow: _open && widget.enabled ? DgaShadows.md : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: DgaSpacing.xl,
                    end: DgaSpacing.md,
                  ),
                  child: Text(
                    displayText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DgaTypography.textMd.regular.copyWith(
                      color: valueColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: DgaSpacing.xl),
                child: AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: widget.enabled
                        ? c.iconDefault
                        : c.textDefaultDisabled,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Center-expanding focus underline (open == focused).
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _underline,
            builder: (context, _) => Transform.scale(
              scaleX: _underline.value,
              alignment: Alignment.center,
              child: Container(height: 2, color: underlineColor),
            ),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.required) ...[
                Text(
                  '*',
                  style: DgaTypography.textSm.regular.copyWith(
                    color: c.fieldBorderError,
                  ),
                ),
                const SizedBox(width: DgaSpacing.xs),
              ],
              Text(
                widget.label!,
                style: DgaTypography.textSm.regular.copyWith(
                  color: c.fieldTextLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: DgaSpacing.md),
        ],
        CompositedTransformTarget(
          link: _link,
          child: OverlayPortal(
            controller: _overlay,
            overlayChildBuilder: (context) => _menu(c),
            child: MouseRegion(
              cursor: _interactive
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: Listener(
                onPointerDown: _interactive ? (_) => _onPointerDown() : null,
                onPointerUp: _interactive ? (_) => _onPointerRelease() : null,
                onPointerCancel: _interactive
                    ? (_) => _onPointerRelease()
                    : null,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggle,
                  child: field,
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: DgaSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget._hasError ? Icons.error_outline : Icons.help_outline,
                size: 16,
                color: widget._hasError
                    ? c.fieldBorderError
                    : c.fieldTextHelper,
              ),
              const SizedBox(width: DgaSpacing.md),
              Flexible(
                child: Text(
                  widget.errorText ?? widget.helperText!,
                  style: DgaTypography.textSm.regular.copyWith(
                    color: widget._hasError
                        ? c.fieldBorderError
                        : c.fieldTextHelper,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _menu(DgaSemanticColors c) {
    // Tap-away barrier + the anchored menu list.
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggle,
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, DgaSpacing.xs),
          child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: const Color(0x00000000),
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 200,
                  maxWidth: 360,
                  maxHeight: 280,
                ),
                decoration: BoxDecoration(
                  color: c.fieldBackgroundDefault,
                  borderRadius: DgaRadius.brSm,
                  border: Border.all(color: c.fieldBorderDefault),
                  boxShadow: DgaShadows.lg,
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: DgaSpacing.xs),
                  shrinkWrap: true,
                  children: [
                    for (final e in widget.items)
                      _MenuItem<T>(
                        entry: e,
                        selected: e.value == widget.value,
                        onTap: () => _select(e.value),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem<T> extends StatefulWidget {
  const _MenuItem({
    required this.entry,
    required this.selected,
    required this.onTap,
  });
  final DgaDropdownEntry<T> entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_MenuItem<T>> createState() => _MenuItemState<T>();
}

class _MenuItemState<T> extends State<_MenuItem<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final bg = widget.selected
        ? c.fieldBackgroundDarker
        : (_hovered ? c.iconPrimary : c.iconPrimary.withAlpha(0));
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          color: bg,
          padding: const EdgeInsets.symmetric(
            horizontal: DgaSpacing.xl,
            vertical: DgaSpacing.lg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.entry.leadingIcon != null) ...[
                IconTheme.merge(
                  data: IconThemeData(color: c.iconDefault, size: 20),
                  child: widget.entry.leadingIcon!,
                ),
                const SizedBox(width: DgaSpacing.md),
              ],
              Text(
                widget.entry.label,
                style: DgaTypography.textMd.regular.copyWith(
                  color: c.fieldTextFilled,
                ),
              ),
              if (widget.selected) ...[
                Spacer(),
                Icon(Icons.check, size: 18, color: c.fieldBorderPressed),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
