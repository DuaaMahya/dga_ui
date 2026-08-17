import 'package:flutter/material.dart';

import '../../theme/dga_primitives.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';

enum DgaRatingSize {
  small,
  medium,
  large;

  double get side => switch (this) {
    DgaRatingSize.small => 24,
    DgaRatingSize.medium => 32,
    DgaRatingSize.large => 48,
  };
}

enum DgaRatingStyle { defaultGold, brand }

/// A single rating star: empty, half, or full.
class DgaRatingStar extends StatelessWidget {
  const DgaRatingStar({
    super.key,
    required this.fill,
    this.size = DgaRatingSize.medium,
    this.style = DgaRatingStyle.defaultGold,
  }) : assert(fill >= 0 && fill <= 1);

  /// 0 = empty, 0.5 = half, 1 = full.
  final double fill;
  final DgaRatingSize size;
  final DgaRatingStyle style;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final filled = style == DgaRatingStyle.brand
        ? c.backgroundPrimary
        : DgaPrimitives.gold600Primary;
    return _StarIcon(
      fill: fill,
      side: size.side,
      filled: filled,
      empty: c.borderNeutralPrimary,
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    required this.fill,
    required this.side,
    required this.filled,
    required this.empty,
  });

  final double fill;
  final double side;
  final Color filled;
  final Color empty;

  @override
  Widget build(BuildContext context) {
    if (fill <= 0) return Icon(Icons.star, size: side, color: empty);
    if (fill >= 1) return Icon(Icons.star, size: side, color: filled);
    // Half (or partial): empty base with a clipped filled overlay.
    return Stack(
      children: [
        Icon(Icons.star, size: side, color: empty),
        ClipRect(
          clipper: _FractionClipper(fill),
          child: Icon(Icons.star, size: side, color: filled),
        ),
      ],
    );
  }
}

class _FractionClipper extends CustomClipper<Rect> {
  const _FractionClipper(this.fraction);
  final double fraction;
  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  @override
  bool shouldReclip(_FractionClipper old) => old.fraction != fraction;
}

/// A row of rating stars. Tap-to-rate when [onChanged] is provided; supports
/// half-star display via a fractional [value].
class DgaRatingBar extends StatelessWidget {
  const DgaRatingBar({
    super.key,
    required this.value,
    this.count = 5,
    this.onChanged,
    this.size = DgaRatingSize.medium,
    this.style = DgaRatingStyle.defaultGold,
  });

  final double value;
  final int count;
  final ValueChanged<int>? onChanged;
  final DgaRatingSize size;
  final DgaRatingStyle style;

  double _fillFor(int index) => (value - index).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Rating',
      value: '$value of $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: DgaSpacing.xs),
            GestureDetector(
              onTap: onChanged == null ? null : () => onChanged!(i + 1),
              child: DgaRatingStar(fill: _fillFor(i), size: size, style: style),
            ),
          ],
        ],
      ),
    );
  }
}
