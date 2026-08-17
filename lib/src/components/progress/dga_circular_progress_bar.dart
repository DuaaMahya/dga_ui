import 'package:flutter/widgets.dart';

import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import '../_internal/ring_painter.dart';

enum DgaCircularProgressStyle { primary, neutral, success, error }

/// Circular progress ring with an optional centered % label. [size] is the
/// diameter in px (Figma ships 64/80/120/160/200).
class DgaCircularProgressBar extends StatelessWidget {
  const DgaCircularProgressBar({
    super.key,
    required this.value,
    this.size = 80,
    this.style = DgaCircularProgressStyle.primary,
    this.showLabel = true,
  }) : assert(value >= 0 && value <= 1);

  final double value;
  final double size;
  final DgaCircularProgressStyle style;
  final bool showLabel;

  Color _fill(DgaSemanticColors c) => switch (style) {
    DgaCircularProgressStyle.primary => c.backgroundPrimary,
    DgaCircularProgressStyle.neutral => c.progressBarNeutral,
    DgaCircularProgressStyle.success => c.backgroundSuccess,
    DgaCircularProgressStyle.error => c.backgroundError,
  };

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final stroke = (size * 0.1).clamp(4.0, 16.0);
    final labelStyle =
        (size >= 120 ? DgaTypography.textLg : DgaTypography.textSm).semibold
            .copyWith(color: c.stepperTextPrimary);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DgaRingPainter(
                value: value,
                trackColor: c.stepperLineUpcomming,
                fillColor: _fill(c),
                strokeWidth: stroke,
              ),
            ),
          ),
          if (showLabel) Text('${(value * 100).round()}%', style: labelStyle),
        ],
      ),
    );
  }
}
