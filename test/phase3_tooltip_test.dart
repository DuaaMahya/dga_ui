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
  group('DgaTooltip', () {
    testWidgets('hidden by default, shows message on long-press', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DgaTooltip(
            message: 'Helpful hint',
            heading: 'Title',
            icon: Icon(Icons.info, key: Key('tt-icon')),
            child: Icon(Icons.help_outline),
          ),
        ),
      );
      expect(find.text('Helpful hint'), findsNothing);

      await tester.longPress(find.byIcon(Icons.help_outline));
      await tester.pump();
      expect(find.text('Helpful hint'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      // Leading icon renders inside the bubble.
      expect(find.byKey(const Key('tt-icon')), findsOneWidget);
    });

    testWidgets('builds under light + dark, plain and inverted', (
      tester,
    ) async {
      for (final theme in [
        const DgaThemeData.light(),
        const DgaThemeData.dark(),
      ]) {
        for (final inverted in [false, true]) {
          await tester.pumpWidget(
            _wrap(
              DgaTooltip(
                message: 'msg',
                inverted: inverted,
                child: const Text('anchor'),
              ),
              theme: theme,
            ),
          );
          expect(find.text('anchor'), findsOneWidget);
        }
      }
    });

    testWidgets('bubble stays on-screen for triggers at any corner', (
      tester,
    ) async {
      // 800x600 is the default test surface.
      const size = Size(800, 600);
      const corners = <Alignment>[
        Alignment.topLeft,
        Alignment.topRight,
        Alignment.bottomLeft,
        Alignment.bottomRight,
        Alignment.center,
      ];

      for (final corner in corners) {
        await tester.pumpWidget(
          MaterialApp(
            home: DgaTheme(
              data: const DgaThemeData.light(),
              child: Scaffold(
                body: Align(
                  alignment: corner,
                  child: const DgaTooltip(
                    heading: 'Title',
                    message:
                        'A deliberately long tooltip body so the bubble is wide '
                        'enough to run past a screen edge if it were not clamped.',
                    child: Text('anchor'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.longPress(find.text('anchor'));
        await tester.pump();

        final bubble = tester.getRect(find.text('Title'));
        expect(
          bubble.left,
          greaterThanOrEqualTo(0),
          reason: 'bubble ran off the left at $corner',
        );
        expect(
          bubble.top,
          greaterThanOrEqualTo(0),
          reason: 'bubble ran off the top at $corner',
        );
        expect(
          bubble.right,
          lessThanOrEqualTo(size.width),
          reason: 'bubble ran off the right at $corner',
        );
        expect(
          bubble.bottom,
          lessThanOrEqualTo(size.height),
          reason: 'bubble ran off the bottom at $corner',
        );

        // Dismiss before the next iteration so timers don't leak.
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });

    testWidgets('beak stays aimed at the trigger even when the bubble slides', (
      tester,
    ) async {
      // Hard against the left edge: the bubble has to slide right to stay
      // on-screen, so a beak locked to the bubble's centre would point into
      // empty space. It must track the trigger instead.
      for (final alignment in [Alignment.centerLeft, Alignment.centerRight]) {
        await tester.pumpWidget(
          MaterialApp(
            home: DgaTheme(
              data: const DgaThemeData.light(),
              child: Scaffold(
                body: Align(
                  alignment: alignment,
                  child: const DgaTooltip(
                    heading: 'Title',
                    message:
                        'A deliberately long tooltip body so the bubble is far '
                        'wider than the trigger and has to be clamped.',
                    child: SizedBox(width: 24, height: 24, child: Text('x')),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.longPress(find.text('x'));
        await tester.pump();

        final trigger = tester.getRect(find.text('x'));
        // The bubble container, not just its heading text.
        final bubble = tester.getRect(
          find
              .ancestor(
                of: find.text('Title'),
                matching: find.byType(Container),
              )
              .first,
        );
        // The beak is the only 16x8 (or 8x16) CustomPaint on screen.
        final beak = tester
            .renderObjectList<RenderBox>(find.byType(CustomPaint))
            .map((r) => r.localToGlobal(Offset.zero) & r.size)
            .firstWhere(
              (r) =>
                  (r.width == 16 && r.height == 8) ||
                  (r.width == 8 && r.height == 16),
            );

        // The beak must overlap the trigger horizontally — that's what makes
        // it read as belonging to this button rather than to thin air.
        expect(
          beak.right,
          greaterThan(trigger.left),
          reason: 'beak sits entirely left of the trigger at $alignment',
        );
        expect(
          beak.left,
          lessThan(trigger.right),
          reason: 'beak sits entirely right of the trigger at $alignment',
        );

        // And it must track the trigger, not the bubble: the old bug pinned
        // the beak to the bubble's centre, which is far away once clamped.
        final beakOffBy = (beak.center.dx - trigger.center.dx).abs();
        final bubbleOffBy = (bubble.center.dx - trigger.center.dx).abs();
        expect(
          beakOffBy,
          lessThan(bubbleOffBy / 4),
          reason: 'beak is tracking the bubble rather than the trigger',
        );

        await tester.pumpWidget(const SizedBox.shrink());
      }
    });
  });
}
