import 'package:flutter/widgets.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

/// User avatar — image, initials, or a fallback icon; circular or square.
///
/// Use one of the named constructors:
/// - `DgaAvatar.image(...)`
/// - `DgaAvatar.initials(...)`
/// - `DgaAvatar.icon(...)`
class DgaAvatar extends StatelessWidget {
  const DgaAvatar._({
    super.key,
    this.image,
    this.initials,
    this.icon,
    this.size = 40,
    this.square = false,
  });

  /// Circular/square user photo.
  const DgaAvatar.image(
    ImageProvider image, {
    Key? key,
    double size = 40,
    bool square = false,
  }) : this._(key: key, image: image, size: size, square: square);

  /// Text initials (e.g. "DM"); shown centered on a neutral background.
  const DgaAvatar.initials(
    String initials, {
    Key? key,
    double size = 40,
    bool square = false,
  }) : this._(key: key, initials: initials, size: size, square: square);

  /// Fallback icon on a neutral background.
  const DgaAvatar.icon(
    Widget icon, {
    Key? key,
    double size = 40,
    bool square = false,
  }) : this._(key: key, icon: icon, size: size, square: square);

  final ImageProvider? image;
  final String? initials;
  final Widget? icon;
  final double size;
  final bool square;

  double get _initialsFontSize => size * 0.4;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final radius = square
        ? BorderRadius.circular(size * 0.22)
        : DgaRadius.brFull;

    Widget child;
    if (image != null) {
      child = Image(
        image: image!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else if (initials != null) {
      child = Center(
        child: Text(
          initials!,
          style: DgaTypography.textMd.medium.copyWith(
            color: c.textDefault,
            fontSize: _initialsFontSize,
          ),
        ),
      );
    } else {
      child = Center(
        child: IconTheme.merge(
          data: IconThemeData(color: c.textDefault, size: size * 0.5),
          child: icon!,
        ),
      );
    }

    return Semantics(
      image: image != null,
      label: initials,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: c.backgroundNeutral100,
          borderRadius: radius,
        ),
        child: child,
      ),
    );
  }
}
