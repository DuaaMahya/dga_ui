import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class MenuButtonPage extends StatelessWidget {
  const MenuButtonPage({super.key});

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaMenuButton',
    children: [
      for (final size in DgaButtonSize.values) ...[
        sectionHeader(context, size.name),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DgaMenuButton.primary(
                onPressed: () {},
                label: 'Filter',
                size: size,
              ),
              DgaMenuButton.neutral(
                onPressed: () {},
                label: 'Sort',
                size: size,
              ),
              DgaMenuButton.secondarySolid(
                onPressed: () {},
                label: 'Options',
                size: size,
              ),
              DgaMenuButton.secondaryOutline(
                onPressed: () {},
                label: 'Actions',
                size: size,
              ),
              DgaMenuButton.subtle(onPressed: () {}, label: 'View', size: size),
              DgaMenuButton.transparent(
                onPressed: () {},
                label: 'More',
                size: size,
                chevronOpen: true,
              ),
              DgaMenuButton.primary(
                onPressed: () {},
                label: 'Disabled',
                size: size,
                disabled: true,
              ),
            ],
          ),
        ),
      ],
    ],
  );
}
