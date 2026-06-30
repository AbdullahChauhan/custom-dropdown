import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'paginated: loads page 1 on open, next page on scroll, then stops',
      (tester) async {
    final requestedPages = <int>[];

    Future<List<String>> request(String query, int page) async {
      requestedPages.add(page);
      // pages 1 & 2 are full (20), page 3 is partial (5) => last page.
      final count = page <= 2 ? 20 : 5;
      return List.generate(count, (i) => 'p${page}_i$i');
    }

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.searchRequest(
            paginatedRequest: request,
            pageSize: 20,
            hintText: 'Select',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    // Open -> first page loads.
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(requestedPages, [1]);
    expect(find.text('p1_i0'), findsOneWidget);

    // Scroll to the bottom -> page 2 appends.
    await tester.drag(find.byType(ListView), const Offset(0, -4000));
    await tester.pumpAndSettle();
    expect(requestedPages, [1, 2]);

    // Scroll again -> page 3 (partial) loads, marking the end.
    await tester.drag(find.byType(ListView), const Offset(0, -8000));
    await tester.pumpAndSettle();
    expect(requestedPages, [1, 2, 3]);

    // No more pages: further scrolling does not request page 4.
    await tester.drag(find.byType(ListView), const Offset(0, -8000));
    await tester.pumpAndSettle();
    expect(requestedPages, [1, 2, 3]);
  });

  testWidgets('paginated: a new query resets to page 1', (tester) async {
    final requested = <String>[];

    Future<List<String>> request(String query, int page) async {
      requested.add('$query#$page');
      return List.generate(20, (i) => '$query-$page-$i');
    }

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.searchRequest(
            paginatedRequest: request,
            pageSize: 20,
            hintText: 'Select',
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle(); // '#1' for empty query

    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pumpAndSettle();

    expect(requested.contains('abc#1'), isTrue,
        reason: 'new query reloads from page 1');
  });

  test('searchRequest requires exactly one of futureRequest/paginatedRequest',
      () {
    expect(
      () => CustomDropdown<String>.searchRequest(onChanged: (_) {}),
      throwsAssertionError,
    );
    expect(
      () => CustomDropdown<String>.searchRequest(
        onChanged: (_) {},
        futureRequest: (_) async => const [],
        paginatedRequest: (_, __) async => const [],
      ),
      throwsAssertionError,
    );
  });
}
