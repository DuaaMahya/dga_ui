import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

const _five = [
  DgaTabBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
  DgaTabBarItem(icon: Icon(Icons.search), label: 'Search'),
  DgaTabBarItem(icon: Icon(Icons.bookmark_border), label: 'Saved'),
  DgaTabBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
  DgaTabBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
];

Widget _wrap(
  Widget child, {
  DgaThemeData? theme,
  TextDirection dir = TextDirection.ltr,
  double width = 375,
}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Directionality(
      textDirection: dir,
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);

DgaTabBar _bar({
  List<DgaTabBarItem> items = _five,
  int? selectedIndex = 0,
  ValueChanged<int>? onChanged,
  bool onColor = false,
}) => DgaTabBar(
  items: items,
  selectedIndex: selectedIndex,
  onChanged: onChanged ?? (_) {},
  onColor: onColor,
  // Insets are a device concern; keep the geometry assertions exact.
  safeArea: false,
);

/// Colour the icon actually resolves to, read from the merged [IconTheme]
/// the bar installs above it.
Color _iconColor(WidgetTester tester, IconData icon) =>
    IconTheme.of(tester.element(find.byIcon(icon))).color!;

Color _labelColor(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style!.color!;

/// The bar paints two flat rules — the top hairline and the selected
/// indicator — so they're told apart by colour.
Finder _rule(Color color) => find.descendant(
  of: find.byType(DgaTabBar),
  matching: find.byWidgetPredicate((w) => w is ColoredBox && w.color == color),
);

void main() {
  const light = DgaThemeData.light();
  final c = light.colors;

  group('DgaTabBar', () {
    testWidgets('renders one tab per item, whatever the count', (tester) async {
      for (final count in [2, 3, 5, 7]) {
        final items = [
          for (var i = 0; i < count; i++)
            DgaTabBarItem(icon: const Icon(Icons.circle), label: 'Tab $i'),
        ];
        await tester.pumpWidget(_wrap(_bar(items: items)));

        for (var i = 0; i < count; i++) {
          expect(find.text('Tab $i'), findsOneWidget);
        }
      }
    });

    testWidgets('tabs split the bar evenly', (tester) async {
      await tester.pumpWidget(_wrap(_bar(items: _five.take(3).toList())));

      final bar = tester.getRect(find.byType(DgaTabBar));
      final first = tester.getCenter(find.text('Home')).dx;
      final second = tester.getCenter(find.text('Search')).dx;
      final third = tester.getCenter(find.text('Saved')).dx;

      expect(second - first, closeTo(bar.width / 3, 0.5));
      expect(third - second, closeTo(bar.width / 3, 0.5));
    });

    testWidgets('tapping a tab reports its index', (tester) async {
      final taps = <int>[];
      await tester.pumpWidget(_wrap(_bar(onChanged: taps.add)));

      await tester.tap(find.text('Saved'));
      await tester.tap(find.byIcon(Icons.person_outline));
      expect(taps, [2, 3]);
    });

    testWidgets('selected tab takes the brand foreground, others stay muted', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_bar(selectedIndex: 1)));

      expect(_iconColor(tester, Icons.search), c.iconPrimary);
      expect(_labelColor(tester, 'Search'), c.textPrimary);

      expect(_iconColor(tester, Icons.home_outlined), c.iconDefault500);
      expect(_labelColor(tester, 'Home'), c.textSecondaryParagraph);
    });

    testWidgets('the label weight does not change when selected', (
      tester,
    ) async {
      // Figma binds text-xs/Medium to both Normal and Selected; only the
      // colour differs. A bolder selected label would be off-spec.
      await tester.pumpWidget(_wrap(_bar(selectedIndex: 1)));

      expect(
        tester.widget<Text>(find.text('Search')).style!.fontWeight,
        tester.widget<Text>(find.text('Home')).style!.fontWeight,
      );
    });

    testWidgets('the indicator sits on the top edge, above the icon', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_bar(selectedIndex: 1)));

      final indicator = tester.getRect(_rule(c.borderPrimary));
      final bar = tester.getRect(find.byType(DgaTabBar));
      final icon = tester.getRect(find.byIcon(Icons.search));

      // Flush with the top of the tab row, which the hairline pushes down 1px.
      expect(indicator.top, closeTo(bar.top + 1, 0.5));
      expect(
        indicator.bottom,
        lessThan(icon.top),
        reason: 'it is a top rule, not a bottom one',
      );
      expect(indicator.height, 1);
      expect(
        indicator.width,
        closeTo(bar.width / _five.length, 0.5),
        reason: 'it spans only the selected tab',
      );
      expect(
        indicator.center.dx,
        closeTo(icon.center.dx, 0.5),
        reason: 'over the selected tab, not another one',
      );
    });

    testWidgets('the indicator does not change the bar height', (tester) async {
      // A real top border would add a pixel and make a selected tab taller
      // than its neighbours; the overlay must not.
      await tester.pumpWidget(_wrap(_bar(selectedIndex: null)));
      final unselected = tester.getSize(find.byType(DgaTabBar)).height;

      await tester.pumpWidget(_wrap(_bar(selectedIndex: 2)));
      final selected = tester.getSize(find.byType(DgaTabBar)).height;

      expect(unselected, selected);
      expect(
        selected,
        kDgaTabBarItemHeight + 1,
        reason: '70px tab row plus the 1px top hairline',
      );
    });

    testWidgets('selectedIndex: null selects nothing', (tester) async {
      await tester.pumpWidget(_wrap(_bar(selectedIndex: null)));

      expect(_rule(c.borderPrimary), findsNothing);
      expect(_iconColor(tester, Icons.home_outlined), c.iconDefault500);
    });

    testWidgets('pressing a tab previews the brand foreground', (tester) async {
      await tester.pumpWidget(_wrap(_bar(selectedIndex: 0)));
      expect(_iconColor(tester, Icons.search), c.iconDefault500);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Search')),
      );
      await tester.pump();
      expect(_iconColor(tester, Icons.search), c.iconPrimary);
      expect(_labelColor(tester, 'Search'), c.textPrimary);
      expect(
        _rule(c.borderPrimary),
        findsOneWidget,
        reason: 'pressing must not draw a second indicator',
      );

      await gesture.up();
      await tester.pump();
      expect(_iconColor(tester, Icons.search), c.iconDefault500);
    });

    testWidgets('on-color swaps the surface and the whole foreground ramp', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_bar(selectedIndex: 1, onColor: true)));

      final surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DgaTabBar),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(surface.color, c.backgroundPrimary);

      expect(_iconColor(tester, Icons.search), c.iconOncolor);
      expect(_labelColor(tester, 'Search'), c.textOncolorPrimary);
      expect(
        _iconColor(tester, Icons.home_outlined),
        DgaPrimitives.alphaWhite50,
      );
      expect(_rule(c.borderBackgroundWhite), findsOneWidget);
      expect(
        _rule(c.borderNeutralSecondary),
        findsNothing,
        reason: 'no neutral hairline over the green surface',
      );
    });

    testWidgets('on-color press brightens toward white', (tester) async {
      await tester.pumpWidget(_wrap(_bar(selectedIndex: 0, onColor: true)));
      expect(_iconColor(tester, Icons.search), DgaPrimitives.alphaWhite50);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Search')),
      );
      await tester.pump();
      expect(_iconColor(tester, Icons.search), DgaPrimitives.alphaWhite70);

      await gesture.up();
      await tester.pump();
      expect(_iconColor(tester, Icons.search), DgaPrimitives.alphaWhite50);
    });

    testWidgets('selectedIcon takes over only while selected', (tester) async {
      const items = [
        DgaTabBarItem(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        DgaTabBarItem(icon: Icon(Icons.search), label: 'Search'),
      ];

      await tester.pumpWidget(_wrap(_bar(items: items, selectedIndex: 0)));
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsNothing);

      await tester.pumpWidget(_wrap(_bar(items: items, selectedIndex: 1)));
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.home), findsNothing);

      // No selectedIcon supplied — the base icon just recolours.
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(_iconColor(tester, Icons.search), c.iconPrimary);
    });

    testWidgets('the badge rides the icon and mirrors under RTL', (
      tester,
    ) async {
      const items = [
        DgaTabBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        DgaTabBarItem(
          icon: Icon(Icons.mail_outline),
          label: 'Inbox',
          badge: DgaBadge.count(150),
        ),
        DgaTabBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ];

      for (final dir in [TextDirection.ltr, TextDirection.rtl]) {
        await tester.pumpWidget(
          _wrap(_bar(items: items, selectedIndex: 0), dir: dir),
        );

        expect(find.text('99+'), findsOneWidget);
        final badge = tester.getRect(find.byType(DgaBadge));
        final icon = tester.getRect(find.byIcon(Icons.mail_outline));

        expect(
          badge.top,
          closeTo(icon.top - kDgaTabBarBadgeRise, 0.5),
          reason: 'it rises above the icon',
        );
        if (dir == TextDirection.ltr) {
          expect(
            badge.left,
            closeTo(icon.center.dx, 0.5),
            reason: 'LTR: leading edge on the icon centre line',
          );
        } else {
          expect(
            badge.right,
            closeTo(icon.center.dx, 0.5),
            reason: 'RTL: mirrored to the other side',
          );
        }
      }
    });

    testWidgets('safeArea reserves the bottom inset below the tabs', (
      tester,
    ) async {
      Widget withInset({required bool safeArea}) => MaterialApp(
        home: DgaTheme(
          data: light,
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(bottom: 34)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 375,
                  child: DgaTabBar(
                    items: _five,
                    selectedIndex: 0,
                    onChanged: (_) {},
                    safeArea: safeArea,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(withInset(safeArea: false));
      final bare = tester.getSize(find.byType(DgaTabBar)).height;

      await tester.pumpWidget(withInset(safeArea: true));
      final padded = tester.getRect(find.byType(DgaTabBar));

      expect(padded.height, bare + 34);
      expect(
        tester.getRect(find.text('Home')).bottom,
        lessThan(padded.bottom - 34),
        reason: 'the tabs sit above the home-indicator strip',
      );
    });

    testWidgets('exposes each tab as a selectable button to a11y', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_wrap(_bar(selectedIndex: 1)));

      final selected = tester.getSemantics(find.bySemanticsLabel('Search'));
      expect(selected.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(selected.hasFlag(SemanticsFlag.isSelected), isTrue);
      expect(
        selected.label,
        'Search',
        reason: 'the tab node must not announce its label twice',
      );

      final other = tester.getSemantics(find.bySemanticsLabel('Home'));
      expect(other.hasFlag(SemanticsFlag.isSelected), isFalse);

      handle.dispose();
    });

    testWidgets('builds under dark', (tester) async {
      await tester.pumpWidget(
        _wrap(_bar(selectedIndex: 1), theme: const DgaThemeData.dark()),
      );
      const dark = DgaThemeData.dark();
      expect(_iconColor(tester, Icons.search), dark.colors.iconPrimary);
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
