import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'searchRequest waits for searchRequestMinChars before firing (#107)',
      (tester) async {
    final queries = <String>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.searchRequest(
            searchRequestMinChars: 3,
            futureRequest: (q) async {
              queries.add(q);
              return ['result for $q'];
            },
            hintText: 'Select',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    // Below the threshold: no request.
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'ab');
    await tester.pumpAndSettle();
    expect(queries, isEmpty, reason: 'no request below minChars');

    // Reaching the threshold: request fires.
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pumpAndSettle();
    expect(queries, ['abc'], reason: 'request fires at minChars');
  });
}
