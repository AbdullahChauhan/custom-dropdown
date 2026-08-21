import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

// #89: a custom listItemBuilder with its own interactive widgets must work even
// with the default canCloseOutsideBounds:true (the close barrier must not steal
// taps meant for the list items).
void main() {
  testWidgets('custom item inner control + row select work with the barrier on',
      (tester) async {
    final innerTaps = <String>[];
    final selects = <String>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            // defaults: canCloseOutsideBounds: true, selectOnItemTap: true
            onChanged: (v) => selects.add(v!),
            listItemBuilder: (ctx, item, isSelected, onItemSelect) => Row(
              children: [
                Expanded(child: Text(item)),
                GestureDetector(
                  key: Key('inner_$item'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => innerTaps.add(item),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.info_outline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    // Inner control gets its own tap; no selection, overlay stays open.
    await tester.tap(find.byKey(const Key('inner_B')));
    await tester.pumpAndSettle();
    expect(innerTaps, ['B']);
    expect(selects, isEmpty);
    expect(find.byKey(const Key('inner_A')), findsOneWidget); // still open

    // Tapping the row text still selects.
    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();
    expect(selects, ['C']);
  });
}
