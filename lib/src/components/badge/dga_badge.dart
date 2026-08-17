import 'package:flutter/widgets.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

/// Diameter of the label-less [DgaBadge.dot] — Figma `Type=Small`.
const double kDgaBadgeDotSize = 12;

/// Height of the counted badge, and the minimum width that keeps a single
/// digit circular — Figma `Type=Large` is 16x16.
const double kDgaBadgeHeight = 16;

/// A small count indicator, typically overlaid on an icon.
///
/// Two shapes, split by named constructor rather than a size enum because
/// they carry different content, not just different styling: a [dot] has no
/// label at all, while a [count] hugs its number.
///
/// ```dart
/// DgaBadge.dot()          // unread marker
/// DgaBadge.count(3)       // "3"
/// DgaBadge.count(150)     // "99+"
/// ```
class DgaBadge extends StatelessWidget {
  /// A bare 12x12 dot — presence without a number.
  const DgaBadge.dot({super.key}) : count = null, maxCount = 0;

  /// A 16-tall pill showing [count], collapsing to `"<maxCount>+"` above the
  /// cap so a large number can't stretch the badge without bound.
  const DgaBadge.count(this.count, {super.key, this.maxCount = 99})
    : assert(maxCount > 0, 'maxCount must be positive');

  /// Null for [DgaBadge.dot].
  final int? count;
  final int maxCount;

  bool get _isDot => count == null;

  String get _label => count! > maxCount ? '$maxCount+' : '$count';

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;

    if (_isDot) {
      return Container(
        width: kDgaBadgeDotSize,
        height: kDgaBadgeDotSize,
        decoration: BoxDecoration(
          color: c.tagBackgroundError,
          borderRadius: DgaRadius.brFull,
        ),
      );
    }

    return Semantics(
      label: _label,
      container: true,
      child: Container(
        height: kDgaBadgeHeight,
        // Keeps one digit circular; wider numbers grow past it.
        constraints: const BoxConstraints(minWidth: kDgaBadgeHeight),
        padding: const EdgeInsets.symmetric(horizontal: DgaSpacing.xs),
        decoration: BoxDecoration(
          color: c.tagBackgroundError,
          borderRadius: DgaRadius.brFull,
        ),
        // Centres the label without letting the badge grow: Container's own
        // `alignment` would expand it to every pixel on offer, and
        // `widthFactor: 1` keeps the box hugging its digits instead.
        child: Center(
          widthFactor: 1,
          child: Text(
            _label,
            textAlign: TextAlign.center,
            // The text-xs ramp's 18px line box doesn't fit a 16px badge, so
            // the line height collapses to the glyph and Center places it.
            style: DgaTypography.textXs.semibold.copyWith(
              color: c.textOncolorPrimary,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
