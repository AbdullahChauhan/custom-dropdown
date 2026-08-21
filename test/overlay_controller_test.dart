import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tap still opens overlay with an external controller (#114)',
      (tester) async {
    final controller = OverlayPortalController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomDropdown<String>.search(
            items: const ['A', 'B', 'C'],
            hintText: 'Select',
            overlayController: controller,
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    // Tap opens.
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(controller.isShowing, isTrue);
    expect(find.byType(TextField), findsOneWidget);

    // Programmatic hide closes.
    controller.hide();
    await tester.pumpAndSettle();
    expect(controller.isShowing, isFalse);

    // Programmatic show reopens.
    controller.show();
    await tester.pumpAndSettle();
    expect(controller.isShowing, isTrue);
  });

  testWidgets('swapping the controller instance keeps it working (#114)',
      (tester) async {
    OverlayPortalController controller = OverlayPortalController();

    Widget build(OverlayPortalController c) => MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomDropdown<String>.search(
                items: const ['A', 'B', 'C'],
                hintText: 'Select',
                overlayController: c,
                onChanged: (_) {},
              ),
            ),
          ),
        );

    await tester.pumpWidget(build(controller));

    // Rebuild with a brand new controller instance.
    final newController = OverlayPortalController();
    await tester.pumpWidget(build(newController));
    await tester.pumpAndSettle();

    // The new controller must now drive the overlay.
    newController.show();
    await tester.pumpAndSettle();
    expect(newController.isShowing, isTrue);
    expect(find.byType(TextField), findsOneWidget);
  });
}
