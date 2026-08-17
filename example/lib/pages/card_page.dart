import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int _selected = 0;

  Widget _sample(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const DgaAvatar.initials('DM', size: 40),
            const SizedBox(width: 12),
            Text(
              'Card title',
              style: DgaTypography.textMd.semibold.copyWith(
                color: c.textDisplay,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'A reusable surface — pass any child, pick an effect, and opt into tap or selection.',
          style: DgaTypography.textSm.regular.copyWith(
            color: c.textSecondaryParagraph,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaCard',
    children: [
      sectionHeader(context, 'Effects'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 300,
              child: DgaCard(
                effect: DgaCardEffect.shadow,
                text: 'Shadow Effect',
                helperText:
                    "A reusable surface — pass any child, pick an effect, and opt into tap or selection.",
              ),
            ),
            SizedBox(
              width: 300,
              child: DgaCard(
                effect: DgaCardEffect.stroke,
                text: 'Stroke Effect',
                helperText:
                    "A reusable surface — pass any child, pick an effect, and opt into tap or selection.",
              ),
            ),
            SizedBox(
              width: 300,
              child: DgaCard(
                effect: DgaCardEffect.none,
                text: 'No Effect',
                helperText:
                    "A reusable surface — pass any child, pick an effect, and opt into tap or selection.",
              ),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Selectable (tap to select)'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (var i = 0; i < 3; i++)
              SizedBox(
                width: 220,
                child: DgaCard(
                  effect: DgaCardEffect.stroke,
                  selected: _selected == i,
                  onTap: () => setState(() => _selected = i),
                  child: Text(
                    'Plan ${i + 1}',
                    style: DgaTypography.textMd.semibold.copyWith(
                      color: DgaTheme.of(context).colors.textDisplay,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      sectionHeader(context, 'Expandable (compose with DgaAccordion)'),
      sectionRow(
        SizedBox(
          width: 420,
          child: DgaCard(
            effect: DgaCardEffect.stroke,
            padding: EdgeInsets.zero,
            child: DgaAccordion(
              title: 'Details',
              isFirst: true,
              child: Text(
                'Cards stay generic; expandable behavior comes from composing an accordion inside.',
                style: DgaTypography.textSm.regular.copyWith(
                  color: DgaTheme.of(context).colors.textPrimaryParagraph,
                ),
              ),
            ),
          ),
        ),
      ),
      sectionHeader(context, 'Disabled'),
      sectionRow(
        SizedBox(
          width: 300,
          child: DgaCard(disabled: true, onTap: () {}, child: _sample(context)),
        ),
      ),
    ],
  );
}
