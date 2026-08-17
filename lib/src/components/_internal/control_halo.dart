import 'package:flutter/widgets.dart';

/// The hover/press halo drawn *behind* a form control (checkbox, radio,
/// switch).
///
/// The halo is deliberately larger than the control it sits behind, but it's
/// a [Positioned] child with negative insets inside a `Clip.none` [Stack] that
/// sizes itself to [child]. So it never changes the control's measured size
/// and never shifts surrounding layout — it simply spills outside.
class DgaControlHalo extends StatelessWidget {
  const DgaControlHalo({
    super.key,
    required this.child,
    required this.color,
    required this.visible,
    this.circle = true,
    this.spread = 8,
  });

  final Widget child;

  /// Halo tint — always `controlRippleEffect`.
  final Color color;

  final bool visible;

  /// Circle for checkbox/radio; stadium for the switch.
  final bool circle;

  /// How far the halo extends past the control on every side.
  final double spread;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          left: -spread,
          top: -spread,
          right: -spread,
          bottom: -spread,
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                // Fades to the *same* color at alpha 0 rather than a bare
                // transparent: `Color(0x00000000)` is transparent BLACK, so
                // interpolating to it drags the halo through grey.
                color: visible ? color : color.withValues(alpha: 0),
                shape: circle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: circle ? null : BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
