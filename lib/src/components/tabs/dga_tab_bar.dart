import 'package:flutter/widgets.dart';

import '../../theme/dga_primitives.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

/// Height of a single tab, and therefore of the bar's content row.
///
/// 12 (padding) + 24 (icon) + 4 (gap) + 18 (label line) + 12 (padding).
const double kDgaTabBarItemHeight = 70;

const double kDgaTabBarIconSize = 24;

/// The selected tab's top rule. A hairline, per Figma's `border-t`.
const double kDgaTabBarIndicatorHeight = 1;

/// How far the badge rises above the icon's top edge.
const double kDgaTabBarBadgeRise = 3;

/// One entry in a [DgaTabBar].
class DgaTabBarItem {
  const DgaTabBarItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badge,
  });

  /// Tinted per state, so pass an [Icon] without an explicit colour — the
  /// bar supplies one through [IconTheme].
  final Widget icon;

  final String label;

  /// Swapped in while this tab is selected, for the common outline to filled
  /// change. Falls back to [icon]; the design system itself only recolours.
  final Widget? selectedIcon;

  /// Overlaid on the icon's top-trailing corner — typically a `DgaBadge`.
  final Widget? badge;
}

/// Mobile bottom navigation bar.
///
/// The caller supplies the tabs, so the count is theirs to choose: items
/// always split the bar evenly, and labels ellipsize rather than overflow
/// when a bar gets crowded. The design system draws up to five.
///
/// ```dart
/// DgaTabBar(
///   selectedIndex: _index,
///   onChanged: (i) => setState(() => _index = i),
///   items: const [
///     DgaTabBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
///     DgaTabBarItem(icon: Icon(Icons.search), label: 'Search'),
///   ],
/// )
/// ```
class DgaTabBar extends StatelessWidget {
  const DgaTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.onColor = false,
    this.safeArea = true,
  });

  final List<DgaTabBarItem> items;

  /// Null selects nothing — Figma's `Type=No Selected`.
  final int? selectedIndex;

  final ValueChanged<int> onChanged;

  /// Renders the brand-green surface with white content.
  final bool onColor;

  /// Pads for the device's bottom inset (the home indicator). The surface
  /// colour still fills that strip; only the tabs are pushed above it.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;

    Widget row = SizedBox(
      height: kDgaTabBarItemHeight,
      child: Row(
        // Tight height for every slot, so the indicator and the tap target
        // both span the full bar rather than just the content.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: _DgaTabBarSlot(
                item: items[i],
                selected: selectedIndex == i,
                onColor: onColor,
                onTap: () => onChanged(i),
              ),
            ),
        ],
      ),
    );

    if (safeArea) {
      // Bottom (and side, in landscape) insets only — the bar is anchored to
      // the bottom of the screen.
      row = SafeArea(top: false, child: row);
    }

    return Container(
      // Extends under the safe-area strip as well as behind the tabs.
      color: onColor ? c.backgroundPrimary : c.backgroundWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // A neutral hairline would be wrong over the green surface.
          if (!onColor)
            Container(
              height: kDgaTabBarIndicatorHeight,
              color: c.borderNeutralSecondary,
            ),
          row,
        ],
      ),
    );
  }
}

class _DgaTabBarSlot extends StatefulWidget {
  const _DgaTabBarSlot({
    required this.item,
    required this.selected,
    required this.onColor,
    required this.onTap,
  });

  final DgaTabBarItem item;
  final bool selected;
  final bool onColor;
  final VoidCallback onTap;

  @override
  State<_DgaTabBarSlot> createState() => _DgaTabBarSlotState();
}

class _DgaTabBarSlotState extends State<_DgaTabBarSlot> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  ({Color icon, Color label}) _foreground(DgaSemanticColors c) {
    if (widget.onColor) {
      if (widget.selected) {
        return (icon: c.iconOncolor, label: c.textOncolorPrimary);
      }
      // Figma binds the alpha ramp directly here rather than through a
      // semantic token, so these come from the primitives.
      final dim = _pressed
          ? DgaPrimitives.alphaWhite70
          : DgaPrimitives.alphaWhite50;
      return (icon: dim, label: dim);
    }
    // Pressed and selected share the brand foreground; the indicator rule is
    // the only thing that tells them apart.
    if (widget.selected || _pressed) {
      return (icon: c.iconPrimary, label: c.textPrimary);
    }
    return (icon: c.iconDefault500, label: c.textSecondaryParagraph);
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final fg = _foreground(c);

    return Semantics(
      // container:true gives each tab one node carrying the button and
      // selected state, which the label and badge below then merge into.
      // Repeating the label here instead would have it announced twice.
      container: true,
      button: true,
      selected: widget.selected,
      child: Listener(
        // Pointer events rather than a hover region, so press feedback also
        // works on touch.
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
              clipBehavior: Clip.none,
              // Without this the content is laid out loose and pinned to the
              // top-start corner instead of centred in the tab.
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DgaSpacing.md,
                    vertical: DgaSpacing.lg,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _icon(fg.icon),
                      const SizedBox(height: DgaSpacing.xs),
                      Text(
                        widget.item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: DgaTypography.textXs.medium.copyWith(
                          color: fg.label,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.selected)
                  // Drawn as an overlay rather than a real top border: a
                  // border would add a pixel and make selected tabs taller
                  // than their neighbours.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: kDgaTabBarIndicatorHeight,
                    child: ColoredBox(
                      color: widget.onColor
                          ? c.borderBackgroundWhite
                          : c.borderPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(Color color) {
    final glyph =
        (widget.selected ? widget.item.selectedIcon : null) ?? widget.item.icon;

    final icon = SizedBox(
      width: kDgaTabBarIconSize,
      height: kDgaTabBarIconSize,
      child: IconTheme.merge(
        data: IconThemeData(color: color, size: kDgaTabBarIconSize),
        child: Center(child: glyph),
      ),
    );

    if (widget.item.badge == null) return icon;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        // Anchored to the icon, not the tab: Figma pins the badge's leading
        // edge to the icon's centre line, which keeps it on the glyph at any
        // tab width and mirrors correctly under RTL.
        PositionedDirectional(
          top: -kDgaTabBarBadgeRise,
          start: kDgaTabBarIconSize / 2,
          child: widget.item.badge!,
        ),
      ],
    );
  }
}
