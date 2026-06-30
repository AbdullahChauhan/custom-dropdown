import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('custom label widget is used and floats', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.work, key: Key('label_icon'), size: 16),
                SizedBox(width: 4),
                Text('Role'),
              ],
            ),
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    // The custom label (icon + text) is shown.
    expect(find.byKey(const Key('label_icon')), findsOneWidget);
    expect(find.text('Role'), findsOneWidget);
    final restingTop =
        tester.getTopLeft(find.byKey(const Key('label_icon'))).dy;

    // Open -> the custom label floats up.
    await tester.tap(find.byType(CustomDropdown<String>));
    await tester.pumpAndSettle();
    final floatedTop =
        tester.getTopLeft(find.byKey(const Key('label_icon')).first).dy;
    expect(floatedTop, lessThan(restingTop));
  });
}
