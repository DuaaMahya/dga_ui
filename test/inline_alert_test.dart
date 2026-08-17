import 'package:dga_ui/dga_ui.dart';
// StatusIcon isn't re-exported from the barrel; import it directly rather
// than widening the package's public API just for a test.
import 'package:dga_ui/icon_native/status_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  DgaThemeData? theme,
  TextDirection dir = TextDirection.ltr,
  double width = 800,
}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Directionality(
      textDirection: dir,
      child: Scaffold(
        body: Center(
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);

/// The alert's outer card — the only Container carrying a BoxDecoration with
/// a border radius inside the alert.
BoxDecoration _surface(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(DgaInlineAlert),
          matching: find.byType(Container),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

/// The 4px leading accent bar.
Color _accent(WidgetTester tester) {
  final box = tester.widget<ColoredBox>(
    find.descendant(
      of: find.byType(DgaInlineAlert),
      matching: find.byType(ColoredBox),
    ),
  );
  return box.color;
}

Color _titleColor(WidgetTester tester, String title) =>
    tester.widget<Text>(find.text(title)).style!.color!;

void main() {
  const title = 'Alert title';
  const body = 'Some further explanation.';

  group('DgaInlineAlert', () {
    testWidgets('renders title, description and the severity accent', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DgaInlineAlert(
            title: title,
            description: body,
            severity: DgaAlertSeverity.info,
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(body), findsOneWidget);

      final colors = const DgaThemeData.light().colors;
      expect(_accent(tester), colors.backgroundInfo);
    });

    testWidgets('each severity picks its own accent token', (tester) async {
      final colors = const DgaThemeData.light().colors;
      final expected = {
        DgaAlertSeverity.neutral: colors.backgroundNeutral200,
        DgaAlertSeverity.info: colors.backgroundInfo,
        DgaAlertSeverity.error: colors.backgroundError,
        DgaAlertSeverity.warning: colors.backgroundWarning,
        DgaAlertSeverity.success: colors.backgroundSuccess,
      };

      for (final entry in expected.entries) {
        await tester.pumpWidget(
          _wrap(DgaInlineAlert(title: title, severity: entry.key)),
        );
        expect(
          _accent(tester),
          entry.value,
          reason: 'wrong accent for ${entry.key}',
        );
      }
    });

    testWidgets('white vs tinted swaps surface, border and title colour', (
      tester,
    ) async {
      final colors = const DgaThemeData.light().colors;

      await tester.pumpWidget(
        _wrap(
          const DgaInlineAlert(
            title: title,
            severity: DgaAlertSeverity.info,
            background: DgaInlineAlertBackground.white,
          ),
        ),
      );
      expect(_surface(tester).color, colors.backgroundNotificationWhite);
      expect(
        _titleColor(tester, title),
        colors.textDisplay,
        reason: 'white surface keeps a neutral title',
      );

      await tester.pumpWidget(
        _wrap(
          const DgaInlineAlert(
            title: title,
            severity: DgaAlertSeverity.info,
            background: DgaInlineAlertBackground.color,
          ),
        ),
      );
      expect(_surface(tester).color, colors.backgroundInfo25);
      expect(
        (_surface(tester).border! as Border).top.color,
        colors.borderInfoLight,
      );
      expect(
        _titleColor(tester, title),
        colors.textInfo,
        reason: 'tinted surface takes the severity hue for the title',
      );
    });

    testWidgets('dismiss hides it by default', (tester) async {
      await tester.pumpWidget(_wrap(const DgaInlineAlert(title: title)));
      expect(find.text(title), findsOneWidget);

      await tester.tap(find.byType(DgaCloseButton));
      await tester.pumpAndSettle();
      expect(find.text(title), findsNothing);
    });

    testWidgets('onDismiss takes over instead of self-hiding', (tester) async {
      var called = 0;
      await tester.pumpWidget(
        _wrap(DgaInlineAlert(title: title, onDismiss: () => called++)),
      );

      await tester.tap(find.byType(DgaCloseButton));
      await tester.pumpAndSettle();

      expect(called, 1);
      expect(
        find.text(title),
        findsOneWidget,
        reason: 'host controls visibility once onDismiss is supplied',
      );
    });

    testWidgets('dismissible: false renders no close button', (tester) async {
      await tester.pumpWidget(
        _wrap(const DgaInlineAlert(title: title, dismissible: false)),
      );
      expect(find.byType(DgaCloseButton), findsNothing);
    });

    testWidgets('actions render and fire', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          DgaInlineAlert(
            title: title,
            actions: [
              DgaButton.secondaryOutline(onPressed: () => taps++, label: 'Act'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Act'));
      expect(taps, 1);
    });

    testWidgets('narrow width switches to the stacked layout', (tester) async {
      // Wide: icon, text and close share one row, so the close button sits
      // to the side of the title.
      await tester.pumpWidget(
        _wrap(const DgaInlineAlert(title: title), width: 800),
      );
      var closeY = tester.getCenter(find.byType(DgaCloseButton)).dy;
      var titleY = tester.getCenter(find.text(title)).dy;
      expect(
        (closeY - titleY).abs() < 30,
        isTrue,
        reason: 'wide layout keeps close roughly level with the title',
      );

      // Narrow: close moves onto its own row above the title.
      await tester.pumpWidget(
        _wrap(const DgaInlineAlert(title: title), width: 320),
      );
      await tester.pumpAndSettle();
      closeY = tester.getCenter(find.byType(DgaCloseButton)).dy;
      titleY = tester.getCenter(find.text(title)).dy;
      expect(
        closeY,
        lessThan(titleY),
        reason: 'stacked layout puts close above the title',
      );
    });

    testWidgets('mobile: overrides the width-based choice', (tester) async {
      await tester.pumpWidget(
        _wrap(const DgaInlineAlert(title: title, mobile: true), width: 800),
      );
      expect(
        tester.getCenter(find.byType(DgaCloseButton)).dy,
        lessThan(tester.getCenter(find.text(title)).dy),
        reason: 'mobile:true forces the stacked layout even when wide',
      );
    });

    testWidgets('accent sits on the leading edge in both directions', (
      tester,
    ) async {
      for (final dir in [TextDirection.ltr, TextDirection.rtl]) {
        await tester.pumpWidget(
          _wrap(
            const DgaInlineAlert(
              title: title,
              severity: DgaAlertSeverity.error,
            ),
            dir: dir,
          ),
        );

        final card = tester.getRect(find.byType(DgaInlineAlert));
        final bar = tester.getRect(
          find.descendant(
            of: find.byType(DgaInlineAlert),
            matching: find.byType(ColoredBox),
          ),
        );

        if (dir == TextDirection.ltr) {
          expect(bar.left, closeTo(card.left, 1), reason: 'LTR: bar on left');
        } else {
          expect(
            bar.right,
            closeTo(card.right, 1),
            reason: 'RTL: bar on right',
          );
        }
      }
    });

    testWidgets('stacked layout moves the accent bar to the top edge', (
      tester,
    ) async {
      // Wide: a tall, thin strip hugging the leading edge.
      await tester.pumpWidget(
        _wrap(const DgaInlineAlert(title: title), width: 800),
      );
      var card = tester.getRect(find.byType(DgaInlineAlert));
      var bar = tester.getRect(
        find.descendant(
          of: find.byType(DgaInlineAlert),
          matching: find.byType(ColoredBox),
        ),
      );
      // Tolerances allow for the card's 1px border, which the bar sits inside.
      expect(bar.width, lessThan(bar.height), reason: 'wide: vertical strip');
      expect(bar.height, closeTo(card.height, 3));
      expect(bar.left, closeTo(card.left, 2));

      // Stacked: a short, wide strip across the top instead.
      await tester.pumpWidget(
        _wrap(const DgaInlineAlert(title: title, mobile: true), width: 800),
      );
      await tester.pumpAndSettle();
      card = tester.getRect(find.byType(DgaInlineAlert));
      bar = tester.getRect(
        find.descendant(
          of: find.byType(DgaInlineAlert),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(
        bar.height,
        lessThan(bar.width),
        reason: 'stacked: horizontal bar',
      );
      expect(
        bar.width,
        closeTo(card.width, 3),
        reason: 'it spans the full card width',
      );
      expect(bar.top, closeTo(card.top, 2), reason: 'flush with the top edge');
    });

    testWidgets('stacked actions keep their own width and centre', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DgaInlineAlert(
            title: title,
            mobile: true,
            actions: [
              DgaButton.secondaryOutline(onPressed: () {}, label: 'Narrow'),
            ],
          ),
          width: 600,
        ),
      );
      await tester.pumpAndSettle();

      final card = tester.getRect(find.byType(DgaInlineAlert));
      final button = tester.getRect(find.byType(DgaButton));

      expect(
        button.width,
        lessThan(card.width - 40),
        reason: 'actions are no longer stretched to the card width',
      );
      expect(
        button.center.dx,
        closeTo(card.center.dx, 1),
        reason: 'stacked actions are centred',
      );
    });

    testWidgets('a caller can still opt into a full-width stacked action', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DgaInlineAlert(
            title: title,
            mobile: true,
            actions: [
              SizedBox(
                width: double.infinity,
                child: DgaButton.secondaryOutline(
                  onPressed: () {},
                  label: 'Wide',
                ),
              ),
            ],
          ),
          width: 600,
        ),
      );
      await tester.pumpAndSettle();

      final card = tester.getRect(find.byType(DgaInlineAlert));
      final button = tester.getRect(find.byType(DgaButton));
      // Card width minus the horizontal padding on both sides.
      expect(button.width, greaterThan(card.width - 60));
    });

    testWidgets('status glyph cutout matches its chip, not hardcoded white', (
      tester,
    ) async {
      // StatusIcon paints a backing layer that shows through the glyph's
      // evenOdd cutouts. Left at its white default, a white glyph (neutral in
      // dark mode) renders as a solid disc with no visible symbol.
      for (final theme in [
        const DgaThemeData.light(),
        const DgaThemeData.dark(),
      ]) {
        await tester.pumpWidget(
          _wrap(
            const DgaInlineAlert(
              title: title,
              severity: DgaAlertSeverity.neutral,
            ),
            theme: theme,
          ),
        );

        final icon = tester.widget<StatusIcon>(find.byType(StatusIcon));
        expect(
          icon.backgroundColor,
          theme.colors.backgroundNeutral50,
          reason: 'backing must be the chip fill',
        );
        expect(
          icon.backgroundColor,
          isNot(icon.color),
          reason: 'glyph would be invisible against its own backing',
        );
      }
    });

    testWidgets('builds under dark', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DgaInlineAlert(
            title: title,
            description: body,
            severity: DgaAlertSeverity.success,
            background: DgaInlineAlertBackground.color,
          ),
          theme: const DgaThemeData.dark(),
        ),
      );
      expect(find.text(title), findsOneWidget);
    });
  });
}
