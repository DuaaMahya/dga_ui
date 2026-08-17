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
  group('DgaProgressBar', () {
    testWidgets('builds across styles/sizes and shows % label', (tester) async {
      for (final theme in [const DgaThemeData.light(), const DgaThemeData.dark()]) {
        await tester.pumpWidget(_wrap(
          const SizedBox(
            width: 200,
            child: DgaProgressBar(value: 0.6, showLabel: true),
          ),
          theme: theme,
        ));
        expect(find.text('60%'), findsOneWidget);
      }
    });

    testWidgets('error + success recolor without crashing', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 200,
        child: Column(children: [
          DgaProgressBar(value: 0.0, error: true),
          DgaProgressBar(value: 1.0, success: true),
          DgaProgressBar(value: 0.5, style: DgaProgressBarStyle.neutral),
        ]),
      )));
      expect(find.byType(DgaProgressBar), findsNWidgets(3));
    });

    testWidgets('renders under RTL', (tester) async {
      await tester.pumpWidget(_wrap(
        const SizedBox(width: 200, child: DgaProgressBar(value: 0.3)),
        dir: TextDirection.rtl,
      ));
      expect(find.byType(DgaProgressBar), findsOneWidget);
    });
  });

  group('DgaCircularProgressBar', () {
    testWidgets('shows centered % and builds every style', (tester) async {
      for (final s in DgaCircularProgressStyle.values) {
        await tester.pumpWidget(_wrap(
          DgaCircularProgressBar(value: 0.42, style: s, size: 100),
        ));
        expect(find.text('42%'), findsOneWidget);
      }
    });
  });

  group('DgaCircleStepper', () {
    testWidgets('renders n/N', (tester) async {
      await tester.pumpWidget(_wrap(const DgaCircleStepper(current: 2, total: 4)));
      expect(find.textContaining('2'), findsOneWidget);
    });
  });

  group('DgaRadialStepper', () {
    testWidgets('renders ring + subtitle; light and dark', (tester) async {
      for (final theme in [const DgaThemeData.light(), const DgaThemeData.dark()]) {
        await tester.pumpWidget(_wrap(
          const DgaRadialStepper(current: 1, total: 3, title: 'Setup'),
          theme: theme,
        ));
        expect(find.byType(DgaCircleStepper), findsOneWidget);
        expect(find.text('Setup'), findsOneWidget);
        expect(find.textContaining('step'), findsOneWidget);
      }
    });
  });
}
