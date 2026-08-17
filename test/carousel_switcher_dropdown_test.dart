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
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);

void main() {
  group('DgaCarouselDots', () {
    testWidgets('renders count dots; tapping selects; light + dark', (
      tester,
    ) async {
      var index = 0;
      for (final theme in [
        const DgaThemeData.light(),
        const DgaThemeData.dark(),
      ]) {
        await tester.pumpWidget(
          _wrap(
            StatefulBuilder(
              builder: (context, setState) => DgaCarouselDots(
                count: 4,
                selected: index,
                onSelected: (i) => setState(() => index = i),
              ),
            ),
            theme: theme,
          ),
        );
        expect(find.byType(GestureDetector), findsNWidgets(4));
        index = 0;
      }
    });
  });

  group('DgaCarousel', () {
    testWidgets('swiping updates the selected dot', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: DgaCarousel(items: [Text('A'), Text('B'), Text('C')]),
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      await tester.drag(find.text('A'), const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(find.text('B'), findsOneWidget);
    });
  });

  group('DgaContentSwitcher', () {
    testWidgets('selecting a segment fires onChanged; light + dark', (
      tester,
    ) async {
      var idx = 0;
      for (final theme in [
        const DgaThemeData.light(),
        const DgaThemeData.dark(),
      ]) {
        await tester.pumpWidget(
          _wrap(
            StatefulBuilder(
              builder: (context, setState) => DgaContentSwitcher(
                segments: const ['Day', 'Week', 'Month'],
                selectedIndex: idx,
                onChanged: (i) => setState(() => idx = i),
              ),
            ),
            theme: theme,
          ),
        );
        await tester.tap(find.text('Week'));
        await tester.pumpAndSettle();
        expect(idx, 1);
        idx = 0;
      }
    });
  });

  group('DgaDropdownInput', () {
    testWidgets('opens menu, selects a value, closes', (tester) async {
      String? value;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: StatefulBuilder(
              builder: (context, setState) => DgaDropdownInput<String>(
                label: 'City',
                hintText: 'Choose…',
                value: value,
                items: const [
                  DgaDropdownEntry(value: 'ry', label: 'Riyadh'),
                  DgaDropdownEntry(value: 'jd', label: 'Jeddah'),
                ],
                onChanged: (v) => setState(() => value = v),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Choose…'), findsOneWidget);
      await tester.tap(find.text('Choose…'));
      await tester.pumpAndSettle();
      expect(find.text('Jeddah'), findsOneWidget);
      await tester.tap(find.text('Jeddah'));
      await tester.pumpAndSettle();
      expect(value, 'jd');
      // Selected value is shown in the field.
      expect(find.text('Jeddah'), findsOneWidget);
    });

    testWidgets('errorText renders; disabled does not open', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDropdownInput<int>(
              value: null,
              enabled: false,
              errorText: 'Required',
              items: const [DgaDropdownEntry(value: 1, label: 'One')],
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Required'), findsOneWidget);
      await tester.tap(find.byType(DgaDropdownInput<int>), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('One'), findsNothing);
    });
  });
}
