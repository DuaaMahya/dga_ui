import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../settings.dart';
import '_gallery_scaffold.dart';

class FloatingButtonPage extends StatelessWidget {
  const FloatingButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onColor = GallerySettingsScope.of(context).onColor;
    return GalleryScaffold(
      title: 'DgaFloatingButton',
      children: [
        for (final size in DgaFloatingButtonSize.values) ...[
          sectionHeader(context, 'Icon-only — ${size.name}'),
          sectionRow(
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DgaFloatingButton.primaryBrand(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  size: size,
                  onColor: onColor,
                ),
                DgaFloatingButton.primaryNeutral(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  size: size,
                  onColor: onColor,
                ),
                DgaFloatingButton.secondarySolid(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  size: size,
                  onColor: onColor,
                ),
                DgaFloatingButton.primaryBrand(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  size: size,
                  onColor: onColor,
                  disabled: true,
                ),
              ],
            ),
          ),
          sectionHeader(context, 'Extended — ${size.name}'),
          sectionRow(
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DgaFloatingButton.primaryBrand(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: 'Compose',
                  size: size,
                  onColor: onColor,
                ),
                DgaFloatingButton.primaryNeutral(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: 'Edit',
                  size: size,
                  onColor: onColor,
                ),
                DgaFloatingButton.secondarySolid(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: 'Share',
                  size: size,
                  onColor: onColor,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
