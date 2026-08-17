import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _rating = 3;

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaRatingStar',
    children: [
      sectionHeader(context, 'Interactive (tap to rate) — $_rating / 5'),
      sectionRow(
        DgaRatingBar(
          value: _rating.toDouble(),
          size: DgaRatingSize.large,
          onChanged: (v) => setState(() => _rating = v),
        ),
      ),
      sectionHeader(context, 'Sizes'),
      sectionRow(
        const Wrap(
          spacing: 24,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DgaRatingBar(value: 3.5, size: DgaRatingSize.small),
            DgaRatingBar(value: 3.5, size: DgaRatingSize.medium),
            DgaRatingBar(value: 3.5, size: DgaRatingSize.large),
          ],
        ),
      ),
      sectionHeader(context, 'Styles (gold vs brand) + half stars'),
      sectionRow(
        const Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            DgaRatingBar(value: 2.5, style: DgaRatingStyle.defaultGold),
            DgaRatingBar(value: 2.5, style: DgaRatingStyle.brand),
          ],
        ),
      ),
    ],
  );
}
