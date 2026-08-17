/// How far the bottom underline extends while the field is pressed but not
/// yet focused — a short centred stub (~35% of the field width per spec) that
/// then expands to the full width once focus lands.
const double kDgaFieldPressStub = 0.35;

/// Time the stub takes to appear on pointer-down. Shorter than the
/// press → focus expansion so the feedback feels immediate.
const Duration kDgaFieldPressDuration = Duration(milliseconds: 120);

enum DgaTextInputSize {
  medium,
  large;

  /// Field (input row) height per Figma spec — excludes label + helper.
  double get fieldHeight => switch (this) {
    DgaTextInputSize.medium => 32,
    DgaTextInputSize.large => 40,
  };
}

/// Visual fill style. `default` is a Dart keyword, so the Figma "Default"
/// style is named [standard] here.
enum DgaTextInputStyle { standard, filledDarker, filledLighter }
