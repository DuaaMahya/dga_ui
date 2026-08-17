import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class AccordionPage extends StatelessWidget {
  const AccordionPage({super.key});

  static const _body =
      'The accordion component delivers large amounts of content in a small '
      'space through progressive disclosure. The user gets key details about '
      'the underlying content and can choose to expand that content.';

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaAccordion',
    children: [
      sectionHeader(
        context,
        'List — first item has no top divider; hover / press / focus states',
      ),
      for (final size in DgaAccordionSize.values)
        sectionRow(
          SizedBox(
            width: 420,
            child: Column(
              children: [
                for (var i = 0; i < 4; i++)
                  DgaAccordion(
                    title: 'Accordion Title',
                    size: size,
                    isFirst: i == 0,
                    initiallyExpanded: i == 3,
                    child: const Text(_body),
                  ),
                const DgaAccordion(
                  title: 'Accordion Title',
                  disabled: true,
                  child: Text(_body),
                ),
              ],
            ),
          ),
        ),
      sectionHeader(context, 'Leading chevron + leading icon'),
      sectionRow(
        SizedBox(
          width: 420,
          child: DgaAccordion(
            title: 'Icon on the start',
            iconLeading: true,
            isFirst: true,
            leadingIcon: const Icon(Icons.info_outline),
            child: const Text(_body),
          ),
        ),
      ),
    ],
  );
}
