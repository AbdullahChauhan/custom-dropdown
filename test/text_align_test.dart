import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('textAlign reaches header, hint and list items', (tester) async {
    await tester.pumpWidget(host(
      CustomDropdown<String>(
        items: const ['Apple', 'Banana'],
        hintText: 'Select',
        textAlign: TextAlign.center,
        onChanged: (_) {},
      ),
    ));

    // Closed-field hint is centered.
    expect(
      tester.widget<Text>(find.text('Select')).textAlign,
      TextAlign.center,
    );

    // Open: list items are centered.
    await tester.tap(find.byType(CustomDropdown<String>));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('Apple')).textAlign,
      TextAlign.center,
    );
  });

  testWidgets('textAlign reaches the search field and no-result text',
      (tester) async {
    await tester.pumpWidget(host(
      CustomDropdown<String>.searchRequest(
        futureRequest: (_) async => <String>[],
        hintText: 'Select',
        noResultFoundText: 'No result found.',
        textAlign: TextAlign.end,
        onChanged: (_) {},
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    // Search input is end-aligned.
    expect(
      tester.widget<TextField>(find.byType(TextField)).textAlign,
      TextAlign.end,
    );

    // Empty search -> no-result text is end-aligned.
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('No result found.')).textAlign,
      TextAlign.end,
    );
  });

  testWidgets('textAlign reaches the floating label', (tester) async {
    await tester.pumpWidget(host(
      CustomDropdown<String>(
        items: const ['Apple', 'Banana'],
        labelText: 'Fruit',
        textAlign: TextAlign.center,
        onChanged: (_) {},
      ),
    ));

    expect(
      tester.widget<Text>(find.text('Fruit')).textAlign,
      TextAlign.center,
    );
  });
}
