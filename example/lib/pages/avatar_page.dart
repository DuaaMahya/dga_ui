import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});

  static const _sizes = [24.0, 32.0, 40.0, 48.0, 64.0, 80.0, 120.0];

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaAvatar',
    children: [
      sectionHeader(context, 'Initials — all sizes (circular)'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [for (final s in _sizes) DgaAvatar.initials('DM', size: s)],
        ),
      ),
      sectionHeader(context, 'Icon fallback (square)'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final s in _sizes)
              DgaAvatar.icon(const Icon(Icons.person), size: s, square: true),
          ],
        ),
      ),
      sectionHeader(context, 'Circular vs square'),
      sectionRow(
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DgaAvatar.initials('AB', size: 64),
            DgaAvatar.initials('AB', size: 64, square: true),
            DgaAvatar.icon(Icon(Icons.groups), size: 64),
            DgaAvatar.icon(Icon(Icons.groups), size: 64, square: true),
          ],
        ),
      ),
    ],
  );
}
