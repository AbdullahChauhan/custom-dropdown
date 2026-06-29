import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('closedHeaderHeight sets the closed field height (#105)',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            decoration: const CustomDropdownDecoration(closedHeaderHeight: 72),
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    final size = tester.getSize(find.text('Select'));
    // The header (and thus the hint it lays out) should occupy the given height.
    final headerHeight = tester
        .getSize(find.ancestor(
          of: find.text('Select'),
          matching: find.byType(Container),
        ).first)
        .height;
    expect(headerHeight, 72);
    expect(size.height, lessThanOrEqualTo(72));
  });

  testWidgets('default error border follows the error text color (#105)',
      (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: CustomDropdown<String>(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            validateOnChange: false,
            decoration: const CustomDropdownDecoration(
              errorStyle: TextStyle(color: Colors.orange),
            ),
            validator: (v) => v == null ? 'Required' : null,
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    // Trigger validation -> error state.
    formKey.currentState!.validate();
    await tester.pumpAndSettle();

    // Find the closed field container and read its border color.
    final container = tester.widgetList<Container>(find.byType(Container)).firstWhere(
      (c) {
        final d = c.decoration;
        return d is BoxDecoration && d.border != null;
      },
    );
    final border = (container.decoration as BoxDecoration).border as Border;
    expect(border.top.color, Colors.orange,
        reason: 'default error border should match the custom error text color');
  });
}
