import 'package:flutter/material.dart';

enum StatusIconType {
  danger,
  error,
  info,
  question,
  success,
  triangleWarning,
  warning,
}

class StatusIcon extends StatelessWidget {
  final StatusIconType type;
  final double size;
  final Color? color;

  /// Fills the glyph's cut-out interior — it should match whatever surface the
  /// icon sits on. Defaults to white, which is only correct on a light
  /// surface: leaving it white while [color] is also light (e.g. a white
  /// neutral glyph in dark mode) renders the icon as a solid disc.
  final Color backgroundColor;

  const StatusIcon({
    super.key,
    required this.type,
    this.size = 24.0,
    this.color, // Optional
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StatusIconPainter(
        type: type,
        color: color,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class _StatusIconPainter extends CustomPainter {
  final StatusIconType type;
  final Color? color;
  final Color backgroundColor;

  _StatusIconPainter({
    required this.type,
    this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dynamically scale paths to fit whatever size is passed to the widget
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;
    final matrix = Matrix4.identity()..scale(scaleX, scaleY);

    // 1. Draw Background Layer — shows through the glyph's evenOdd cutouts,
    // so it must match the surface behind the icon.
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final bgPath = Path()..fillType = PathFillType.evenOdd;
    if (type == StatusIconType.triangleWarning) {
      _addTriangleBoundary(bgPath);
    } else {
      _addCircleBoundary(bgPath);
    }

    canvas.drawPath(bgPath.transform(matrix.storage), bgPaint);

    // 2. Draw Foreground Layer (Colored with transparent cutouts)
    final fgPaint = Paint()..style = PaintingStyle.fill;
    final fgPath = Path()..fillType = PathFillType.evenOdd;

    // Add outer boundary to create the evenOdd cutout effect
    if (type == StatusIconType.triangleWarning) {
      _addTriangleBoundary(fgPath);
    } else {
      _addCircleBoundary(fgPath);
    }

    // Determine specific cutouts & default colors
    late Color defaultColor;

    switch (type) {
      case StatusIconType.danger:
        defaultColor = const Color(0xFFB42318);
        _addExclamation(fgPath);
        break;
      case StatusIconType.warning:
        defaultColor = const Color(0xFFB54708);
        _addExclamation(fgPath);
        break;
      case StatusIconType.triangleWarning:
        defaultColor = const Color(0xFFB54708);
        _addTriangleExclamation(fgPath);
        break;
      case StatusIconType.error:
        defaultColor = const Color(0xFFB42318);
        _addCross(fgPath);
        break;
      case StatusIconType.info:
        defaultColor = const Color(0xFF175CD3);
        _addInfo(fgPath);
        break;
      case StatusIconType.success:
        defaultColor = const Color(0xFF067647);
        _addCheck(fgPath);
        break;
      case StatusIconType.question:
        defaultColor = const Color(0xFF384250);
        _addQuestion(fgPath);
        break;
    }

    // Apply the custom color if provided, otherwise use the default SVG color
    fgPaint.color = color ?? defaultColor;

    canvas.drawPath(fgPath.transform(matrix.storage), fgPaint);
  }

  @override
  bool shouldRepaint(covariant _StatusIconPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.color != color ||
      oldDelegate.backgroundColor != backgroundColor;

  // ==========================================
  // Shared Outer Boundaries
  // ==========================================

  void _addCircleBoundary(Path path) {
    path.moveTo(12, 23);
    path.cubicTo(18.0751, 23, 23, 18.0751, 23, 12);
    path.cubicTo(23, 5.92487, 18.0751, 1, 12, 1);
    path.cubicTo(5.92487, 1, 1, 5.92487, 1, 12);
    path.cubicTo(1, 18.0751, 5.92487, 23, 12, 23);
    path.close();
  }

  void _addTriangleBoundary(Path path) {
    path.moveTo(12.8575, 2.95731);
    path.cubicTo(12.4691, 2.30997, 11.5309, 2.30997, 11.1425, 2.95731);
    path.lineTo(0.9087, 20.0137);
    path.cubicTo(0.508785, 20.6802, 0.988898, 21.5282, 1.76619, 21.5282);
    path.lineTo(22.2338, 21.5282);
    path.cubicTo(23.0111, 21.5282, 23.4912, 20.6802, 23.0913, 20.0137);
    path.lineTo(12.8575, 2.95731);
    path.close();
  }

  // ==========================================
  // Inner Cutout Shapes
  // ==========================================

  void _addExclamation(Path path) {
    path.moveTo(12, 7);
    path.cubicTo(11.4477, 7, 11, 7.44772, 11, 8);
    path.lineTo(11, 12);
    path.cubicTo(11, 12.5523, 11.4477, 13, 12, 13);
    path.cubicTo(12.5523, 13, 13, 12.5523, 13, 12);
    path.lineTo(13, 8);
    path.cubicTo(13, 7.44772, 12.5523, 7, 12, 7);
    path.close();
    path.moveTo(12, 15);
    path.cubicTo(11.4477, 15, 11, 15.4477, 11, 16);
    path.cubicTo(11, 16.5523, 11.4477, 17, 12, 17);
    path.cubicTo(12.5523, 17, 13, 16.5523, 13, 16);
    path.cubicTo(13, 15.4477, 12.5523, 15, 12, 15);
    path.close();
  }

  void _addTriangleExclamation(Path path) {
    path.moveTo(12, 8.52815);
    path.cubicTo(11.4477, 8.52815, 11, 8.97587, 11, 9.52815);
    path.lineTo(11, 13.5282);
    path.cubicTo(11, 14.0804, 11.4477, 14.5282, 12, 14.5282);
    path.cubicTo(12.5523, 14.5282, 13, 14.0804, 13, 13.5282);
    path.lineTo(13, 9.52815);
    path.cubicTo(13, 8.97587, 12.5523, 8.52815, 12, 8.52815);
    path.close();
    path.moveTo(12, 16.5282);
    path.cubicTo(11.4477, 16.5282, 11, 16.9759, 11, 17.5282);
    path.cubicTo(11, 18.0804, 11.4477, 18.5282, 12, 18.5282);
    path.cubicTo(12.5523, 18.5282, 13, 18.0804, 13, 17.5282);
    path.cubicTo(13, 16.9759, 12.5523, 16.5282, 12, 16.5282);
    path.close();
  }

  void _addCross(Path path) {
    path.moveTo(8.70703, 7.29297);
    path.cubicTo(8.31665, 6.90234, 7.68335, 6.90234, 7.29297, 7.29297);
    path.cubicTo(6.90234, 7.68335, 6.90234, 8.31665, 7.29297, 8.70703);
    path.lineTo(10.5857, 12);
    path.lineTo(7.29297, 15.293);
    path.cubicTo(6.90234, 15.6833, 6.90234, 16.3167, 7.29297, 16.707);
    path.cubicTo(7.68335, 17.0977, 8.31665, 17.0977, 8.70703, 16.707);
    path.lineTo(12, 13.4143);
    path.lineTo(15.293, 16.707);
    path.cubicTo(15.6833, 17.0977, 16.3167, 17.0977, 16.707, 16.707);
    path.cubicTo(17.0977, 16.3167, 17.0977, 15.6833, 16.707, 15.293);
    path.lineTo(13.4143, 12);
    path.lineTo(16.707, 8.70703);
    path.cubicTo(17.0977, 8.31665, 17.0977, 7.68335, 16.707, 7.29297);
    path.cubicTo(16.3167, 6.90234, 15.6833, 6.90234, 15.293, 7.29297);
    path.lineTo(12, 10.5857);
    path.lineTo(8.70703, 7.29297);
    path.close();
  }

  void _addInfo(Path path) {
    path.moveTo(12, 11);
    path.cubicTo(11.4477, 11, 11, 11.4477, 11, 12);
    path.lineTo(11, 16);
    path.cubicTo(11, 16.5523, 11.4477, 17, 12, 17);
    path.cubicTo(12.5523, 17, 13, 16.5523, 13, 16);
    path.lineTo(13, 12);
    path.cubicTo(13, 11.4477, 12.5523, 11, 12, 11);
    path.close();
    path.moveTo(12, 7);
    path.cubicTo(11.4477, 7, 11, 7.44772, 11, 8);
    path.cubicTo(11, 8.55228, 11.4477, 9, 12, 9);
    path.cubicTo(12.5523, 9, 13, 8.55228, 13, 8);
    path.cubicTo(13, 7.44772, 12.5523, 7, 12, 7);
    path.close();
  }

  void _addCheck(Path path) {
    path.moveTo(7.05022, 11.1213);
    path.cubicTo(6.65969, 11.5118, 6.65969, 12.145, 7.05022, 12.5355);
    path.lineTo(9.87864, 15.364);
    path.cubicTo(10.2692, 15.7545, 10.9023, 15.7545, 11.2929, 15.364);
    path.lineTo(16.9497, 9.70711);
    path.cubicTo(17.3402, 9.31658, 17.3402, 8.68342, 16.9497, 8.29289);
    path.cubicTo(16.5592, 7.90237, 15.926, 7.90237, 15.5355, 8.29289);
    path.lineTo(10.5858, 13.2426);
    path.lineTo(8.46443, 11.1213);
    path.cubicTo(8.07391, 10.7308, 7.44074, 10.7308, 7.05022, 11.1213);
    path.close();
  }

  void _addQuestion(Path path) {
    path.moveTo(10.8169, 8.27574);
    path.cubicTo(11.2241, 8.03643, 11.7029, 7.94895, 12.1684, 8.0288);
    path.cubicTo(12.6339, 8.10865, 13.0562, 8.35067, 13.3603, 8.71201);
    path.cubicTo(13.6645, 9.07334, 13.831, 9.53067, 13.8303, 10.003);
    path.lineTo(13.8303, 10.0045);
    path.cubicTo(13.8303, 10.4736, 13.4652, 10.9627, 12.7756, 11.4224);
    path.cubicTo(12.4612, 11.632, 12.1397, 11.7935, 11.8929, 11.9032);
    path.cubicTo(11.7709, 11.9574, 11.6706, 11.9974, 11.6032, 12.0231);
    path.cubicTo(11.5696, 12.0359, 11.5443, 12.0451, 11.529, 12.0505);
    path.lineTo(11.5135, 12.056);
    path.cubicTo(10.9899, 12.2308, 10.707, 12.7969, 10.8816, 13.3207);
    path.cubicTo(11.0562, 13.8446, 11.6226, 14.1278, 12.1465, 13.9532);
    path.lineTo(11.8303, 13.0045);
    path.cubicTo(12.1465, 13.9532, 12.1478, 13.9527, 12.1478, 13.9527);
    path.lineTo(12.1493, 13.9522);
    path.lineTo(12.1532, 13.9509);
    path.lineTo(12.1642, 13.9471);
    path.lineTo(12.199, 13.935);
    path.cubicTo(12.2275, 13.9248, 12.2668, 13.9105, 12.3152, 13.8921);
    path.cubicTo(12.4118, 13.8553, 12.5459, 13.8016, 12.7052, 13.7308);
    path.cubicTo(13.0208, 13.5905, 13.4493, 13.377, 13.885, 13.0865);
    path.cubicTo(14.6952, 12.5464, 15.8298, 11.5357, 15.8303, 10.0054);
    path.cubicTo(15.8315, 9.06096, 15.4986, 8.14653, 14.8904, 7.42401);
    path.cubicTo(14.282, 6.70133, 13.4375, 6.21728, 12.5065, 6.05758);
    path.cubicTo(11.5755, 5.89789, 10.6179, 6.07285, 9.80354, 6.55148);
    path.cubicTo(8.98914, 7.03011, 8.37041, 7.78152, 8.05694, 8.67263);
    path.cubicTo(7.87367, 9.19362, 8.14744, 9.76454, 8.66843, 9.94781);
    path.cubicTo(9.18942, 10.1311, 9.76033, 9.85731, 9.94361, 9.33632);
    path.cubicTo(10.1003, 8.89077, 10.4097, 8.51506, 10.8169, 8.27574);
    path.close();
    path.moveTo(11.9103, 16.0045);
    path.cubicTo(11.358, 16.0045, 10.9103, 16.4522, 10.9103, 17.0045);
    path.cubicTo(10.9103, 17.5568, 11.358, 18.0045, 11.9103, 18.0045);
    path.lineTo(11.9203, 18.0045);
    path.cubicTo(12.4726, 18.0045, 12.9203, 17.5568, 12.9203, 17.0045);
    path.cubicTo(12.9203, 16.4522, 12.4726, 16.0045, 11.9203, 16.0045);
    path.lineTo(11.9103, 16.0045);
    path.close();
  }
}
