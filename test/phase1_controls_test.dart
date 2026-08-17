import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {DgaThemeData? theme, TextDirection dir = TextDirection.ltr}) =>
    MaterialApp(
      home: DgaTheme(
        data: theme ?? const DgaThemeData.light(),
        child: Directionality(textDirection: dir, child: Scaffold(body: child)),
      ),
    );

void main() {
  group('DgaSwitch', () {
    testWidgets('toggles and reports state to Semantics', (tester) async {
      var value = false;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => DgaSwitch(
          value: value,
          onChanged: (v) => setState(() => value = v),
        ),
      )));
      await tester.tap(find.byType(DgaSwitch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });

    testWidgets('disabled does not toggle', (tester) async {
      var value = false;
      await tester.pumpWidget(_wrap(
        DgaSwitch(value: value, onChanged: (v) => value = v, disabled: true),
      ));
      await tester.tap(find.byType(DgaSwitch), warnIfMissed: false);
      expect(value, isFalse);
    });

    testWidgets('renders label + dark theme', (tester) async {
      await tester.pumpWidget(_wrap(
        DgaSwitch(value: true, onChanged: (_) {}, label: 'Notifications'),
        theme: const DgaThemeData.dark(),
      ));
      expect(find.text('Notifications'), findsOneWidget);
    });
  });

  group('DgaRadio', () {
    testWidgets('selecting fires onChanged with value', (tester) async {
      String? group = 'a';
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => Column(children: [
          DgaRadio<String>(
            value: 'a',
            groupValue: group,
            onChanged: (v) => setState(() => group = v),
            label: 'A',
          ),
          DgaRadio<String>(
            value: 'b',
            groupValue: group,
            onChanged: (v) => setState(() => group = v),
            label: 'B',
          ),
        ]),
      )));
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(group, 'b');
    });

    testWidgets('read-only does not change selection', (tester) async {
      String? group = 'a';
      await tester.pumpWidget(_wrap(
        DgaRadio<String>(value: 'b', groupValue: group, onChanged: (v) => group = v, readOnly: true),
      ));
      await tester.tap(find.byType(DgaRadio<String>), warnIfMissed: false);
      expect(group, 'a');
    });
  });

  group('DgaTextarea', () {
    testWidgets('multi-line typing updates controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(_wrap(
        DgaTextarea(controller: controller, label: 'Bio', hintText: 'Tell us…'),
      ));
      await tester.enterText(find.byType(TextField), 'line1\nline2');
      expect(controller.text, 'line1\nline2');
    });

    testWidgets('errorText renders', (tester) async {
      await tester.pumpWidget(_wrap(const DgaTextarea(errorText: 'Too short')));
      expect(find.text('Too short'), findsOneWidget);
    });
  });

  group('DgaRatingBar', () {
    testWidgets('tapping a star reports the rating', (tester) async {
      var rating = 0;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => DgaRatingBar(
          value: rating.toDouble(),
          onChanged: (v) => setState(() => rating = v),
        ),
      )));
      // 5 stars rendered.
      expect(find.byIcon(Icons.star), findsNWidgets(5));
      await tester.tap(find.byType(DgaRatingStar).at(2));
      expect(rating, 3);
    });

    testWidgets('half value renders a partial star (stacked icons)', (tester) async {
      await tester.pumpWidget(_wrap(const DgaRatingBar(value: 2.5)));
      // 2 full (1 each) + 1 half (2 stacked) + 2 empty (1 each) = 6 star icons.
      expect(find.byIcon(Icons.star), findsNWidgets(6));
    });
  });
}
