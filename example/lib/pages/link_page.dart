import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../settings.dart';
import '_gallery_scaffold.dart';

class LinkPage extends StatelessWidget {
  const LinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onColor = GallerySettingsScope.of(context).onColor;
    final defaultStyle = onColor ? DgaLinkStyle.onColor : DgaLinkStyle.primary;

    return GalleryScaffold(
      title: 'DgaLink',
      children: [
        sectionHeader(context, 'Sizes'),
        sectionRow(
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              DgaLink(
                onPressed: () {},
                label: 'Small link',
                size: DgaLinkSize.small,
                style: defaultStyle,
              ),
              DgaLink(
                onPressed: () {},
                label: 'Medium link',
                size: DgaLinkSize.medium,
                style: defaultStyle,
              ),
            ],
          ),
        ),
        sectionHeader(context, 'Styles'),
        sectionRow(
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              DgaLink(
                onPressed: () {},
                label: 'Primary',
                style: DgaLinkStyle.primary,
              ),
              DgaLink(
                onPressed: () {},
                label: 'Neutral',
                style: DgaLinkStyle.neutral,
              ),
              DgaLink(
                onPressed: () {},
                label: 'On-color',
                style: DgaLinkStyle.onColor,
              ),
            ],
          ),
        ),
        sectionHeader(context, 'States'),
        sectionRow(
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              DgaLink(onPressed: () {}, label: 'Default', style: defaultStyle),
              DgaLink(
                onPressed: () {},
                label: 'Visited',
                visited: true,
                style: defaultStyle,
              ),
              DgaLink(
                onPressed: () {},
                label: 'Disabled',
                disabled: true,
                style: defaultStyle,
              ),
            ],
          ),
        ),
        sectionHeader(context, 'Inline vs standalone'),
        sectionRow(
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              DgaLink(
                onPressed: () {},
                label: 'Standalone link',
                style: defaultStyle,
              ),
              DgaLink(
                onPressed: () {},
                label: 'Inline paragraph link',
                inline: true,
                style: defaultStyle,
              ),
            ],
          ),
        ),
        sectionHeader(context, 'With icons'),
        sectionRow(
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              DgaLink(
                onPressed: () {},
                label: 'External',
                trailingIcon: const Icon(Icons.open_in_new),
                style: defaultStyle,
              ),
              DgaLink(
                onPressed: () {},
                label: 'Download',
                leadingIcon: const Icon(Icons.download),
                style: defaultStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
