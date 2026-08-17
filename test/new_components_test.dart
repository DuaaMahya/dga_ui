import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {DgaThemeData? theme}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Scaffold(body: child),
  ),
);

void main() {
  group('DgaCloseButton', () {
    testWidgets('builds under Light/Dark and taps fire', (tester) async {
      var count = 0;
      for (final theme in [
        const DgaThemeData.light(),
        const DgaThemeData.dark(),
      ]) {
        await tester.pumpWidget(
          _wrap(DgaCloseButton(onPressed: () => count++), theme: theme),
        );
        expect(find.byIcon(Icons.close), findsOneWidget);
      }
      await tester.tap(find.byIcon(Icons.close));
      expect(count, 1);
    });

    testWidgets('size.medium = 32×32; disabled blocks taps', (tester) async {
      var count = 0;
      await tester.pumpWidget(
        _wrap(
          Center(
            child: DgaCloseButton(onPressed: () => count++, disabled: true),
          ),
        ),
      );
      final size = tester.getSize(find.byType(DgaCloseButton));
      expect(size, const Size(32, 32));
      await tester.tap(find.byType(DgaCloseButton), warnIfMissed: false);
      expect(count, 0);
    });
  });

  group('DgaMenuButton', () {
    testWidgets('all six factories build with a trailing chevron', (
      tester,
    ) async {
      final buttons = <Widget>[
        DgaMenuButton.primary(onPressed: () {}, label: 'A'),
        DgaMenuButton.neutral(onPressed: () {}, label: 'B'),
        DgaMenuButton.secondarySolid(onPressed: () {}, label: 'C'),
        DgaMenuButton.secondaryOutline(onPressed: () {}, label: 'D'),
        DgaMenuButton.subtle(onPressed: () {}, label: 'E'),
        DgaMenuButton.transparent(onPressed: () {}, label: 'F'),
      ];
      await tester.pumpWidget(_wrap(Column(children: buttons)));
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNWidgets(6));
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('height matches DgaButtonSize.height', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: DgaMenuButton.primary(
              onPressed: () {},
              label: 'X',
              size: DgaButtonSize.small,
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(DgaMenuButton)).height, 24);
    });
  });

  group('DgaFloatingButton', () {
    testWidgets('icon-only is circular; extended renders label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              DgaFloatingButton.primaryBrand(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
              DgaFloatingButton.primaryNeutral(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: 'Edit',
              ),
            ],
          ),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('large icon-only is 64×64', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: DgaFloatingButton.primaryBrand(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(DgaFloatingButton)),
        const Size(64, 64),
      );
    });
  });

  group('DgaLink', () {
    testWidgets('renders as a link with tap + visited', (tester) async {
      var count = 0;
      await tester.pumpWidget(
        _wrap(
          DgaLink(onPressed: () => count++, label: 'Read more', visited: true),
        ),
      );
      expect(find.text('Read more'), findsOneWidget);
      await tester.tap(find.text('Read more'));
      expect(count, 1);
    });

    testWidgets('disabled swallows taps', (tester) async {
      var count = 0;
      await tester.pumpWidget(
        _wrap(DgaLink(onPressed: () => count++, label: 'Nope', disabled: true)),
      );
      await tester.tap(find.text('Nope'), warnIfMissed: false);
      expect(count, 0);
    });
  });

  group('DgaChip', () {
    testWidgets('selected + onDeleted render correctly', (tester) async {
      var deleted = 0;
      await tester.pumpWidget(
        _wrap(
          DgaChip(
            onPressed: () {},
            label: 'Filter',
            selected: true,
            onDeleted: () => deleted++,
          ),
        ),
      );
      expect(find.text('Filter'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      expect(deleted, 1);
    });
  });

  group('DgaTag', () {
    testWidgets('renders every style + outline variant', (tester) async {
      final tags = <Widget>[
        for (final s in DgaTagStyle.values) ...[
          DgaTag(label: s.name, style: s),
          DgaTag(label: s.name, style: s, outline: true),
        ],
      ];
      await tester.pumpWidget(_wrap(Wrap(children: tags)));
      for (final s in DgaTagStyle.values) {
        expect(find.text(s.name), findsNWidgets(2));
      }
    });

    testWidgets('is NOT a button (no Semantics button flag)', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_wrap(const DgaTag(label: 'x')));
      // Tag is static — it should not report as button.
      final semantics = tester.getSemantics(find.byType(DgaTag));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isFalse);
      handle.dispose();
    });
  });

  group('DgaStatusTag', () {
    testWidgets('renders every color × status combo', (tester) async {
      final tags = <Widget>[
        for (final c in DgaStatusTagColor.values)
          for (final s in DgaStatusTagStatus.values)
            DgaStatusTag(label: '${c.name}-${s.name}', type: c, status: s),
      ];
      await tester.pumpWidget(_wrap(Wrap(children: tags)));
      expect(find.textContaining('subtle'), findsWidgets);
      expect(find.textContaining('ghost'), findsWidgets);
      expect(find.textContaining('inverted'), findsWidgets);
    });
  });
}
