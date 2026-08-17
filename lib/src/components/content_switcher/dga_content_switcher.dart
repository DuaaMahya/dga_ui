import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaContentSwitcherSize {
  small,
  medium,
  large;

  double get height => switch (this) {
    DgaContentSwitcherSize.small => 32,
    DgaContentSwitcherSize.medium => 40,
    DgaContentSwitcherSize.large => 48,
  };

  TextStyle get textStyle => switch (this) {
    DgaContentSwitcherSize.small => DgaTypography.textSm.medium,
    DgaContentSwitcherSize.medium => DgaTypography.textMd.medium,
    DgaContentSwitcherSize.large => DgaTypography.textLg.medium,
  };
}

/// Segmented control: a row of options where exactly one is selected. The
/// selected segment gets a dark fill with white text; the container is a
/// neutral track with a border.
class DgaContentSwitcher extends StatelessWidget {
  const DgaContentSwitcher({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
    this.size = DgaContentSwitcherSize.medium,
  }) : assert(segments.length > 1),
       assert(selectedIndex >= 0 && selectedIndex < segments.length);

  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final DgaContentSwitcherSize size;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    return ClipRRect(
      borderRadius: DgaRadius.brMd,
      child: Container(
        height: size.height,
        decoration: BoxDecoration(
          color: c.buttonBackgroundNeutralDefault,
          borderRadius: DgaRadius.brMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < segments.length; i++)
              Semantics(
                button: true,
                selected: i == selectedIndex,
                label: segments[i],
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: DgaSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      color: i == selectedIndex
                          ? c.backgroundBlack
                          : Colors.transparent,
                    ),
                    child: Text(
                      segments[i],
                      style: size.textStyle.copyWith(
                        color: i == selectedIndex ? c.textWhite : c.textDefault,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
