import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget in MaterialApp + DgaTheme so DgaTheme.of(context) resolves.
Widget _wrap(Widget child, {DgaThemeData? theme}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Scaffold(body: child),
  ),
);

void main() {
  group('DgaButton', () {
    testWidgets('all six style factories build without error', (tester) async {
      final buttons = <Widget>[
        DgaButton.primary(onPressed: () {}, label: 'Primary'),
        DgaButton.neutral(onPressed: () {}, label: 'Neutral'),
        DgaButton.secondarySolid(onPressed: () {}, label: 'Secondary-Solid'),
        DgaButton.secondaryOutline(
          onPressed: () {},
          label: 'Secondary-Outline',
        ),
        DgaButton.subtle(onPressed: () {}, label: 'Subtle'),
        DgaButton.transparent(onPressed: () {}, label: 'Transparent'),
      ];
      await tester.pumpWidget(_wrap(Column(children: buttons)));
      for (final b in buttons) {
        expect(find.text((b as DgaButton).label!), findsOneWidget);
      }
    });

    testWidgets('tap fires onPressed', (tester) async {
      var count = 0;
      await tester.pumpWidget(
        _wrap(DgaButton.primary(onPressed: () => count++, label: 'Tap')),
      );
      await tester.tap(find.text('Tap'));
      expect(count, 1);
    });

    testWidgets(
      'disabled: true blocks taps AND reports enabled: false to Semantics',
      (tester) async {
        var count = 0;
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _wrap(
            DgaButton.primary(
              onPressed: () => count++,
              label: 'Blocked',
              disabled: true,
            ),
          ),
        );

        await tester.tap(find.text('Blocked'), warnIfMissed: false);
        expect(count, 0, reason: 'disabled=true must swallow the tap');

        expect(
          tester.getSemantics(find.byType(DgaButton)),
          matchesSemantics(
            isButton: true,
            isEnabled: false,
            hasEnabledState: true,
            hasSelectedState:
                true, // selected: false is still an explicit state
            label: 'Blocked',
          ),
        );
        handle.dispose();
      },
    );

    testWidgets('height is fixed per size, icon-only is square', (
      tester,
    ) async {
      Future<Size> pump(DgaButtonSize size) async {
        await tester.pumpWidget(
          _wrap(
            Center(
              child: DgaButton.transparent(
                onPressed: () {},
                size: size,
                leadingIcon: const Icon(Icons.close, size: 12),
                tooltip: 'Close',
              ),
            ),
          ),
        );
        return tester.getSize(find.byType(DgaButton));
      }

      expect((await pump(DgaButtonSize.small)).height, 24);
      expect((await pump(DgaButtonSize.medium)).height, 32);
      expect((await pump(DgaButtonSize.large)).height, 40);

      // Icon-only large → square 40×40.
      final large = await pump(DgaButtonSize.large);
      expect(large.width, 40);
      expect(large.height, 40);
    });

    testWidgets('icon-only without tooltip throws in debug', (tester) async {
      expect(
        () => DgaButton.primary(
          onPressed: () {},
          leadingIcon: const Icon(Icons.add),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('renders inside RTL Directionality', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DgaTheme(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: DgaButton.primary(
                  onPressed: () {},
                  label: 'حفظ',
                  leadingIcon: const Icon(Icons.save),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('حفظ'), findsOneWidget);
    });

    testWidgets('Neutral button background is mode-independent', (
      tester,
    ) async {
      // Per the official `button-background-black-*` tokens, the Neutral
      // (black-fill) button uses the same dark fill in both light and dark
      // mode — just like the Primary brand-green button.
      Color decorationColor(WidgetTester t) {
        final decoration =
            t
                    .widget<Container>(
                      find.descendant(
                        of: find.byType(DgaButton),
                        matching: find.byType(Container),
                      ),
                    )
                    .decoration
                as BoxDecoration;
        return decoration.color!;
      }

      await tester.pumpWidget(
        _wrap(
          DgaButton.neutral(onPressed: () {}, label: 'Save'),
          theme: const DgaThemeData.light(),
        ),
      );
      final lightBg = decorationColor(tester);

      await tester.pumpWidget(
        _wrap(
          DgaButton.neutral(onPressed: () {}, label: 'Save'),
          theme: const DgaThemeData.dark(),
        ),
      );
      final darkBg = decorationColor(tester);

      expect(
        darkBg,
        equals(lightBg),
        reason:
            'Neutral button background must not change between light/dark modes',
      );
    });
  });
}
