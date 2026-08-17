import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../settings.dart';
import '_gallery_scaffold.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onColor = GallerySettingsScope.of(context).onColor;
    // Filter out onColor style when body isn't on-color (renders invisibly on light).
    final styles = DgaTagStyle.values
        .where((s) => s != DgaTagStyle.onColor || onColor)
        .toList();

    return GalleryScaffold(
      title: 'DgaTag',
      children: [
        for (final size in DgaTagSize.values) ...[
          sectionHeader(context, 'Filled — ${size.name}'),
          sectionRow(
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in styles)
                  DgaTag(label: s.name, style: s, size: size),
              ],
            ),
          ),
        ],
        sectionHeader(context, 'Outline'),
        sectionRow(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in styles)
                DgaTag(label: s.name, style: s, outline: true),
            ],
          ),
        ),
        sectionHeader(context, 'Rounded (pill)'),
        sectionRow(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in styles)
                DgaTag(label: s.name, style: s, rounded: true),
            ],
          ),
        ),
        sectionHeader(context, 'Icon-only'),
        sectionRow(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in styles)
                DgaTag(
                  style: s,
                  leadingIcon: const Icon(Icons.circle, size: 12),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
