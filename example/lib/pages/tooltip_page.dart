import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class TooltipPage extends StatelessWidget {
  const TooltipPage({super.key});

  Widget _anchor(String label) =>
      DgaButton.secondaryOutline(onPressed: () {}, label: label);

  static const _msg =
      'Max width of tooltips is 240px — text will wrap automatically.';

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaTooltip',
    children: [
      sectionHeader(context, 'Automatic placement (hover or long-press)'),
      sectionRow(
        Text(
          'The bubble picks whichever side has room and the beak always '
          'points back at the trigger — try the edge anchors below.',
          style: DgaTypography.textSm.regular.copyWith(
            color: DgaTheme.of(context).colors.textSecondaryParagraph,
          ),
        ),
      ),
      sectionRow(
        Wrap(
          spacing: 32,
          runSpacing: 32,
          children: [
            DgaTooltip(
              heading: 'Tooltip title',
              message: _msg,
              icon: const Icon(Icons.help_outline),
              child: _anchor('Centre'),
            ),
            DgaTooltip(
              heading: 'Title only',
              icon: const Icon(Icons.info_outline),
              child: _anchor('Title + icon'),
            ),
            DgaTooltip(
              message: 'Just a short hint, no title.',
              child: _anchor('Detail only'),
            ),
            DgaTooltip(
              heading: 'Tooltip title',
              message: 'Inverted dark bubble on a light surface.',
              icon: const Icon(Icons.help_outline),
              inverted: true,
              child: _anchor('Inverted'),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Screen edges — bubble slides, beak follows'),
      sectionRow(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DgaTooltip(
              heading: 'Near the start edge',
              message:
                  'The bubble stays fully on-screen and the beak still points '
                  'at this button.',
              icon: const Icon(Icons.help_outline),
              child: _anchor('Start'),
            ),
            DgaTooltip(
              heading: 'Near the end edge',
              message:
                  'The bubble stays fully on-screen and the beak still points '
                  'at this button.',
              icon: const Icon(Icons.help_outline),
              child: _anchor('End'),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Top of the page — flips below the trigger'),
      sectionRow(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DgaTooltip(
              heading: 'No room above',
              message:
                  'With the trigger near the top of the screen the bubble '
                  'flips underneath and the beak points up.',
              icon: const Icon(Icons.help_outline),
              child: _anchor('Top-start'),
            ),
            DgaTooltip(
              heading: 'No room above',
              message:
                  'With the trigger near the top of the screen the bubble '
                  'flips underneath and the beak points up.',
              icon: const Icon(Icons.help_outline),
              child: _anchor('Top-end'),
            ),
          ],
        ),
      ),
    ],
  );
}
