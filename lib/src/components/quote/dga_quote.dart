import 'package:flutter/widgets.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

enum DgaQuoteSize { small, large }

/// A pull-quote block: a brand-green start accent bar, the quote text, and an
/// optional author line. Non-white background gives it a neutral-50 card with
/// rounded corners.
class DgaQuote extends StatelessWidget {
  const DgaQuote({
    super.key,
    required this.text,
    this.author,
    this.size = DgaQuoteSize.large,
    this.whiteBackground = true,
  });

  final String text;
  final String? author;
  final DgaQuoteSize size;
  final bool whiteBackground;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;

    final quoteStyle =
        (size == DgaQuoteSize.large
                ? DgaTypography.displayXs.medium
                : DgaTypography.textXl.regular)
            .copyWith(color: c.textDefault);

    // IntrinsicHeight gives the Row a finite height (the text block's height)
    // so the start accent bar can stretch to match it. Without it, `stretch`
    // would force the width-4 bar to infinite height in a scrolling list.
    final content = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start accent bar (flips under RTL).
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: c.backgroundPrimary,
              borderRadius: DgaRadius.brFull,
            ),
          ),
          const SizedBox(width: DgaSpacing.xl),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: quoteStyle),
                if (author != null) ...[
                  const SizedBox(height: DgaSpacing.lg),
                  Text(
                    author!,
                    style: DgaTypography.textLg.semibold.copyWith(
                      color: c.textSecondaryParagraph,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (whiteBackground) return content;

    return Container(
      padding: const EdgeInsets.all(DgaSpacing.xl3),
      decoration: BoxDecoration(
        color: c.backgroundNeutral50,
        borderRadius: DgaRadius.brLg,
      ),
      child: content,
    );
  }
}
