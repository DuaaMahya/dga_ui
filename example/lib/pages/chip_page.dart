import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../settings.dart';
import '_gallery_scaffold.dart';

class ChipPage extends StatefulWidget {
  const ChipPage({super.key});

  @override
  State<ChipPage> createState() => _ChipPageState();
}

class _ChipPageState extends State<ChipPage> {
  final _selected = <String>{'Design'};
  final _removable = <String>['Alpha', 'Beta', 'Gamma'];

  @override
  Widget build(BuildContext context) {
    final onColor = GallerySettingsScope.of(context).onColor;
    return GalleryScaffold(
      title: 'DgaChip',
      children: [
        sectionHeader(context, 'Sizes (neutral)'),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final s in DgaChipSize.values)
                DgaChip(
                  onPressed: () {},
                  label: s.name,
                  size: s,
                  onColor: onColor,
                ),
            ],
          ),
        ),
        sectionHeader(context, 'Styles'),
        sectionRow(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DgaChip(
                onPressed: () {},
                label: 'Neutral',
                style: DgaChipStyle.neutral,
                onColor: onColor,
              ),
              DgaChip(
                onPressed: () {},
                label: 'Primary',
                style: DgaChipStyle.primary,
                onColor: onColor,
              ),
              DgaChip(
                onPressed: () {},
                label: 'Rounded',
                rounded: true,
                onColor: onColor,
              ),
              DgaChip(
                onPressed: () {},
                label: 'Disabled',
                disabled: true,
                onColor: onColor,
              ),
            ],
          ),
        ),
        sectionHeader(context, 'Selectable filter row'),
        sectionRow(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in [
                'Design',
                'Engineering',
                'Product',
                'Marketing',
              ])
                DgaChip(
                  onPressed: () => setState(() {
                    _selected.contains(tag)
                        ? _selected.remove(tag)
                        : _selected.add(tag);
                  }),
                  label: tag,
                  selected: _selected.contains(tag),
                  rounded: true,
                  onColor: onColor,
                ),
            ],
          ),
        ),
        sectionHeader(context, 'Removable chips'),
        sectionRow(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in _removable)
                DgaChip(
                  onPressed: () {},
                  label: tag,
                  onDeleted: () => setState(() => _removable.remove(tag)),
                  onColor: onColor,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
