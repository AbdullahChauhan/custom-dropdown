import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

// #62: selecting/deselecting must not mutate the caller's (possibly
// unmodifiable) items/initialItems list in place.
void main() {
  testWidgets('multiSelect with const items + initialItems does not crash',
      (tester) async {
    const items = ['A', 'B', 'C']; // const => unmodifiable
    final unmodifiable = List<String>.unmodifiable(const ['A']);
    List<String>? changed;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.multiSelect(
            items: items,
            initialItems: unmodifiable,
            hintText: 'Select',
            onListChanged: (v) => changed = v,
          ),
        ),
      ),
    ));

    await tester.tap(find.byType(CustomDropdown<String>));
    await tester.pumpAndSettle();

    // Add 'B'.
    await tester.tap(find.text('B').last);
    await tester.pumpAndSettle();
    // Remove the initially-selected 'A' (mutating from an unmodifiable source).
    await tester.tap(find.text('A').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(changed, isNotNull);
    expect(changed, contains('B'));
    expect(changed, isNot(contains('A')));
  });
}
