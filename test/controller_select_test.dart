import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// #100: controllers expose explicit selection methods.
void main() {
  test('SingleSelectController.select / clear', () {
    final c = SingleSelectController<String>(null);
    expect(c.hasValue, isFalse);

    c.select('A');
    expect(c.value, 'A');
    expect(c.hasValue, isTrue);

    c.clear();
    expect(c.value, isNull);
  });

  test('MultiSelectController.select / toggle / clear', () {
    final c = MultiSelectController<String>([]);

    c.select(['A', 'B']);
    expect(c.value, ['A', 'B']);

    c.toggle('B'); // remove
    expect(c.value, ['A']);
    c.toggle('C'); // add
    expect(c.value, ['A', 'C']);

    c.clear();
    expect(c.value, isEmpty);
  });

  testWidgets('controller.select drives the dropdown selection (#100)',
      (tester) async {
    final controller = SingleSelectController<String>(null);
    String? changed;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            controller: controller,
            hintText: 'Select',
            onChanged: (v) => changed = v,
          ),
        ),
      ),
    ));

    controller.select('B');
    await tester.pumpAndSettle();

    expect(changed, 'B');
    expect(find.text('B'), findsOneWidget);
  });
}
