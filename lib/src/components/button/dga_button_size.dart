import 'package:dga_ui/dga_ui.dart';

enum DgaButtonSize {
  small,
  medium,
  large;

  /// Fixed pixel height for this size, per Figma spec.
  /// The button paints as an exact-height box — no minHeight, no growth.
  double get height => switch (this) {
    DgaButtonSize.small => DgaSpacing.xl3,
    DgaButtonSize.medium => DgaSpacing.xl4,
    DgaButtonSize.large => DgaSpacing.xl5,
  };
}
