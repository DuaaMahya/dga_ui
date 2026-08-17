import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({super.key});

  Widget _slide(BuildContext context, String label, Color color) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    alignment: Alignment.center,
    decoration: BoxDecoration(color: color, borderRadius: DgaRadius.brLg),
    child: Text(
      label,
      style: DgaTypography.displayXs.medium.copyWith(
        color: DgaTheme.of(context).colors.textOncolorPrimary,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaCarousel',
    children: [
      sectionHeader(context, 'Carousel — swipe or tap a dot'),
      sectionRow(
        SizedBox(
          width: 420,
          child: DgaCarousel(
            height: 180,
            items: [
              _slide(context, 'Slide 1', DgaPrimitives.saFlag600Primary),
              _slide(context, 'Slide 2', DgaPrimitives.saFlag800),
              _slide(
                context,
                'Slide 3',
                DgaTheme.of(context).colors.backgroundSaFlag,
              ),
            ],
          ),
        ),
      ),
      sectionHeader(context, 'Dot sizes'),
      sectionRow(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DgaCarouselDots(
              count: 4,
              selected: 1,
              size: DgaCarouselDotSize.small,
            ),
            SizedBox(height: 16),
            DgaCarouselDots(
              count: 4,
              selected: 1,
              size: DgaCarouselDotSize.medium,
            ),
            SizedBox(height: 16),
            DgaCarouselDots(
              count: 4,
              selected: 1,
              size: DgaCarouselDotSize.large,
            ),
          ],
        ),
      ),
    ],
  );
}
