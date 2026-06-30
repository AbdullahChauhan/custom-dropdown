import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Finder labelFinder(String text) => find.text(text);

  testWidgets('label rests inside, then floats up when opened (#111)',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            labelText: 'Role',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    expect(labelFinder('Role'), findsOneWidget);
    final restingTop = tester.getTopLeft(labelFinder('Role')).dy;
    final restingSize = tester.getSize(labelFinder('Role')).height;

    // Open the dropdown -> label should float up (smaller + higher).
    await tester.tap(find.byType(CustomDropdown<String>));
    await tester.pumpAndSettle();

    final floatedTop = tester.getTopLeft(labelFinder('Role').first).dy;
    final floatedSize = tester.getSize(labelFinder('Role').first).height;

    expect(floatedTop, lessThan(restingTop),
        reason: 'label should move up when floated');
    expect(floatedSize, lessThan(restingSize),
        reason: 'label should shrink when floated');
  });

  testWidgets('label floats and stays up when a value is selected (#111)',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            initialItem: 'B',
            labelText: 'Role',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    // With a value, both the floated label and the selected value are visible.
    expect(find.text('Role'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('no labelText keeps the plain hint (#111)', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    expect(find.text('Select'), findsOneWidget);
  });
}
