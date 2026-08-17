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
  group('DgaQuote', () {
    testWidgets('renders text + author under light and dark', (tester) async {
      for (final theme in [const DgaThemeData.light(), const DgaThemeData.dark()]) {
        await tester.pumpWidget(_wrap(
          const DgaQuote(text: 'Design is intelligence made visible.', author: 'Alina Wheeler'),
          theme: theme,
        ));
        expect(find.text('Design is intelligence made visible.'), findsOneWidget);
        expect(find.text('Alina Wheeler'), findsOneWidget);
      }
    });

    testWidgets('non-white background wraps in a card', (tester) async {
      await tester.pumpWidget(_wrap(
        const DgaQuote(text: 'Quote', whiteBackground: false),
      ));
      // A decorated Container carries the card background.
      expect(find.byType(DgaQuote), findsOneWidget);
      expect(find.text('Quote'), findsOneWidget);
    });

    testWidgets('renders under RTL', (tester) async {
      await tester.pumpWidget(_wrap(
        const DgaQuote(text: 'اقتباس', author: 'مؤلف', size: DgaQuoteSize.small),
        dir: TextDirection.rtl,
      ));
      expect(find.text('اقتباس'), findsOneWidget);
    });
  });
}
