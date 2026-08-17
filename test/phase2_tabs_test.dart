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
  group('DgaHorizontalTab', () {
    testWidgets('tap selects; builds under light+dark', (tester) async {
      var index = 0;
      for (final theme in [const DgaThemeData.light(), const DgaThemeData.dark()]) {
        await tester.pumpWidget(_wrap(
          StatefulBuilder(
            builder: (context, setState) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++)
                  DgaHorizontalTab(
                    label: 'Tab $i',
                    selected: index == i,
                    onTap: () => setState(() => index = i),
                  ),
              ],
            ),
          ),
          theme: theme,
        ));
        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();
        expect(index, 2);
        index = 0;
      }
    });

    testWidgets('disabled tab does not select', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        DgaHorizontalTab(label: 'Off', selected: false, disabled: true, onTap: () => tapped = true),
      ));
      await tester.tap(find.byType(DgaHorizontalTab), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    testWidgets('height matches size', (tester) async {
      await tester.pumpWidget(_wrap(Center(
        child: DgaHorizontalTab(
          label: 'L',
          selected: true,
          size: DgaHorizontalTabSize.large,
          onTap: () {},
        ),
      )));
      expect(tester.getSize(find.byType(DgaHorizontalTab)).height, 52);
    });
  });

  group('DgaVerticalTab', () {
    testWidgets('tap selects and renders under RTL', (tester) async {
      var index = 0;
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++)
                DgaVerticalTab(
                  label: 'الخيار $i',
                  selected: index == i,
                  onTap: () => setState(() => index = i),
                ),
            ],
          ),
        ),
        dir: TextDirection.rtl,
      ));
      await tester.tap(find.text('الخيار 1'));
      await tester.pumpAndSettle();
      expect(index, 1);
    });
  });
}
