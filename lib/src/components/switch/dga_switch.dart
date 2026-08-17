import 'package:flutter/material.dart';

import '../../theme/dga_primitives.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_theme.dart';
import '../_internal/control_halo.dart';
import '../_internal/control_tile.dart';

/// DGA on/off switch.
///
/// Off = outlined track with the thumb at the start; On = filled brand track
/// with a white thumb at the end. The thumb slides and the track color
/// crossfades over ~150ms. Hover and press add a halo behind the track, darken
/// the on-track, and lighten the off-thumb.
class DgaSwitch extends StatefulWidget {
  const DgaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.errorText,
    this.disabled = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final String? errorText;
  final bool disabled;

  static const double _w = 48;
  static const double _h = 24;
  static const double _thumb = 16;

  @override
  State<DgaSwitch> createState() => _DgaSwitchState();
}

class _DgaSwitchState extends State<DgaSwitch> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final enabled = !widget.disabled && widget.onChanged != null;
    final hovered = enabled && _hovered;
    final pressed = enabled && _pressed;

    // On-track darkens through the primary ladder.
    final onColor = pressed
        ? c.controlPrimaryPressed
        : hovered
        ? c.controlPrimaryHovered
        : c.controlPrimaryChecked;

    // Off-thumb goes black → grey → lighter grey through the neutral ladder.
    final offColor = pressed
        ? c.controlNeutralPressed
        : hovered
        ? c.controlNeutralHovered
        : c.controlNeutralChecked;

    final trackColor = widget.value ? onColor : c.controlPrimary;
    final borderColor = widget.value ? onColor : offColor;
    final thumbColor = widget.value ? DgaPrimitives.white : offColor;

    final track = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      width: DgaSwitch._w,
      height: DgaSwitch._h,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(DgaSwitch._h),
        border: Border.all(color: borderColor, width: widget.value ? 0 : 1.5),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            alignment: widget.value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                width: DgaSwitch._thumb,
                height: DgaSwitch._thumb,
                decoration: BoxDecoration(
                  color: thumbColor,
                  shape: BoxShape.circle,
                  boxShadow: widget.value ? DgaShadows.sm : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final control = Opacity(
      opacity: enabled ? 1 : 0.4,
      child: MouseRegion(
        onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: enabled ? (_) => setState(() => _hovered = false) : null,
        child: Listener(
          // Listener (not just MouseRegion) so press registers on touch.
          onPointerDown: enabled
              ? (_) => setState(() => _pressed = true)
              : null,
          onPointerUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onPointerCancel: enabled
              ? (_) => setState(() => _pressed = false)
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
            child: DgaControlHalo(
              color: c.controlRippleEffect,
              visible: hovered || pressed,
              circle: false,
              child: track,
            ),
          ),
        ),
      ),
    );

    return Semantics(
      toggled: widget.value,
      enabled: enabled,
      label: widget.label,
      child: DgaControlTile(
        control: control,
        label: widget.label,
        description: widget.description,
        errorText: widget.errorText,
        enabled: enabled,
        onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
      ),
    );
  }
}
