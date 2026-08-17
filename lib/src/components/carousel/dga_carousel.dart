import 'package:flutter/widgets.dart';

import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';

enum DgaCarouselDotSize {
  small,
  medium,
  large;

  double get diameter => switch (this) {
    DgaCarouselDotSize.small => 8,
    DgaCarouselDotSize.medium => 12,
    DgaCarouselDotSize.large => 16,
  };
}

/// The dot indicator row for a carousel. Selected dot is brand-green, the
/// rest are neutral. Tapping a dot (when [onSelected] is set) jumps to it.
class DgaCarouselDots extends StatelessWidget {
  const DgaCarouselDots({
    super.key,
    required this.count,
    required this.selected,
    this.size = DgaCarouselDotSize.medium,
    this.onSelected,
  }) : assert(count > 0),
       assert(selected >= 0 && selected < count);

  final int count;
  final int selected;
  final DgaCarouselDotSize size;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: DgaSpacing.md),
          GestureDetector(
            onTap: onSelected == null ? null : () => onSelected!(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size.diameter,
              height: size.diameter,
              decoration: BoxDecoration(
                color: i == selected
                    ? c.backgroundPrimary
                    : c.backgroundNeutral200,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A swipeable carousel of [items] with the DGA dot controls below.
class DgaCarousel extends StatefulWidget {
  const DgaCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.dotSize = DgaCarouselDotSize.medium,
    this.onPageChanged,
  }) : assert(items.length > 0);

  final List<Widget> items;
  final double height;
  final DgaCarouselDotSize dotSize;
  final ValueChanged<int>? onPageChanged;

  @override
  State<DgaCarousel> createState() => _DgaCarouselState();
}

class _DgaCarouselState extends State<DgaCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    _controller.animateToPage(
      i,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView(
            controller: _controller,
            onPageChanged: (i) {
              setState(() => _index = i);
              widget.onPageChanged?.call(i);
            },
            children: widget.items,
          ),
        ),
        const SizedBox(height: DgaSpacing.xl),
        DgaCarouselDots(
          count: widget.items.length,
          selected: _index,
          size: widget.dotSize,
          onSelected: _goTo,
        ),
      ],
    );
  }
}
