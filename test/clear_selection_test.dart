import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('canClearSelection resets single-select to null (#106)',
      (tester) async {
    final changes = <String?>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            initialItem: 'B',
            hintText: 'Select',
            canClearSelection: true,
            onChanged: (v) => changes.add(v),
          ),
        ),
      ),
    ));

    // Selection shown, clear button present.
    expect(find.text('B'), findsOneWidget);
    expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

    // Tap clear -> selection reset, hint shown again, onChanged(null) fired.
    await tester.tap(find.byIcon(Icons.clear_rounded));
    await tester.pumpAndSettle();

    expect(changes.last, isNull);
    expect(find.text('Select'), findsOneWidget);
    expect(find.byIcon(Icons.clear_rounded), findsNothing,
        reason: 'clear button hidden once there is no selection');
  });

  testWidgets('no clear button when canClearSelection is false', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            initialItem: 'B',
            hintText: 'Select',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    expect(find.byIcon(Icons.clear_rounded), findsNothing);
  });
}
