import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  DgaThemeData? theme,
  TextDirection dir = TextDirection.ltr,
}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Directionality(
      textDirection: dir,
      child: Scaffold(body: child),
    ),
  ),
);

void main() {
  group('DgaTextInput', () {
    testWidgets('builds under Light and Dark', (tester) async {
      for (final theme in [
        const DgaThemeData.light(),
        const DgaThemeData.dark(),
      ]) {
        await tester.pumpWidget(
          _wrap(
            const DgaTextInput(label: 'Title', hintText: 'Placeholder'),
            theme: theme,
          ),
        );
        expect(find.text('Title'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      }
    });

    testWidgets('typing updates the controller and fires onChanged', (
      tester,
    ) async {
      final controller = TextEditingController();
      var changed = '';
      await tester.pumpWidget(
        _wrap(
          DgaTextInput(controller: controller, onChanged: (v) => changed = v),
        ),
      );
      await tester.enterText(find.byType(TextField), 'hello');
      expect(controller.text, 'hello');
      expect(changed, 'hello');
    });

    testWidgets('errorText renders in the helper slot', (tester) async {
      await tester.pumpWidget(
        _wrap(const DgaTextInput(label: 'Email', errorText: 'Required field')),
      );
      expect(find.text('Required field'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('disabled blocks input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        _wrap(DgaTextInput(controller: controller, enabled: false)),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('focus drives the underline animation forward', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(_wrap(DgaTextInput(focusNode: focusNode)));

      // Before focus: the scaled underline is collapsed (scaleX ~ 0).
      Transform underlineTransform() => tester.widget<Transform>(
        find.descendant(
          of: find.byType(DgaTextInput),
          matching: find.byType(Transform),
        ),
      );
      expect(underlineTransform().transform.getRow(0)[0], 0);

      focusNode.requestFocus();
      await tester.pump(); // start the controller
      await tester.pump(const Duration(milliseconds: 250)); // finish it

      // After focus: fully expanded (scaleX == 1).
      expect(underlineTransform().transform.getRow(0)[0], 1);
      focusNode.dispose();
    });

    testWidgets('renders under RTL', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DgaTextInput(label: 'عنوان', hintText: 'نص تلميحي'),
          dir: TextDirection.rtl,
        ),
      );
      expect(find.text('عنوان'), findsOneWidget);
    });

    group('clearable', () {
      testWidgets('hidden when empty, appears once there is text', (
        tester,
      ) async {
        final controller = TextEditingController();
        await tester.pumpWidget(
          _wrap(DgaTextInput(controller: controller, clearable: true)),
        );
        expect(find.byIcon(Icons.close_rounded), findsNothing);

        await tester.enterText(find.byType(TextField), 'hello');
        await tester.pump();
        expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      });

      testWidgets('tapping it empties the field and fires onChanged', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'hello');
        var changed = 'unset';
        await tester.pumpWidget(
          _wrap(
            DgaTextInput(
              controller: controller,
              clearable: true,
              onChanged: (v) => changed = v,
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(changed, isEmpty);
        expect(find.byIcon(Icons.close_rounded), findsNothing);
      });

      testWidgets('sits before the suffix, not on top of it', (tester) async {
        await tester.pumpWidget(
          _wrap(
            DgaTextInput(
              controller: TextEditingController(text: 'mysite'),
              clearable: true,
              suffix: const Text('.gov.sa'),
            ),
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.close_rounded), findsOneWidget);
        expect(find.text('.gov.sa'), findsOneWidget);
        final clearX = tester.getCenter(find.byIcon(Icons.close_rounded)).dx;
        final suffixX = tester.getCenter(find.text('.gov.sa')).dx;
        expect(clearX, lessThan(suffixX));
      });

      testWidgets('never shows when disabled or read-only', (tester) async {
        await tester.pumpWidget(
          _wrap(
            DgaTextInput(
              controller: TextEditingController(text: 'hello'),
              clearable: true,
              enabled: false,
            ),
          ),
        );
        expect(find.byIcon(Icons.close_rounded), findsNothing);

        await tester.pumpWidget(
          _wrap(
            DgaTextInput(
              controller: TextEditingController(text: 'hello'),
              clearable: true,
              readOnly: true,
            ),
          ),
        );
        expect(find.byIcon(Icons.close_rounded), findsNothing);
      });
    });
  });
}
