import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds an app whose body is a button that fires [onPressed], so tests can
/// call `show()` with a context that has an Overlay above it.
Widget _app({
  required void Function(BuildContext context) onPressed,
  DgaThemeData? theme,
  TextDirection dir = TextDirection.ltr,
  bool disableAnimations = false,
}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: disableAnimations),
        child: Directionality(
          textDirection: dir,
          child: Scaffold(
            body: Builder(
              builder: (inner) => Center(
                child: ElevatedButton(
                  onPressed: () => onPressed(inner),
                  child: const Text('fire'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  const title = 'Toast title';
  const body = 'Some further explanation.';

  group('DgaNotificationToast widget', () {
    testWidgets('renders content and is always the white surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DgaTheme(
            data: const DgaThemeData.light(),
            child: const Scaffold(
              body: Center(
                child: DgaNotificationToast(
                  title: title,
                  description: body,
                  severity: DgaAlertSeverity.error,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(body), findsOneWidget);

      final colors = const DgaThemeData.light().colors;
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DgaNotificationToast),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;

      expect(
        decoration.color,
        colors.backgroundNotificationWhite,
        reason: 'the toast is white even for the error severity',
      );
      expect(
        decoration.boxShadow,
        DgaShadows.xl3,
        reason: 'toast is elevated with shadow-3xl',
      );
      expect(
        decoration.border,
        isNull,
        reason: 'Figma draws no border on the toast',
      );
      expect(
        tester.widget<Text>(find.text(title)).style!.color,
        colors.textDisplay,
        reason: 'white surface keeps a neutral title',
      );
    });
  });

  group('DgaNotificationToast.show', () {
    testWidgets('inserts a toast and auto-removes after duration', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          onPressed: (context) => DgaNotificationToast.show(
            context,
            title: title,
            duration: const Duration(seconds: 2),
          ),
        ),
      );

      expect(find.text(title), findsNothing);

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text(title), findsNothing);
    });

    testWidgets('overlay text has a Material ancestor (no yellow underline)', (
      tester,
    ) async {
      // An Overlay provides no Material, and Text without one renders with
      // Flutter's debug yellow double-underline. Assert both that a Material
      // is present and that no resolved text style carries an underline.
      late DgaToastHandle handle;
      await tester.pumpWidget(
        _app(
          onPressed: (context) => handle = DgaNotificationToast.show(
            context,
            title: title,
            description: body,
            duration: Duration.zero,
          ),
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();

      for (final text in [title, body]) {
        expect(
          find.ancestor(of: find.text(text), matching: find.byType(Material)),
          findsAtLeastNWidgets(1),
          reason: '"$text" must sit under a Material',
        );

        final widget = tester.widget<Text>(find.text(text));
        final resolved = DefaultTextStyle.of(
          tester.element(find.text(text)),
        ).style.merge(widget.style);
        expect(
          resolved.decoration ?? TextDecoration.none,
          TextDecoration.none,
          reason: '"$text" picked up the missing-Material underline',
        );
      }

      handle.dismiss();
      await tester.pumpAndSettle();
    });

    testWidgets('the returned handle dismisses early', (tester) async {
      late DgaToastHandle handle;
      await tester.pumpWidget(
        _app(
          onPressed: (context) => handle = DgaNotificationToast.show(
            context,
            title: title,
            duration: Duration.zero, // no auto-dismiss
          ),
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
      expect(handle.isVisible, isTrue);

      handle.dismiss();
      await tester.pumpAndSettle();
      expect(find.text(title), findsNothing);
      expect(handle.isVisible, isFalse);
    });

    testWidgets('Duration.zero keeps the toast up indefinitely', (
      tester,
    ) async {
      late DgaToastHandle handle;
      await tester.pumpWidget(
        _app(
          onPressed: (context) => handle = DgaNotificationToast.show(
            context,
            title: title,
            duration: Duration.zero,
          ),
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);

      handle.dismiss();
      await tester.pumpAndSettle();
    });

    testWidgets('a second toast queues behind the first', (tester) async {
      late DgaToastHandle first;
      late DgaToastHandle second;
      await tester.pumpWidget(
        _app(
          onPressed: (context) {
            first = DgaNotificationToast.show(
              context,
              title: 'First toast',
              duration: Duration.zero,
            );
            second = DgaNotificationToast.show(
              context,
              title: 'Second toast',
              duration: Duration.zero,
            );
          },
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();

      // Only the first is on screen; the second waits its turn.
      expect(find.text('First toast'), findsOneWidget);
      expect(find.text('Second toast'), findsNothing);
      expect(find.byType(DgaNotificationToast), findsOneWidget);
      expect(first.isVisible, isTrue);
      expect(
        second.isVisible,
        isFalse,
        reason: 'a queued toast is not visible yet',
      );

      // Retiring the first hands the slot to the second.
      first.dismiss();
      await tester.pumpAndSettle();
      expect(find.text('First toast'), findsNothing);
      expect(find.text('Second toast'), findsOneWidget);
      expect(second.isVisible, isTrue);

      second.dismiss();
      await tester.pumpAndSettle();
      expect(
        find.byType(DgaNotificationToast),
        findsNothing,
        reason: 'no orphaned overlay entries left behind',
      );
    });

    testWidgets('dismissing a queued toast drops it before it shows', (
      tester,
    ) async {
      late DgaToastHandle first;
      late DgaToastHandle queued;
      await tester.pumpWidget(
        _app(
          onPressed: (context) {
            first = DgaNotificationToast.show(
              context,
              title: 'First toast',
              duration: Duration.zero,
            );
            queued = DgaNotificationToast.show(
              context,
              title: 'Cancelled toast',
              duration: Duration.zero,
            );
          },
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();

      // Cancel the queued one before its turn comes round.
      queued.dismiss();
      first.dismiss();
      await tester.pumpAndSettle();

      expect(
        find.text('Cancelled toast'),
        findsNothing,
        reason: 'a cancelled queue entry must never be shown',
      );
      expect(find.byType(DgaNotificationToast), findsNothing);
    });

    testWidgets('three toasts play back-to-back', (tester) async {
      await tester.pumpWidget(
        _app(
          onPressed: (context) {
            for (final n in ['One', 'Two', 'Three']) {
              DgaNotificationToast.show(
                context,
                title: n,
                duration: const Duration(seconds: 1),
              );
            }
          },
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();
      expect(find.text('One'), findsOneWidget);

      // Step the clock explicitly. `pumpAndSettle` keeps advancing while
      // frames are scheduled, which sails past the *next* toast's own
      // auto-dismiss and makes the assertions off by one.
      Future<void> advance() async {
        await tester.pump(const Duration(seconds: 1)); // auto-dismiss + handoff
        await tester.pump(const Duration(milliseconds: 200)); // exit transition
      }

      for (final next in ['Two', 'Three']) {
        await advance();
        expect(find.text(next), findsOneWidget, reason: '$next should follow');
      }

      await advance();
      expect(find.byType(DgaNotificationToast), findsNothing);
    });

    testWidgets('tapping the close button dismisses it', (tester) async {
      await tester.pumpWidget(
        _app(
          onPressed: (context) => DgaNotificationToast.show(
            context,
            title: title,
            duration: Duration.zero,
          ),
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);

      await tester.tap(find.byType(DgaCloseButton));
      await tester.pumpAndSettle();
      expect(find.text(title), findsNothing);
    });

    testWidgets('bottom placement anchors below the top placement', (
      tester,
    ) async {
      Future<double> centerFor(DgaToastPlacement placement) async {
        late DgaToastHandle handle;
        await tester.pumpWidget(
          _app(
            onPressed: (context) => handle = DgaNotificationToast.show(
              context,
              title: title,
              duration: Duration.zero,
              placement: placement,
            ),
          ),
        );
        await tester.tap(find.text('fire'));
        await tester.pumpAndSettle();
        final dy = tester.getCenter(find.text(title)).dy;
        handle.dismiss();
        await tester.pumpAndSettle();
        return dy;
      }

      final top = await centerFor(DgaToastPlacement.topCenter);
      final bottom = await centerFor(DgaToastPlacement.bottomCenter);
      expect(top, lessThan(bottom));
    });

    testWidgets('still shows and dismisses with animations disabled', (
      tester,
    ) async {
      late DgaToastHandle handle;
      await tester.pumpWidget(
        _app(
          disableAnimations: true,
          onPressed: (context) => handle = DgaNotificationToast.show(
            context,
            title: title,
            duration: Duration.zero,
          ),
        ),
      );

      await tester.tap(find.text('fire'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);

      handle.dismiss();
      await tester.pumpAndSettle();
      expect(find.text(title), findsNothing);
    });

    testWidgets('builds under dark and RTL', (tester) async {
      for (final dir in [TextDirection.ltr, TextDirection.rtl]) {
        late DgaToastHandle handle;
        await tester.pumpWidget(
          _app(
            theme: const DgaThemeData.dark(),
            dir: dir,
            onPressed: (context) => handle = DgaNotificationToast.show(
              context,
              title: title,
              description: body,
              severity: DgaAlertSeverity.success,
              duration: Duration.zero,
            ),
          ),
        );

        await tester.tap(find.text('fire'));
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);

        handle.dismiss();
        await tester.pumpAndSettle();
      }
    });
  });
}
