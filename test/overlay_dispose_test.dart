import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

// Guards the overlay-teardown fixes from #109:
// - search request completing after the field is disposed must not throw
//   (mounted guards in _SearchField.searchRequest)
// - hiding the overlay must not trip a SchedulerPhase assertion
//   (animationDismissed deferred to a post-frame callback)
void main() {
  testWidgets('search request completing after dispose does not throw',
      (tester) async {
    final completer = Completer<List<String>>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.searchRequest(
            futureRequest: (_) => completer.future,
            hintText: 'Select',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    // Open and trigger an in-flight request.
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();

    // Tear the whole tree down while the request is still pending.
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));

    // Now resolve the future — the disposed search field must ignore it.
    completer.complete(['abc']);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting an item closes the overlay without throwing',
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

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    // Select an item -> overlay animates out -> animationDismissed -> hide.
    await tester.tap(find.text('B').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsNothing); // overlay gone
    expect(find.text('B'), findsOneWidget); // selection shown in field
  });
}
