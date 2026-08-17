import 'package:flutter/widgets.dart';

import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import 'dga_circle_stepper.dart';

/// A [DgaCircleStepper] ring with a text block beside it: a title on top and
/// a "Step n of N" subtitle. Layout is directional (ring at the start).
class DgaRadialStepper extends StatelessWidget {
  const DgaRadialStepper({
    super.key,
    required this.current,
    required this.total,
    this.title,
    this.size = 48,
  }) : assert(total > 0),
       assert(current >= 0 && current <= total);

  final int current;
  final int total;
  final String? title;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final next = (current + 1).clamp(1, total);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DgaCircleStepper(current: current, total: total, size: size),
        const SizedBox(width: DgaSpacing.lg),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Text(
                title!,
                style: DgaTypography.textSm.semibold.copyWith(
                  color: c.stepperTextPrimary,
                ),
              ),
            const SizedBox(height: DgaSpacing.xxs),
            Text(
              current >= total ? 'Completed' : 'Next: step $next of $total',
              style: DgaTypography.textXs.regular.copyWith(
                color: c.stepperTextTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
