import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

// #72: with the default canCloseOutsideBounds (true), the page behind the open
// overlay must not scroll — the full-screen close barrier absorbs the gesture.
void main() {
  testWidgets('open overlay blocks background scroll by default (#72)',
      (tester) async {
    final ctrl = ScrollController();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          controller: ctrl,
          children: [
            const SizedBox(height: 30),
            CustomDropdown<String>(
              items: const ['A', 'B', 'C'],
              hintText: 'Select',
              onChanged: (_) {},
            ),
            for (int i = 0; i < 40; i++)
              SizedBox(height: 60, child: Text('row$i')),
          ],
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    expect(ctrl.offset, 0.0);
    // Drag below the overlay — the barrier should swallow it.
    await tester.dragFrom(const Offset(200, 480), const Offset(0, -200));
    await tester.pumpAndSettle();

    expect(ctrl.offset, 0.0, reason: 'background must not scroll while open');
  });
}
