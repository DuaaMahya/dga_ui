import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class QuotePage extends StatelessWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaQuote',
    children: [
      sectionHeader(context, 'Large — on white'),
      sectionRow(
        DgaQuote(
          text:
              'A unified design system harmonizes the vision and organizes '
              'the websites of government entities.',
          author: 'Platforms Code',
        ),
      ),
      sectionHeader(context, 'Small'),
      sectionRow(
        const SizedBox(
          width: 480,
          child: DgaQuote(
            text:
                'Consistency and uniformity are the fundamental essence of the system.',
            author: 'DGA',
            size: DgaQuoteSize.small,
          ),
        ),
      ),
      sectionHeader(context, 'On a neutral card (whiteBackground: false)'),
      sectionRow(
        const SizedBox(
          width: 560,
          child: DgaQuote(
            text:
                'The primary color “Green” symbolizes growth, prosperity, and '
                'national solidarity.',
            author: 'Brand guidelines',
            whiteBackground: false,
          ),
        ),
      ),
    ],
  );
}
