import 'package:flutter/material.dart';

import '../../theme/dga_theme.dart';
import '../_internal/control_halo.dart';
import '../_internal/control_tile.dart';

enum DgaRadioStyle { neutral, primary }

/// DGA radio button. Generic over the value type [T] like Flutter's [Radio].
///
/// Hover and press add a halo behind the circle and darken the ring/dot
/// through the `controlPrimary*` / `controlNeutral*` ladder; an unselected
/// circle also greys in while pressed.
class DgaRadio<T> extends StatefulWidget {
  const DgaRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.style = DgaRadioStyle.primary,
    this.label,
    this.description,
    this.errorText,
    this.disabled = false,
    this.readOnly = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final DgaRadioStyle style;
  final String? label;
  final String? description;
  final String? errorText;
  final bool disabled;
  final bool readOnly;

  @override
  State<DgaRadio<T>> createState() => _DgaRadioState<T>();
}

class _DgaRadioState<T> extends State<DgaRadio<T>> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _selected => widget.value == widget.groupValue;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final interactive =
        !widget.disabled && !widget.readOnly && widget.onChanged != null;
    final hovered = interactive && _hovered;
    final pressed = interactive && _pressed;

    final checkedColor = widget.style == DgaRadioStyle.primary
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

    final ringColor = widget.disabled
        ? c.borderNeutralSecondary
        : (_selected ? checkedColor : c.controlBorder);

    // An unselected circle greys in while pressed.
    final fillColor = _selected
        ? c.controlPrimary
        : (pressed ? c.controlPressed : c.controlPrimary);

    final circle = SizedBox(
      width: 20,
      height: 20,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          border: Border.all(color: ringColor, width: 2),
        ),
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 120),
            scale: _selected ? 1 : 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: checkedColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
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
            onTap: interactive ? () => widget.onChanged!(widget.value) : null,
            child: DgaControlHalo(
              color: c.controlRippleEffect,
              visible: hovered || pressed,
              child: circle,
            ),
          ),
        ),
      ),
    );

    return Semantics(
      checked: _selected,
      inMutuallyExclusiveGroup: true,
      enabled: interactive,
      label: widget.label,
      child: DgaControlTile(
        control: control,
        label: widget.label,
        description: widget.description,
        errorText: widget.errorText,
        enabled: !widget.disabled,
        onTap: interactive ? () => widget.onChanged!(widget.value) : null,
      ),
    );
  }
}
