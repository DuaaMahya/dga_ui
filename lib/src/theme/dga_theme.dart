import 'package:flutter/widgets.dart';

import 'dga_semantic_colors.dart';

/// InheritedWidget wrapper exposing the DGA design tokens.
///
/// Wrap the app in [DgaTheme] so any descendant can call
/// `DgaTheme.of(context)` to read semantic tokens without prop-drilling.
class DgaTheme extends InheritedWidget {
  const DgaTheme({
    super.key,
    required super.child,
    this.data = const DgaThemeData.light(),
  });

  final DgaThemeData data;

  static DgaThemeData of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<DgaTheme>();
    return inherited?.data ?? const DgaThemeData.light();
  }

  @override
  bool updateShouldNotify(DgaTheme oldWidget) => data != oldWidget.data;
}

/// Immutable bundle of DGA design tokens. Picks the light or dark
/// [DgaSemanticColors] set — every other token layer (spacing, radius,
/// typography, shadows) is mode-independent and read via its static class.
@immutable
class DgaThemeData {
  const DgaThemeData.light() : colors = const DgaSemanticColors.light();
  const DgaThemeData.dark() : colors = const DgaSemanticColors.dark();

  final DgaSemanticColors colors;

  @override
  bool operator ==(Object other) =>
      other is DgaThemeData && other.colors.runtimeType == colors.runtimeType;

  @override
  int get hashCode => colors.runtimeType.hashCode;
}
