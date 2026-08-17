import 'package:flutter/widgets.dart';

import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import '../_internal/ring_painter.dart';

/// A circular step indicator: a ring filled to `current/total` with an
/// "n/N" label in the center. [size] is the diameter in px (40/48/64/80/120).
class DgaCircleStepper extends StatelessWidget {
  const DgaCircleStepper({
    super.key,
    required this.current,
    required this.total,
    this.size = 48,
  }) : assert(total > 0),
       assert(current >= 0 && current <= total);

  final int current;
  final int total;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final stroke = (size * 0.1).clamp(3.0, 10.0);
    final numberStyle =
        (size >= 80 ? DgaTypography.textLg : DgaTypography.textSm).semibold
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
                value: current / total,
                trackColor: c.stepperLineUpcomming,
                fillColor: c.stepperLineCompleted,
                strokeWidth: stroke,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '$current', style: numberStyle),
                TextSpan(
                  text: '/$total',
                  style: numberStyle.copyWith(color: c.stepperTextTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
