import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The overlay arrow is a down-chevron rotated 0 (closed dir) → 0.5 (up) so it
  // points up when open. We assert its rotation turns, scoped to the overlay.
  double? overlayArrowTurns(WidgetTester tester) {
    final rotations = tester.widgetList<AnimatedRotation>(
      find.byType(AnimatedRotation),
    );
    if (rotations.isEmpty) return null;
    return rotations.last.turns; // the overlay arrow
  }

  testWidgets('overlay arrow rotates up on open and back down on close',
      (tester) async {
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

    // Open.
    await tester.tap(find.text('Select'));
    await tester.pump(); // mount
    await tester.pump(); // post-frame flip scheduled
    await tester.pumpAndSettle();

    expect(overlayArrowTurns(tester), 0.5,
        reason: 'arrow points up when open');

    // Close by selecting an item; capture the arrow heading back down.
    await tester.tap(find.text('B').last);
    await tester.pump(); // close starts
    expect(overlayArrowTurns(tester), 0.0,
        reason: 'arrow target flips back to down while closing');

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('CustomDropdownAnimation.none still ends with arrow up',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            animation: CustomDropdownAnimation.none,
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(overlayArrowTurns(tester), 0.5);
  });
}
