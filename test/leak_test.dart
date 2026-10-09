import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

// Opening the menu used to leak the search field's FocusNode, the overlay's
// CurvedAnimation and (with staggerItems) one CurvedAnimation per item.
void main() {
  LeakTesting.enable();

  for (final stagger in [false, true]) {
    testWidgets(
      'open, select and unmount leaks nothing (staggerItems: $stagger)',
      experimentalLeakTesting: LeakTesting.settings.withTrackedAll(),
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomDropdown<String>.search(
                items: const ['A', 'B', 'C'],
                hintText: 'Select',
                animation: CustomDropdownAnimation(staggerItems: stagger),
                onChanged: (_) {},
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Select'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('B').last);
        await tester.pumpAndSettle();
        expect(find.text('B'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  // Swapping controllers used to leak the internal ones, leave listeners on
  // the old ones, and dispose the caller's controller when it was removed.
  testWidgets(
    'swapping single-select and scroll controllers while open',
    experimentalLeakTesting: LeakTesting.settings.withTrackedAll(),
    (tester) async {
      final a = SingleSelectController<String?>(null);
      final b = SingleSelectController<String?>(null);
      final scroll = ScrollController();
      SingleSelectController<String?>? ctrl;
      ScrollController? scrollCtrl;
      String? changed;
      late StateSetter rebuild;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(builder: (_, setState) {
              rebuild = setState;
              return CustomDropdown<String>.search(
                items: const ['A', 'B', 'C'],
                hintText: 'Select',
                controller: ctrl,
                itemsScrollController: scrollCtrl,
                onChanged: (v) => changed = v,
              );
            }),
          ),
        ),
      ));

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      rebuild(() {
        ctrl = a;
        scrollCtrl = scroll;
      });
      await tester.pumpAndSettle();
      rebuild(() => ctrl = b);
      await tester.pumpAndSettle();

      await tester.tap(find.text('B').last);
      await tester.pumpAndSettle();
      expect(changed, 'B');
      expect(b.value, 'B');

      rebuild(() => ctrl = null);
      await tester.pumpAndSettle();
      expect(find.text('B'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());

      // ignore: invalid_use_of_protected_member
      expect(a.hasListeners || b.hasListeners, isFalse);
      b.value = 'A'; // throws if the package disposed the caller's controller
      a.dispose();
      b.dispose();
      scroll.dispose();
    },
  );

  testWidgets(
    'swapping multi-select controllers while open',
    experimentalLeakTesting: LeakTesting.settings.withTrackedAll(),
    (tester) async {
      final m = MultiSelectController<String>(const ['A']);
      MultiSelectController<String>? ctrl;
      late StateSetter rebuild;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(builder: (_, setState) {
              rebuild = setState;
              return CustomDropdown<String>.multiSelect(
                items: const ['A', 'B', 'C'],
                hintText: 'Select',
                multiSelectController: ctrl,
                onListChanged: (_) {},
              );
            }),
          ),
        ),
      ));

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      rebuild(() => ctrl = m);
      await tester.pumpAndSettle();
      rebuild(() => ctrl = null);
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());

      // ignore: invalid_use_of_protected_member
      expect(m.hasListeners, isFalse);
      m.add('B'); // throws if the package disposed the caller's controller
      m.dispose();
    },
  );
}
