import 'package:flutter/material.dart';

import '../../theme/dga_theme.dart';
import '../_internal/control_halo.dart';
import '../_internal/control_tile.dart';

enum DgaCheckboxStyle { primary, neutral }

enum DgaCheckboxSize {
  xSmall,
  small,
  medium;

  double get side => switch (this) {
    DgaCheckboxSize.xSmall => 16,
    DgaCheckboxSize.small => 20,
    DgaCheckboxSize.medium => 24,
  };
}

/// DGA checkbox with checked / unchecked / indeterminate states.
///
/// Hover and press add a halo behind the box and darken the fill through the
/// `controlPrimary*` / `controlNeutral*` ladder; an unchecked box also greys
/// in while pressed.
class DgaCheckbox extends StatefulWidget {
  const DgaCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.indeterminate = false,
    this.style = DgaCheckboxStyle.primary,
    this.size = DgaCheckboxSize.medium,
    this.label,
    this.description,
    this.errorText,
    this.disabled = false,
    this.readOnly = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool indeterminate;
  final DgaCheckboxStyle style;
  final DgaCheckboxSize size;
  final String? label;
  final String? description;
  final String? errorText;
  final bool disabled;
  final bool readOnly;

  @override
  State<DgaCheckbox> createState() => _DgaCheckboxState();
}

class _DgaCheckboxState extends State<DgaCheckbox> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _filled => widget.value || widget.indeterminate;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final interactive =
        !widget.disabled && !widget.readOnly && widget.onChanged != null;
    final hovered = interactive && _hovered;
    final pressed = interactive && _pressed;

    final checkedColor = widget.style == DgaCheckboxStyle.primary
        ? (pressed
              ? c.controlPrimaryPressed
              : hovered
              ? c.controlPrimaryHovered
              : c.controlPrimaryChecked)
        : (pressed
              ? c.controlNeutralPressed
              : hovered
              ? c.controlNeutralHovered
              : c.controlNeutralChecked);

    final borderColor = widget.disabled
        ? c.borderNeutralSecondary
        : (_filled ? checkedColor : c.controlBorder);

    // An unchecked box greys in while pressed; a checked one just darkens.
    final fillColor = widget.disabled && _filled
        ? c.backgroundDisabled
        : _filled
        ? checkedColor
        : (pressed ? c.controlPressed : c.controlPrimary);

    // In dark mode the box goes *lighter* green on hover/press, so the glyph
    // has to flip dark — that's exactly what these two tokens encode.
    final glyphColor = pressed
        ? c.controlIconPressed
        : hovered
        ? c.controlIconHovered
        : c.iconOncolor;

    final glyphSize = widget.size.side * 0.7;

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: widget.size.side,
      height: widget.size.side,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(widget.size.side * 0.25),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: _filled
          ? Icon(
              widget.indeterminate ? Icons.remove : Icons.check,
              size: glyphSize,
              color: glyphColor,
            )
          : null,
    );

    final control = Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: MouseRegion(
        onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
        onExit: interactive ? (_) => setState(() => _hovered = false) : null,
        child: Listener(
          // Listener (not just MouseRegion) so press registers on touch.
          onPointerDown: interactive
              ? (_) => setState(() => _pressed = true)
              : null,
          onPointerUp: interactive
              ? (_) => setState(() => _pressed = false)
              : null,
          onPointerCancel: interactive
              ? (_) => setState(() => _pressed = false)
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: interactive ? () => widget.onChanged!(!widget.value) : null,
            child: DgaControlHalo(
              color: c.controlRippleEffect,
              visible: hovered || pressed,
              child: box,
            ),
          ),
        ),
      ),
    );

    return Semantics(
      checked: widget.value,
      mixed: widget.indeterminate,
      enabled: interactive,
      label: widget.label,
      child: DgaControlTile(
        control: control,
        label: widget.label,
        description: widget.description,
        errorText: widget.errorText,
        enabled: !widget.disabled,
        onTap: interactive ? () => widget.onChanged!(!widget.value) : null,
      ),
    );
  }
}
