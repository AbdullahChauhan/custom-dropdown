import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

// Locks the "no result found" behavior for the search-request variants (#112):
// nothing is shown before the user searches; the message appears once a request
// has returned an empty result.
void main() {
  Widget host(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('multiSelectSearchRequest: no message before search, shown after',
      (tester) async {
    await tester.pumpWidget(host(
      CustomDropdown<String>.multiSelectSearchRequest(
        futureRequest: (_) async => <String>[],
        hintText: 'Select',
        noResultFoundText: 'No result found.',
        onListChanged: (_) {},
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(find.text('No result found.'), findsNothing,
        reason: 'no message until the user has searched');

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();
    expect(find.text('No result found.'), findsOneWidget,
        reason: 'message shows after an empty search result');
  });

  testWidgets('searchRequest (single): message shows after empty result',
      (tester) async {
    await tester.pumpWidget(host(
      CustomDropdown<String>.searchRequest(
        futureRequest: (_) async => <String>[],
        hintText: 'Select',
        noResultFoundText: 'No result found.',
        onChanged: (_) {},
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();
    expect(find.text('No result found.'), findsOneWidget);
  });
}
