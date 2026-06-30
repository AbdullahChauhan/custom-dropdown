import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<double> labelToFieldGap(WidgetTester tester, double gap) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            labelText: 'Role',
            initialItem: 'A', // floated
            decoration: CustomDropdownDecoration(floatingLabelGap: gap),
            onChanged: (_) {},
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    // Distance from the floated label down to the field's header text.
    final labelBottom = tester.getRect(find.text('Role')).bottom;
    final fieldTop = tester.getRect(find.text('A')).top;
    return fieldTop - labelBottom;
  }

  testWidgets('floatingLabelGap widens the label-to-field spacing',
      (tester) async {
    final small = await labelToFieldGap(tester, 8);
    final large = await labelToFieldGap(tester, 32);
    expect(large, greaterThan(small),
        reason: 'a larger floatingLabelGap increases the spacing');
  });
}
