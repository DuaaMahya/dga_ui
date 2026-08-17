import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../settings.dart';
import '_gallery_scaffold.dart';

class CloseButtonPage extends StatelessWidget {
  const CloseButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onColor = GallerySettingsScope.of(context).onColor;
    return GalleryScaffold(
      title: 'DgaCloseButton',
      children: [
        sectionHeader(context, 'All sizes'),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final s in DgaCloseButtonSize.values)
                DgaCloseButton(onPressed: () {}, size: s, onColor: onColor),
            ],
          ),
        ),
        sectionHeader(context, 'Disabled'),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final s in DgaCloseButtonSize.values)
                DgaCloseButton(
                  onPressed: () {},
                  size: s,
                  onColor: onColor,
                  disabled: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
