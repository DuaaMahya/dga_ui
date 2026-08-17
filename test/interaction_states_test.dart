import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {DgaThemeData? theme}) => MaterialApp(
  home: DgaTheme(
    data: theme ?? const DgaThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);

/// Current horizontal scale of a field's bottom underline: 0 = hidden,
/// `kDgaFieldPressStub` = press stub, 1 = fully expanded.
///
/// Identified by the only `Transform` wrapping a 2px-tall `Container` — the
/// dropdown also has a `Transform` for its chevron rotation.
double _underlineScale(WidgetTester tester) {
  final transform = tester
      .widgetList<Transform>(find.byType(Transform))
      .firstWhere((t) {
        final child = t.child;
        return child is Container && child.constraints?.maxHeight == 2;
      }, orElse: () => throw StateError('no underline Transform found'));
  return transform.transform.getColumn(0)[0];
}

/// The halo behind a control is the first AnimatedContainer inside the
/// DgaControlHalo stack — it has no child of its own.
Color _haloColor(WidgetTester tester, Type controlType) {
  final container = tester.widget<AnimatedContainer>(
    find
        .descendant(
          of: find.byType(controlType),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
  return (container.decoration! as BoxDecoration).color!;
}

void main() {
  group('Field press → underline stub → focus expands', () {
    testWidgets('DgaTextInput', (tester) async {
      await tester.pumpWidget(_wrap(const DgaTextInput(hintText: 'Type')));
      expect(_underlineScale(tester), 0);

      // Press and hold: the stub animates in, but stops short of full width.
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaTextInput)),
      );
      await tester.pump();
      await tester.pump(kDgaFieldPressDuration);
      final stub = _underlineScale(tester);
      expect(stub, greaterThan(0));
      expect(stub, lessThan(1));
      expect(stub, moreOrLessEquals(kDgaFieldPressStub, epsilon: 0.02));

      // Release lands focus, which carries the stub out to full width.
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_underlineScale(tester), moreOrLessEquals(1, epsilon: 0.01));
    });

    testWidgets('DgaTextarea', (tester) async {
      await tester.pumpWidget(_wrap(const DgaTextarea(hintText: 'Type')));
      expect(_underlineScale(tester), 0);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaTextarea)),
      );
      await tester.pump();
      await tester.pump(kDgaFieldPressDuration);
      final stub = _underlineScale(tester);
      expect(stub, greaterThan(0));
      expect(stub, lessThan(1));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(_underlineScale(tester), moreOrLessEquals(1, epsilon: 0.01));
    });

    testWidgets('DgaDropdownInput', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DgaDropdownInput<int>(
            items: const [DgaDropdownEntry(value: 1, label: 'One')],
            value: null,
            onChanged: (_) {},
            hintText: 'Pick',
          ),
        ),
      );
      expect(_underlineScale(tester), 0);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Pick')),
      );
      await tester.pump();
      await tester.pump(kDgaFieldPressDuration);
      final stub = _underlineScale(tester);
      expect(stub, greaterThan(0));
      expect(stub, lessThan(1));

      // Releasing opens the menu, which expands the stub to full width.
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_underlineScale(tester), moreOrLessEquals(1, epsilon: 0.01));
    });
  });

  group('Re-pressing an already-focused field stays in the focus state', () {
    testWidgets('DgaTextInput', (tester) async {
      await tester.pumpWidget(_wrap(const DgaTextInput(hintText: 'Type')));

      // Focus it first.
      await tester.tap(find.byType(DgaTextInput));
      await tester.pumpAndSettle();
      expect(_underlineScale(tester), moreOrLessEquals(1, epsilon: 0.01));

      // Press again — the underline must not shrink back to the stub.
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaTextInput)),
      );
      await tester.pump();
      await tester.pump(kDgaFieldPressDuration);
      expect(
        _underlineScale(tester),
        moreOrLessEquals(1, epsilon: 0.01),
        reason: 'a focused field dropped back to the press stub',
      );

      await gesture.up();
      await tester.pumpAndSettle();
      expect(_underlineScale(tester), moreOrLessEquals(1, epsilon: 0.01));
    });

    testWidgets('DgaTextarea', (tester) async {
      await tester.pumpWidget(_wrap(const DgaTextarea(hintText: 'Type')));

      await tester.tap(find.byType(DgaTextarea));
      await tester.pumpAndSettle();
      expect(_underlineScale(tester), moreOrLessEquals(1, epsilon: 0.01));

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaTextarea)),
      );
      await tester.pump();
      await tester.pump(kDgaFieldPressDuration);
      expect(
        _underlineScale(tester),
        moreOrLessEquals(1, epsilon: 0.01),
        reason: 'a focused textarea dropped back to the press stub',
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('DgaDropdownInput stays full-width while open', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DgaDropdownInput<int>(
            items: const [DgaDropdownEntry(value: 1, label: 'One')],
            value: null,
            onChanged: (_) {},
            hintText: 'Pick',
          ),
        ),
      );

      await tester.tap(find.text('Pick'));
      await tester.pumpAndSettle();
      expect(_underlineScale(tester), moreOrLessEquals(1, epsilon: 0.01));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Pick')),
      );
      await tester.pump();
      await tester.pump(kDgaFieldPressDuration);
      expect(
        _underlineScale(tester),
        moreOrLessEquals(1, epsilon: 0.01),
        reason: 'an open dropdown dropped back to the press stub',
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });

  group('Control press halo', () {
    testWidgets('DgaCheckbox halo fades in on press', (tester) async {
      await tester.pumpWidget(
        _wrap(DgaCheckbox(value: false, onChanged: (_) {})),
      );
      expect(_haloColor(tester, DgaCheckbox).a, 0);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaCheckbox)),
      );
      await tester.pumpAndSettle();
      expect(_haloColor(tester, DgaCheckbox).a, greaterThan(0));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(_haloColor(tester, DgaCheckbox).a, 0);
    });

    testWidgets('DgaRadio halo fades in on press', (tester) async {
      await tester.pumpWidget(
        _wrap(DgaRadio<int>(value: 1, groupValue: 2, onChanged: (_) {})),
      );
      expect(_haloColor(tester, DgaRadio<int>).a, 0);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaRadio<int>)),
      );
      await tester.pumpAndSettle();
      expect(_haloColor(tester, DgaRadio<int>).a, greaterThan(0));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(_haloColor(tester, DgaRadio<int>).a, 0);
    });

    testWidgets('DgaSwitch halo fades in on press', (tester) async {
      await tester.pumpWidget(
        _wrap(DgaSwitch(value: false, onChanged: (_) {})),
      );
      expect(_haloColor(tester, DgaSwitch).a, 0);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaSwitch)),
      );
      await tester.pumpAndSettle();
      expect(_haloColor(tester, DgaSwitch).a, greaterThan(0));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(_haloColor(tester, DgaSwitch).a, 0);
    });

    testWidgets('disabled control never shows a halo', (tester) async {
      await tester.pumpWidget(
        _wrap(DgaCheckbox(value: false, onChanged: (_) {}, disabled: true)),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DgaCheckbox)),
      );
      await tester.pumpAndSettle();
      expect(_haloColor(tester, DgaCheckbox).a, 0);
      await gesture.up();
    });
  });

  group('DgaCard hover/press background wash', () {
    Color cardColor(WidgetTester tester) {
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(DgaCard),
          matching: find.byType(AnimatedContainer),
        ),
      );
      return (container.decoration! as BoxDecoration).color!;
    }

    testWidgets('default stroke effect washes on hover, deepens on press', (
      tester,
    ) async {
      // FocusableActionDetector only reports hover in
      // FocusHighlightMode.traditional; `flutter test` defaults
      // defaultTargetPlatform to Android (touch mode), so hover never fires
      // unless the test forces traditional mode explicitly.
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );

      await tester.pumpWidget(
        _wrap(DgaCard(onTap: () {}, child: const Text('x'))),
      );
      final restColor = cardColor(tester);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(DgaCard)));
      await tester.pumpAndSettle();
      final hoverColor = cardColor(tester);
      expect(
        hoverColor,
        isNot(equals(restColor)),
        reason: 'stroke-effect card had no hover feedback at all',
      );

      await gesture.down(tester.getCenter(find.byType(DgaCard)));
      await tester.pumpAndSettle();
      final pressColor = cardColor(tester);
      expect(
        pressColor,
        isNot(equals(hoverColor)),
        reason: 'press must read as a deeper step than hover',
      );
      expect(pressColor, isNot(equals(restColor)));

      await gesture.up();
    });

    testWidgets('non-interactive card never washes', (tester) async {
      await tester.pumpWidget(_wrap(const DgaCard(child: Text('x'))));
      final restColor = cardColor(tester);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(DgaCard)));
      await tester.pumpAndSettle();

      expect(cardColor(tester), restColor);
    });
  });
}
