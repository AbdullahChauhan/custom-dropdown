import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('default: tapping a list item selects it (#80)', (tester) async {
    String? selected;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('B').last);
    await tester.pumpAndSettle();

    expect(selected, 'B');
  });

  testWidgets(
      'selectOnItemTap:false — row tap does not select; builder owns it',
      (tester) async {
    final selections = <String>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            selectOnItemTap: false,
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Row(
                children: [
                  Expanded(child: Text(item)),
                  // Only this button selects — tapping the row text must not.
                  IconButton(
                    key: Key('pick_$item'),
                    icon: const Icon(Icons.check),
                    onPressed: onItemSelect,
                  ),
                ],
              );
            },
            onChanged: (v) => selections.add(v!),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    // Tapping the item text should NOT select when selectOnItemTap is false.
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(selections, isEmpty, reason: 'row tap must not auto-select');

    // The builder's own control triggers selection.
    await tester.tap(find.byKey(const Key('pick_B')));
    await tester.pumpAndSettle();
    expect(selections, ['B']);
  });
}
