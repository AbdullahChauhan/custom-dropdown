import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final items = List.generate(20, (i) => 'Item $i');

  // Screen is 1920/3 = 640 logical px tall.
  const screenHeight = 1920 / 3.0;
  const keyboardHeight = 300.0;

  Future<void> pumpDropdown(WidgetTester tester, double topSpacer) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(height: topSpacer),
              CustomDropdown<String>.search(
                items: items,
                hintText: 'Select',
                onChanged: (_) {},
              ),
              const SizedBox(height: 800),
            ],
          ),
        ),
      ),
    );
  }

  void showKeyboard(WidgetTester tester) {
    tester.view.viewInsets =
        const FakeViewPadding(bottom: keyboardHeight * 3.0);
  }

  void hideKeyboard(WidgetTester tester) {
    tester.view.viewInsets = FakeViewPadding.zero;
  }

  testWidgets('overlay stays clear of the keyboard for a mid-screen field',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await pumpDropdown(tester, 240);
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    final before = tester.getRect(find.byType(TextField));

    showKeyboard(tester);
    await tester.pumpAndSettle();

    // Overlay survives and flips above the field (its search field moved up).
    expect(find.byType(TextField), findsOneWidget,
        reason: 'overlay must stay visible when the keyboard appears');
    final after = tester.getRect(find.byType(TextField));
    expect(after.top, lessThan(before.top),
        reason: 'overlay should flip above the field, clear of the keyboard');
    expect(after.bottom, lessThanOrEqualTo(screenHeight - keyboardHeight + 0.5),
        reason: 'overlay must sit above the keyboard');

    hideKeyboard(tester);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget,
        reason: 'overlay must stay visible after the keyboard hides');
  });

  testWidgets('overlay survives keyboard for a field low in a scroll view',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // Field is far enough down that, without keep-alive + scroll-into-view, the
    // ListView would dispose it (and its overlay) once the keyboard appears.
    await pumpDropdown(tester, 450);
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomDropdown<String>), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    showKeyboard(tester);

    // Step through the frames of the keyboard/scroll transition: the overlay
    // must never disappear, not even for a single frame (no first-time flicker).
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(find.byType(TextField), findsOneWidget,
          reason: 'overlay must not flicker out during the keyboard transition '
              '(frame $i)');
    }
    await tester.pumpAndSettle();

    // The dropdown widget must not be disposed and the overlay must remain.
    expect(find.byType(CustomDropdown<String>), findsOneWidget,
        reason: 'dropdown must be kept alive while its overlay is open');
    expect(find.byType(TextField), findsOneWidget,
        reason: 'overlay must not vanish when the keyboard appears');

    final rect = tester.getRect(find.byType(TextField));
    expect(rect.bottom, lessThanOrEqualTo(screenHeight - keyboardHeight + 0.5),
        reason: 'overlay must sit above the keyboard');
  });
}
