import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  DgaThemeData? theme,
  TextDirection dir = TextDirection.ltr,
  Alignment alignment = Alignment.center,
}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Directionality(
      textDirection: dir,
      child: Scaffold(
        body: Align(alignment: alignment, child: child),
      ),
    ),
  ),
);

void main() {
  final jan2024 = DateTime(2024, 1, 19);

  group('date parsing', () {
    test('accepts d/M/yyyy and d/M/yy', () {
      expect(dgaParseDate('19/01/2024'), DateTime(2024, 1, 19));
      expect(dgaParseDate('9/1/2024'), DateTime(2024, 1, 9));
      expect(dgaParseDate('19/01/24'), DateTime(2024, 1, 19));
    });

    test('accepts - and . separators', () {
      expect(dgaParseDate('19-01-2024'), DateTime(2024, 1, 19));
      expect(dgaParseDate('19.01.2024'), DateTime(2024, 1, 19));
    });

    test('rejects nonsense and overflow rather than rolling over', () {
      expect(dgaParseDate(''), isNull);
      expect(dgaParseDate('19/01'), isNull, reason: 'incomplete');
      expect(dgaParseDate('abc'), isNull);
      expect(dgaParseDate('32/01/2024'), isNull, reason: 'no such day');
      expect(dgaParseDate('19/13/2024'), isNull, reason: 'no such month');
      // DateTime(2023, 2, 29) would silently become 1 March — must not.
      expect(dgaParseDate('29/02/2023'), isNull);
      expect(dgaParseDate('29/02/2024'), DateTime(2024, 2, 29), reason: 'leap');
    });

    test('formats zero-padded', () {
      expect(dgaFormatDate(DateTime(2024, 1, 9)), '09/01/2024');
      expect(dgaFormatDate(null), '');
    });
  });

  group('DgaDatePickerInput.single', () {
    testWidgets('renders the value and opens the calendar on tap', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDatePickerInput.single(
              label: 'Date',
              value: jan2024,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('19/01/2024'), findsOneWidget);
      expect(find.byType(DgaCalendar), findsNothing);

      await tester.tap(find.byType(DgaTextInput));
      await tester.pumpAndSettle();
      expect(find.byType(DgaCalendar), findsOneWidget);
      expect(find.text('January 2024'), findsOneWidget);
    });

    testWidgets('picking a day commits it and closes the popover', (
      tester,
    ) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDatePickerInput.single(
              value: jan2024,
              onChanged: (d) => picked = d,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DgaTextInput));
      await tester.pumpAndSettle();
      await tester.tap(find.text('25').first);
      await tester.pumpAndSettle();

      expect(picked, DateTime(2024, 1, 25));
      expect(find.byType(DgaCalendar), findsNothing);
    });

    testWidgets('typing a valid date commits; a partial one does not', (
      tester,
    ) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDatePickerInput.single(
              value: null,
              onChanged: (d) => picked = d,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '19/01');
      await tester.pump();
      expect(picked, isNull, reason: 'half-typed input must not commit');

      await tester.enterText(find.byType(TextField), '19/01/2024');
      await tester.pump();
      expect(picked, DateTime(2024, 1, 19));
    });

    testWidgets('typed dates outside the bounds are ignored', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDatePickerInput.single(
              value: null,
              firstDate: DateTime(2024, 1, 1),
              lastDate: DateTime(2024, 12, 31),
              onChanged: (d) => picked = d,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '19/01/2023');
      await tester.pump();
      expect(picked, isNull);

      await tester.enterText(find.byType(TextField), '19/01/2024');
      await tester.pump();
      expect(picked, DateTime(2024, 1, 19));
    });

    testWidgets('clearing the text clears the value', (tester) async {
      var picked = jan2024 as DateTime?;
      var calls = 0;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDatePickerInput.single(
              value: jan2024,
              onChanged: (d) {
                picked = d;
                calls++;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      expect(calls, greaterThan(0));
      expect(picked, isNull);
    });

    testWidgets('disabled never opens the popover', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDatePickerInput.single(
              enabled: false,
              value: null,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DgaTextInput), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(DgaCalendar), findsNothing);
    });

    testWidgets('popover stays on screen for a field at the bottom', (
      tester,
    ) async {
      // Default test surface is 800x600; a 456-tall calendar can't fit below
      // a field pinned to the bottom, so it must flip above and stay clamped.
      const surface = Size(800, 600);
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 320,
            child: DgaDatePickerInput.single(value: null, onChanged: (_) {}),
          ),
          alignment: Alignment.bottomCenter,
        ),
      );

      await tester.tap(find.byType(DgaTextInput));
      await tester.pumpAndSettle();

      final panel = tester.getRect(find.byType(DgaCalendar));
      expect(panel.top, greaterThanOrEqualTo(0));
      expect(panel.left, greaterThanOrEqualTo(0));
      expect(panel.right, lessThanOrEqualTo(surface.width));
      expect(panel.bottom, lessThanOrEqualTo(surface.height));
    });

    testWidgets('builds under dark and RTL', (tester) async {
      for (final dir in [TextDirection.ltr, TextDirection.rtl]) {
        await tester.pumpWidget(
          _wrap(
            SizedBox(
              width: 320,
              child: DgaDatePickerInput.single(
                label: 'Date',
                value: jan2024,
                onChanged: (_) {},
              ),
            ),
            theme: const DgaThemeData.dark(),
            dir: dir,
          ),
        );
        expect(find.text('19/01/2024'), findsOneWidget);
      }
    });
  });

  group('DgaDatePickerInput.range', () {
    testWidgets('stays open until both ends are picked, then formats both', (
      tester,
    ) async {
      DgaDateRange? value;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: 320,
              child: DgaDatePickerInput.range(
                value: value,
                onChanged: (r) => setState(() => value = r),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DgaTextInput));
      await tester.pumpAndSettle();

      await tester.tap(find.text('10').first);
      await tester.pumpAndSettle();
      expect(
        find.byType(DgaCalendar),
        findsOneWidget,
        reason: 'must stay open after only the start is picked',
      );

      await tester.tap(find.text('20').first);
      await tester.pumpAndSettle();
      expect(find.byType(DgaCalendar), findsNothing);
      expect(value!.isComplete, isTrue);

      final text =
          '${dgaFormatDate(value!.start)} – '
          '${dgaFormatDate(value!.end)}';
      expect(find.text(text), findsOneWidget);
    });
  });
}
