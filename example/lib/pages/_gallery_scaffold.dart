import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../settings.dart';
import '../widgets/settings_app_bar.dart';

/// Detail-page shell — appbar with settings, on-color body tint, and
/// the component-specific children below the title.
class GalleryScaffold extends StatelessWidget {
  const GalleryScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final s = GallerySettingsScope.of(context);
    final colors = DgaTheme.of(context).colors;
    final bodyBg = s.onColor
        ? DgaPrimitives.saFlag600Primary
        : colors.backgroundWhite;
    return Scaffold(
      appBar: SettingsAppBar(title: title),
      body: Container(
        color: bodyBg,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// Section header used inside detail pages.
Widget sectionHeader(BuildContext context, String title) {
  final s = GallerySettingsScope.of(context);
  final colors = DgaTheme.of(context).colors;
  final labelColor = s.onColor ? colors.textOncolorPrimary : colors.textDisplay;
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
    child: Text(
      title,
      style: DgaTypography.textSm.semibold.copyWith(color: labelColor),
    ),
  );
}

Widget sectionRow(Widget cells) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  child: cells,
);
