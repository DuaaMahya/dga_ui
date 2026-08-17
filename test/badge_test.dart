import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {DgaThemeData? theme}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group('DgaBadge', () {
    testWidgets('dot is a bare 12x12 with no label', (tester) async {
      await tester.pumpWidget(_wrap(const DgaBadge.dot()));

      expect(tester.getSize(find.byType(DgaBadge)), const Size(12, 12));
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('a single digit is 16 tall and never narrower', (tester) async {
      await tester.pumpWidget(_wrap(const DgaBadge.count(5)));

      expect(find.text('5'), findsOneWidget);

      final size = tester.getSize(find.byType(DgaBadge));
      expect(size.height, 16);
      // Figma's 16x16 relies on IBM Plex's digit being ~8px at this size.
      // Widget tests substitute a square test font, so assert the floor that
      // makes one digit circular rather than an exact width the font decides.
      expect(size.width, greaterThanOrEqualTo(16));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DgaBadge),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.constraints!.minWidth, 16);
    });

    testWidgets('multiple digits grow wider but stay 16 tall', (tester) async {
      await tester.pumpWidget(_wrap(const DgaBadge.count(42)));

      final size = tester.getSize(find.byType(DgaBadge));
      expect(size.height, 16);
      expect(size.width, greaterThan(16));
    });

    testWidgets('caps at maxCount with a trailing +', (tester) async {
      await tester.pumpWidget(_wrap(const DgaBadge.count(150)));
      expect(find.text('99+'), findsOneWidget);

      await tester.pumpWidget(_wrap(const DgaBadge.count(150, maxCount: 9)));
      expect(find.text('9+'), findsOneWidget);

      // Exactly at the cap is still the number itself.
      await tester.pumpWidget(_wrap(const DgaBadge.count(99)));
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('uses the error tag token in both themes', (tester) async {
      for (final theme in [
        const DgaThemeData.light(),
        const DgaThemeData.dark(),
      ]) {
        await tester.pumpWidget(_wrap(const DgaBadge.count(3), theme: theme));

        final decoration =
            tester
                    .widget<Container>(
                      find
                          .descendant(
                            of: find.byType(DgaBadge),
                            matching: find.byType(Container),
                          )
                          .first,
                    )
                    .decoration!
                as BoxDecoration;
        expect(decoration.color, theme.colors.tagBackgroundError);
        expect(
          tester.widget<Text>(find.text('3')).style!.color,
          theme.colors.textOncolorPrimary,
        );
      }
    });

    testWidgets('label line height collapses so it fits the 16px box', (
      tester,
    ) async {
      // The text-xs ramp carries an 18px line box, which would overflow a
      // 16-tall badge and clip the glyph.
      await tester.pumpWidget(_wrap(const DgaBadge.count(7)));
      expect(tester.widget<Text>(find.text('7')).style!.height, 1);
    });
  });
}
