import 'custome_track.dart';
import 'package:flutter/material.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaSliderSize {
  small,
  medium;

  double get controlSize => switch (this) {
    DgaSliderSize.small => 8,
    DgaSliderSize.medium => 12,
  };

  double get horizontalPadding => switch (this) {
    DgaSliderSize.small => DgaSpacing.md, // 8
    DgaSliderSize.medium => DgaSpacing.lg, // 12
  };
}

class DgaSlider extends StatelessWidget {
  final String? label;
  final String? helpText;

  final bool _isRange;
  final DgaSliderSize size;
  final double min;
  final double max;
  final bool showMinText;
  final bool showMaxText;

  // Single slider properties
  final double? value;
  final bool showValueText;
  final ValueChanged<double>? onChanged;

  // Range slider properties
  final RangeValues? rangeValues;
  final ValueChanged<RangeValues>? onRangeChanged;

  /// Standard single-value slider.
  const DgaSlider({
    super.key,
    this.label,
    this.helpText,
    this.size = DgaSliderSize.small,
    this.min = 0.0,
    this.max = 100.0,
    required this.value,
    this.showValueText = false,
    this.onChanged,
  }) : _isRange = false,
       rangeValues = null,
       onRangeChanged = null,
       showMinText = false,
       showMaxText = false;

  const DgaSlider.range({
    super.key,
    this.label,
    this.helpText,
    this.size = DgaSliderSize.small,
    this.min = 0.0,
    this.max = 100.0,
    this.showMinText = false,
    this.showMaxText = false,
    required RangeValues this.rangeValues,
    required this.onRangeChanged,
  }) : _isRange = true,
       value = 0,
       onChanged = null,
       showValueText = false;

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;

    final labelStyle =
        (size == DgaSliderSize.medium
                ? DgaTypography.textMd.regular
                : DgaTypography.textSm.regular)
            .copyWith(color: colors.textDefault);

    // Colors matched to the design
    final activeColor = colors.backgroundPrimary;
    final inactiveColor = colors.backgroundNeutral100;
    final textColor = colors.textPrimaryParagraph;
    final helpTextColor = colors.textPrimaryParagraph;
    return Semantics(
      label: label,
      slider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Optional Label
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 10.0),
              child: Text(label!, style: labelStyle),
            ),

          // Slider Row
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor,
              inactiveTrackColor: inactiveColor,
              thumbColor: activeColor,
              trackHeight: 4.0,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
              trackShape: const CustomEqualTrackShape(),
              rangeTrackShape: const CustomEqualRangeTrackShape(),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: size.controlSize,
              ),
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: size.controlSize,
              ),
            ),
            child: Row(
              children: [
                // Show starting value ONLY if it's a range slider
                if (_isRange) ...[
                  if (showMinText)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        rangeValues!.start.toInt().toString(),
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                    ),
                ],

                Expanded(
                  child: _isRange
                      ? RangeSlider(
                          values: rangeValues!,
                          min: min,
                          max: max,
                          onChanged: onRangeChanged,
                        )
                      : Slider(
                          value: value!,
                          min: min,
                          max: max,
                          onChanged: onChanged,
                        ),
                ),

                // End value is always shown on the right
                if (showMaxText || showValueText)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      _isRange
                          ? rangeValues!.end.toInt().toString()
                          : value!.toInt().toString(),
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                  ),
              ],
            ),
          ),

          // Optional Help Text
          if (helpText != null)
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 10.0),
              child: Row(
                children: [
                  Icon(Icons.help_outline, size: 18, color: helpTextColor),
                  const SizedBox(width: 6),
                  Text(
                    helpText!,
                    style: TextStyle(fontSize: 13, color: helpTextColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
