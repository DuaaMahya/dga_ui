import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

/// Which side of the trigger the bubble ended up on. Resolved during layout
/// from the trigger's position on screen — never set by the caller.
enum _Side { top, bottom, left, right }

/// Carries the resolved [_Side] from the layout delegate to the beak painter.
///
/// The side isn't known until layout runs, but the painter is built before
/// that. Writing it here during `performLayout` marks the beak for repaint,
/// and paint runs after layout in the same frame — so the arrow is always
/// drawn facing the right way with no extra frame.
class _TooltipGeometry extends ChangeNotifier {
  _Side _side = _Side.top;
  _Side get side => _side;

  void setSide(_Side value) {
    if (_side == value) return;
    _side = value;
    notifyListeners();
  }
}

const String _bubbleId = 'bubble';
const String _beakId = 'beak';

/// A rich tooltip that wraps [child] and shows a bubble with an optional
/// leading [icon], a [heading] title, and optional detail [message], plus a
/// beak, on hover (pointer) or long-press (touch).
///
/// Placement is fully automatic: the bubble goes on whichever side of the
/// trigger has room, is clamped inside the screen so it's never clipped, and
/// the beak is positioned from real geometry so it always points back at the
/// trigger — even when the bubble had to slide sideways to stay on screen.
class DgaTooltip extends StatefulWidget {
  const DgaTooltip({
    super.key,
    required this.child,
    this.heading,
    this.message,
    this.icon,
    this.inverted = false,
    this.maxWidth = 240,
  }) : assert(
         heading != null || message != null,
         'Tooltip needs a heading or message',
       );

  final Widget child;

  /// Bold title line.
  final String? heading;

  /// Optional detail/paragraph text under the heading.
  final String? message;

  /// Optional leading icon shown at the start, beside the heading.
  final Widget? icon;

  final bool inverted;

  /// Max content width per DGA spec (240px). Also capped to the screen width.
  final double maxWidth;

  @override
  State<DgaTooltip> createState() => _DgaTooltipState();
}

class _DgaTooltipState extends State<DgaTooltip> {
  final _controller = OverlayPortalController();
  final _childKey = GlobalKey();
  final _geometry = _TooltipGeometry();
  Timer? _autoHide;

  void _show() {
    _autoHide?.cancel();
    if (!_controller.isShowing) _controller.show();
  }

  void _hide() {
    _autoHide?.cancel();
    if (_controller.isShowing) _controller.hide();
  }

  /// Touch path: no pointer-exit to close on, so self-dismiss.
  void _showTemporarily() {
    _show();
    _autoHide = Timer(const Duration(seconds: 3), _hide);
  }

  @override
  void dispose() {
    _autoHide?.cancel();
    _geometry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final bg = widget.inverted
        ? c.tooltipBackgroundDark
        : c.tooltipBackgroundLight;

    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (overlayContext) {
        final box = _childKey.currentContext?.findRenderObject() as RenderBox?;
        if (box == null || !box.hasSize) return const SizedBox.shrink();
        final targetRect = box.localToGlobal(Offset.zero) & box.size;

        return Positioned.fill(
          child: IgnorePointer(
            child: CustomMultiChildLayout(
              delegate: _TooltipLayoutDelegate(
                targetRect: targetRect,
                geometry: _geometry,
              ),
              children: [
                LayoutId(
                  id: _bubbleId,
                  child: _Bubble(
                    colors: c,
                    heading: widget.heading,
                    message: widget.message,
                    icon: widget.icon,
                    inverted: widget.inverted,
                    maxWidth: widget.maxWidth,
                  ),
                ),
                LayoutId(
                  id: _beakId,
                  child: CustomPaint(
                    painter: _BeakPainter(color: bg, geometry: _geometry),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: KeyedSubtree(
        key: _childKey,
        child: MouseRegion(
          onEnter: (_) => _show(),
          onExit: (_) => _hide(),
          child: GestureDetector(
            onLongPress: _showTemporarily,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Lays out the bubble on whichever side of the target has room, clamps it
/// inside the screen, then points the beak back at the target's centre.
class _TooltipLayoutDelegate extends MultiChildLayoutDelegate {
  _TooltipLayoutDelegate({required this.targetRect, required this.geometry});

  final Rect targetRect;
  final _TooltipGeometry geometry;

  static const double _margin = 8;
  static const double _gap = 6;

  /// Half-extent of the beak triangle: 16x8 pointing up/down, 8x16 sideways.
  static const double _beak = 8;

  /// Keeps the beak off the bubble's rounded corners.
  static const double _corner = 8;

  @override
  void performLayout(Size size) {
    final bubble = layoutChild(
      _bubbleId,
      BoxConstraints.loose(
        Size(
          math.max(0, size.width - _margin * 2),
          math.max(0, size.height - _margin * 2),
        ),
      ),
    );

    final side = _resolveSide(size, bubble);
    geometry.setSide(side);

    final vertical = side == _Side.top || side == _Side.bottom;
    final offset = _gap + _beak;

    double x;
    double y;
    if (vertical) {
      x = targetRect.center.dx - bubble.width / 2;
      y = side == _Side.top
          ? targetRect.top - bubble.height - offset
          : targetRect.bottom + offset;
    } else {
      x = side == _Side.left
          ? targetRect.left - bubble.width - offset
          : targetRect.right + offset;
      y = targetRect.center.dy - bubble.height / 2;
    }

    // Clamp inside the screen so content is always readable. This is what
    // used to leave the beak pointing at nothing — the beak below now
    // compensates by tracking the target instead of the bubble's centre.
    x = x.clamp(
      _margin,
      math.max(_margin, size.width - bubble.width - _margin),
    );
    y = y.clamp(
      _margin,
      math.max(_margin, size.height - bubble.height - _margin),
    );
    positionChild(_bubbleId, Offset(x, y));

    final beak = layoutChild(
      _beakId,
      BoxConstraints.tight(
        vertical ? const Size(_beak * 2, _beak) : const Size(_beak, _beak * 2),
      ),
    );

    double bx;
    double by;
    if (vertical) {
      final lo = x + _corner;
      final hi = x + bubble.width - _corner - beak.width;
      bx = (targetRect.center.dx - beak.width / 2).clamp(lo, math.max(lo, hi));
      by = side == _Side.top ? y + bubble.height : y - beak.height;
    } else {
      final lo = y + _corner;
      final hi = y + bubble.height - _corner - beak.height;
      by = (targetRect.center.dy - beak.height / 2).clamp(lo, math.max(lo, hi));
      bx = side == _Side.left ? x + bubble.width : x - beak.width;
    }
    positionChild(_beakId, Offset(bx, by));
  }

  /// Prefers above, then below, then the horizontal sides. Falls back to
  /// whichever side has the most room when the bubble fits nowhere.
  _Side _resolveSide(Size size, Size bubble) {
    final above = targetRect.top;
    final below = size.height - targetRect.bottom;
    final toLeft = targetRect.left;
    final toRight = size.width - targetRect.right;

    final needV = bubble.height + _gap + _beak + _margin;
    final needH = bubble.width + _gap + _beak + _margin;

    if (above >= needV) return _Side.top;
    if (below >= needV) return _Side.bottom;
    if (toRight >= needH) return _Side.right;
    if (toLeft >= needH) return _Side.left;

    final best = math.max(math.max(above, below), math.max(toLeft, toRight));
    if (best == above) return _Side.top;
    if (best == below) return _Side.bottom;
    if (best == toRight) return _Side.right;
    return _Side.left;
  }

  @override
  bool shouldRelayout(_TooltipLayoutDelegate old) =>
      old.targetRect != targetRect;
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.colors,
    required this.heading,
    required this.message,
    required this.icon,
    required this.inverted,
    required this.maxWidth,
  });

  final DgaSemanticColors colors;
  final String? heading;
  final String? message;
  final Widget? icon;
  final bool inverted;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final bg = inverted
        ? colors.tooltipBackgroundDark
        : colors.tooltipBackgroundLight;
    final headingColor = inverted
        ? colors.tooltipTextHeadingDark
        : colors.tooltipTextHeadingLight;
    final paragraphColor = inverted
        ? colors.tooltipTextParagraphDark
        : colors.tooltipTextParagraphLight;

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Text(
            heading!,
            style: DgaTypography.textXs.semibold.copyWith(color: headingColor),
          ),
        if (heading != null && message != null)
          const SizedBox(height: DgaSpacing.xs),
        if (message != null)
          Text(
            message!,
            style: DgaTypography.textXs.regular.copyWith(color: paragraphColor),
          ),
      ],
    );

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(DgaSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: DgaRadius.brSm,
        boxShadow: DgaShadows.lg,
      ),
      child: icon == null
          ? textColumn
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconTheme.merge(
                  data: IconThemeData(color: headingColor, size: 16),
                  child: icon!,
                ),
                const SizedBox(width: DgaSpacing.md),
                Flexible(child: textColumn),
              ],
            ),
    );
  }
}

class _BeakPainter extends CustomPainter {
  _BeakPainter({required this.color, required this.geometry})
    : super(repaint: geometry);

  final Color color;
  final _TooltipGeometry geometry;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    switch (geometry.side) {
      case _Side.top: // bubble sits above → beak points down
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width / 2, size.height);
        break;
      case _Side.bottom: // points up
        path.moveTo(size.width / 2, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height);
        break;
      case _Side.left: // points right
        path.moveTo(0, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height / 2);
        break;
      case _Side.right: // points left
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height / 2);
        break;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BeakPainter old) => old.color != color;
}
