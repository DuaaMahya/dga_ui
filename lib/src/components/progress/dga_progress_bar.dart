import 'package:flutter/widgets.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaProgressBarSize {
  small,
  medium,
  large;

  double get thickness => switch (this) {
    DgaProgressBarSize.small => 6,
    DgaProgressBarSize.medium => 8,
    DgaProgressBarSize.large => 12,
  };
}

enum DgaProgressBarStyle { primary, neutral }

/// Linear progress bar. Fills from the start (flips under RTL). Optional %
/// label; `error`/`success` recolor the fill.
class DgaProgressBar extends StatelessWidget {
  const DgaProgressBar({
    super.key,
    required this.value,
    this.size = DgaProgressBarSize.medium,
    this.style = DgaProgressBarStyle.primary,
    this.error = false,
    this.success = false,
    this.showLabel = false,
  }) : assert(value >= 0 && value <= 1);

  /// 0..1.
  final double value;
  final DgaProgressBarSize size;
  final DgaProgressBarStyle style;
  final bool error;
  final bool success;
  final bool showLabel;

  Color _fill(DgaSemanticColors c) {
    if (error) return c.backgroundError;
    if (success) return c.backgroundSuccess;
    return style == DgaProgressBarStyle.neutral
        ? c.progressBarNeutral
        : c.backgroundPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final fill = _fill(c);

    final track = ClipRRect(
      borderRadius: DgaRadius.brFull,
      child: SizedBox(
        height: size.thickness,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: c.stepperLineUpcomming)),
            // Fractional fill from the start edge (flips under RTL).
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: value.clamp(0.0, 1.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  color: fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!showLabel) return track;

    return Row(
      children: [
        Expanded(child: track),
        const SizedBox(width: DgaSpacing.md),
        Text(
          '${(value * 100).round()}%',
          style: DgaTypography.textSm.regular.copyWith(
            color: c.stepperTextSecondary,
          ),
        ),
      ],
    );
  }
}
