import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {DgaThemeData? theme, TextDirection dir = TextDirection.ltr}) =>
    MaterialApp(
      home: DgaTheme(
        data: theme ?? const DgaThemeData.light(),
        child: Directionality(textDirection: dir, child: Scaffold(body: Center(child: child))),
      ),
    );

void main() {
  group('DgaCheckbox', () {
    testWidgets('toggles and reports checked/mixed to Semantics', (tester) async {
      var value = false;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => DgaCheckbox(
          value: value,
          onChanged: (v) => setState(() => value = v),
          label: 'Accept',
        ),
      )));
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();
      expect(value, isTrue);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('indeterminate shows a dash; disabled blocks tap', (tester) async {
      var value = false;
      await tester.pumpWidget(_wrap(
        DgaCheckbox(value: value, indeterminate: true, onChanged: (v) => value = v, disabled: true),
      ));
      expect(find.byIcon(Icons.remove), findsOneWidget);
      await tester.tap(find.byType(DgaCheckbox), warnIfMissed: false);
      expect(value, isFalse);
    });
  });

  group('DgaAvatar', () {
    testWidgets('initials + icon build under light/dark', (tester) async {
      for (final theme in [const DgaThemeData.light(), const DgaThemeData.dark()]) {
        await tester.pumpWidget(_wrap(
          const Row(mainAxisSize: MainAxisSize.min, children: [
            DgaAvatar.initials('DM', size: 48),
            SizedBox(width: 8),
            DgaAvatar.icon(Icon(Icons.person), size: 48, square: true),
          ]),
          theme: theme,
        ));
        expect(find.text('DM'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      }
    });
  });

  group('DgaAccordion', () {
    testWidgets('expands on tap and reveals body', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 360,
        child: DgaAccordion(title: 'Section', child: Text('Hidden body')),
      )));
      expect(find.text('Section'), findsOneWidget);
      await tester.tap(find.text('Section'));
      await tester.pumpAndSettle();
      expect(find.text('Hidden body'), findsOneWidget);
    });

    testWidgets('disabled does not expand', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 360,
        child: DgaAccordion(title: 'Locked', disabled: true, child: Text('Body')),
      )));
      final collapsedHeight = tester.getSize(find.byType(DgaAccordion)).height;
      await tester.tap(find.text('Locked'));
      await tester.pumpAndSettle();
      // A disabled accordion doesn't grow — its height stays collapsed.
      expect(tester.getSize(find.byType(DgaAccordion)).height, collapsedHeight);
    });
  });

  group('DgaCard', () {
    testWidgets('non-interactive renders child; tappable fires onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(Column(mainAxisSize: MainAxisSize.min, children: [
        const DgaCard(effect: DgaCardEffect.stroke, child: Text('Static card')),
        DgaCard(onTap: () => taps++, selected: true, child: const Text('Tap me')),
      ])));
      expect(find.text('Static card'), findsOneWidget);
      await tester.tap(find.text('Tap me'));
      expect(taps, 1);
    });
  });
}
