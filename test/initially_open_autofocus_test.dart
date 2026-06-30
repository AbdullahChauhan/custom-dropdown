import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('initiallyOpen opens the overlay on first build (#87)',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.search(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            initiallyOpen: true,
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    // No tap — the overlay (its search field + items) should already be shown.
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('overlay stays closed by default (#87 control)', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.search(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('autofocusOnSearch focuses the search field on open (#70)',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.search(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            autofocusOnSearch: true,
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode?.hasFocus, isTrue);
  });
}
