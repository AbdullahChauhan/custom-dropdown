import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(DropdownOverlayDirection dir, Key key) => MaterialApp(
        home: Scaffold(
          // Field centered with plenty of room above and below.
          body: Center(
            child: CustomDropdown<String>(
              key: key,
              items: const ['A', 'B', 'C', 'D', 'E'],
              hintText: 'Select',
              overlayDirection: dir,
              onChanged: (_) {},
            ),
          ),
        ),
      );

  Future<double> firstItemTop(
      WidgetTester tester, DropdownOverlayDirection dir, Key key) async {
    await tester.pumpWidget(host(dir, key));
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    return tester.getTopLeft(find.text('A')).dy;
  }

  testWidgets('overlayDirection forces above vs below (#92)', (tester) async {
    final fieldKey = UniqueKey();
    await tester.pumpWidget(host(DropdownOverlayDirection.below, fieldKey));
    final fieldTop = tester.getTopLeft(find.byKey(fieldKey)).dy;

    final belowA =
        await firstItemTop(tester, DropdownOverlayDirection.below, UniqueKey());
    final aboveA =
        await firstItemTop(tester, DropdownOverlayDirection.above, UniqueKey());

    expect(aboveA, lessThan(belowA), reason: 'above opens higher than below');
    expect(aboveA, lessThan(fieldTop),
        reason: 'forced-above list sits above the field');
  });
}
