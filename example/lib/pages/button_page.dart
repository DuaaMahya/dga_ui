import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../settings.dart';
import '_gallery_scaffold.dart';

typedef _ButtonFactory =
    DgaButton Function({
      Key? key,
      required VoidCallback onPressed,
      String? label,
      Widget? leadingIcon,
      Widget? trailingIcon,
      DgaButtonSize size,
      bool destructive,
      bool disabled,
      bool onColor,
      bool selected,
      FocusNode? focusNode,
      bool autofocus,
      String? tooltip,
    });

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  List<Widget> _forSize(
    _ButtonFactory factory,
    DgaButtonSize size,
    bool onColor,
  ) => [
    factory(
      onPressed: () {},
      label: 'Save',
      size: size,
      onColor: onColor,
      leadingIcon: const Icon(Icons.check, size: 16),
    ),
    factory(
      onPressed: () {},
      label: 'Delete',
      size: size,
      destructive: true,
      onColor: onColor,
    ),
    factory(
      onPressed: () {},
      label: 'Off',
      size: size,
      disabled: true,
      onColor: onColor,
    ),
    factory(
      onPressed: () {},
      size: size,
      leadingIcon: const Icon(Icons.close, size: 16),
      tooltip: 'Close',
      onColor: onColor,
    ),
  ];

  Widget _triplet(BuildContext context, String name, _ButtonFactory factory) {
    final onColor = GallerySettingsScope.of(context).onColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(context, '$name — small'),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _forSize(factory, DgaButtonSize.small, onColor),
          ),
        ),
        sectionHeader(context, '$name — medium'),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _forSize(factory, DgaButtonSize.medium, onColor),
          ),
        ),
        sectionHeader(context, '$name — large'),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _forSize(factory, DgaButtonSize.large, onColor),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaButton',
    children: [
      _triplet(context, 'Primary', DgaButton.primary),
      _triplet(context, 'Neutral', DgaButton.neutral),
      _triplet(context, 'Secondary-Solid', DgaButton.secondarySolid),
      _triplet(context, 'Secondary-Outline', DgaButton.secondaryOutline),
      _triplet(context, 'Subtle', DgaButton.subtle),
      _triplet(context, 'Transparent', DgaButton.transparent),
    ],
  );
}
