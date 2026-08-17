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
  // Fixed month so the grid layout is deterministic: Jan 2024 starts on a
  // Monday and needs 6 rows.
  final jan2024 = DateTime(2024, 1, 15);

  group('DgaCalendar.single', () {
    testWidgets('tapping a day reports the right DateTime', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          DgaCalendar.single(
            initialMonth: jan2024,
            onChanged: (d) => picked = d,
          ),
        ),
      );

      await tester.tap(find.text('19').first);
      await tester.pump();

      expect(picked, DateTime(2024, 1, 19));
    });

    testWidgets('renders the month label and navigates months', (tester) async {
      await tester.pumpWidget(
        _wrap(DgaCalendar.single(initialMonth: jan2024, onChanged: (_) {})),
      );
      expect(find.text('January 2024'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('February 2024'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Previous month'));
      await tester.pumpAndSettle();
      expect(find.text('January 2024'), findsOneWidget);
    });

    testWidgets('year list opens and jumps the year', (tester) async {
      await tester.pumpWidget(
        _wrap(DgaCalendar.single(initialMonth: jan2024, onChanged: (_) {})),
      );

      await tester.tap(find.text('January 2024'));
      await tester.pumpAndSettle();
      // The list opens scrolled to the selected year, so its neighbours are
      // on screen.
      expect(find.text('2026'), findsOneWidget);

      await tester.tap(find.text('2026'));
      await tester.pumpAndSettle();
      expect(find.text('January 2026'), findsOneWidget);
    });

    testWidgets('firstDate/lastDate block out-of-bounds days', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          DgaCalendar.single(
            initialMonth: jan2024,
            firstDate: DateTime(2024, 1, 10),
            lastDate: DateTime(2024, 1, 20),
            onChanged: (d) => picked = d,
          ),
        ),
      );

      await tester.tap(find.text('5').first, warnIfMissed: false);
      await tester.pump();
      expect(picked, isNull, reason: 'day before firstDate must not select');

      await tester.tap(find.text('25').first, warnIfMissed: false);
      await tester.pump();
      expect(picked, isNull, reason: 'day after lastDate must not select');

      await tester.tap(find.text('15').first);
      await tester.pump();
      expect(picked, DateTime(2024, 1, 15));
    });

    testWidgets('selectableDayPredicate vetoes days', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _wrap(
          DgaCalendar.single(
            initialMonth: jan2024,
            // 2024-01-19 is a Friday.
            selectableDayPredicate: (d) => d.weekday != DateTime.friday,
            onChanged: (d) => picked = d,
          ),
        ),
      );

      await tester.tap(find.text('19').first, warnIfMissed: false);
      await tester.pump();
      expect(picked, isNull);

      await tester.tap(find.text('18').first);
      await tester.pump();
      expect(picked, DateTime(2024, 1, 18));
    });

    testWidgets('shrinks to fit a narrow phone without overflowing', (
      tester,
    ) async {
      // 424 is the natural width; a 375-wide phone must shrink the slots
      // rather than overflow. Any RenderFlex overflow fails the test.
      tester.view.physicalSize = const Size(375, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _wrap(DgaCalendar.single(initialMonth: jan2024, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      final panel = tester.getRect(find.byType(DgaCalendar));
      expect(panel.width, lessThanOrEqualTo(375));
      expect(find.text('January 2024'), findsOneWidget);
    });

    testWidgets('builds under dark and RTL', (tester) async {
      for (final dir in [TextDirection.ltr, TextDirection.rtl]) {
        await tester.pumpWidget(
          _wrap(
            DgaCalendar.single(initialMonth: jan2024, onChanged: (_) {}),
            theme: const DgaThemeData.dark(),
            dir: dir,
          ),
        );
        expect(find.text('January 2024'), findsOneWidget);
      }
    });
  });

  group('DgaCalendar.range', () {
    testWidgets('first tap sets start, second completes the range', (
      tester,
    ) async {
      DgaDateRange? value;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => DgaCalendar.range(
              initialMonth: jan2024,
              value: value,
              onChanged: (r) => setState(() => value = r),
            ),
          ),
        ),
      );

      await tester.tap(find.text('10').first);
      await tester.pumpAndSettle();
      expect(value!.start, DateTime(2024, 1, 10));
      expect(value!.end, isNull);

      await tester.tap(find.text('20').first);
      await tester.pumpAndSettle();
      expect(value!.start, DateTime(2024, 1, 10));
      expect(value!.end, DateTime(2024, 1, 20));
      expect(value!.isComplete, isTrue);
    });

    testWidgets('picking backwards still yields an ordered range', (
      tester,
    ) async {
      DgaDateRange? value;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => DgaCalendar.range(
              initialMonth: jan2024,
              value: value,
              onChanged: (r) => setState(() => value = r),
            ),
          ),
        ),
      );

      await tester.tap(find.text('20').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('10').first);
      await tester.pumpAndSettle();

      expect(value!.start, DateTime(2024, 1, 10));
      expect(value!.end, DateTime(2024, 1, 20));
    });
  });

  group('DgaDateRange', () {
    final range = DgaDateRange(
      start: DateTime(2024, 1, 10),
      end: DateTime(2024, 1, 20),
    );

    test('containsInterior is exclusive of both endpoints', () {
      expect(range.containsInterior(DateTime(2024, 1, 15)), isTrue);
      expect(range.containsInterior(DateTime(2024, 1, 10)), isFalse);
      expect(range.containsInterior(DateTime(2024, 1, 20)), isFalse);
      expect(range.containsInterior(DateTime(2024, 1, 21)), isFalse);
    });

    test('isEndpoint ignores the time component', () {
      expect(range.isEndpoint(DateTime(2024, 1, 10, 23, 59)), isTrue);
      expect(range.isEndpoint(DateTime(2024, 1, 11)), isFalse);
    });

    test('a half-picked range is neither complete nor empty', () {
      final half = DgaDateRange(start: DateTime(2024, 1, 10));
      expect(half.isComplete, isFalse);
      expect(half.isEmpty, isFalse);
      expect(half.containsInterior(DateTime(2024, 1, 11)), isFalse);
    });
  });
}
