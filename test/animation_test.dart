import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(CustomDropdownAnimation animation, {Key? key}) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: CustomDropdown<String>(
              key: key,
              items: const ['A', 'B', 'C'],
              hintText: 'Select',
              animation: animation,
              onChanged: (_) {},
            ),
          ),
        ),
      );

  testWidgets('every animation type opens and closes cleanly', (tester) async {
    for (final type in DropdownAnimationType.values) {
      await tester.pumpWidget(
        host(CustomDropdownAnimation(type: type), key: ValueKey(type)),
      );

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      expect(find.text('A'), findsOneWidget, reason: 'opened for $type');

      await tester.tap(find.text('B').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull,
          reason: 'closed cleanly for $type');
      expect(find.text('A'), findsNothing, reason: 'overlay gone for $type');
    }
  });

  testWidgets('scale type uses ScaleTransition, slide uses SlideTransition',
      (tester) async {
    await tester.pumpWidget(
      host(const CustomDropdownAnimation(type: DropdownAnimationType.scale),
          key: const ValueKey('scale')),
    );
    await tester.tap(find.text('Select'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(ScaleTransition), findsWidgets);
    // Opening below the field: scale must anchor at the top edge (grow down,
    // away from the field), not the bottom.
    final scale = tester.widgetList<ScaleTransition>(
      find.byType(ScaleTransition),
    );
    expect(scale.any((s) => s.alignment == const Alignment(0, -1)), isTrue,
        reason: 'scale anchored at the field (top) edge when opening below');
    await tester.pumpAndSettle();
    await tester.tap(find.text('A').last); // close
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      host(const CustomDropdownAnimation(type: DropdownAnimationType.slide),
          key: const ValueKey('slide')),
    );
    await tester.tap(find.text('Select'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(SlideTransition), findsWidgets);
    await tester.pumpAndSettle();
  });

  testWidgets('CustomDropdownAnimation.none opens instantly', (tester) async {
    await tester.pumpWidget(host(CustomDropdownAnimation.none));

    await tester.tap(find.text('Select'));
    await tester.pump(); // single frame, no settle
    expect(find.text('A'), findsOneWidget, reason: 'no-animation = instant');
  });

  testWidgets('custom builder overrides the built-in transition',
      (tester) async {
    var builderCalled = false;
    await tester.pumpWidget(host(CustomDropdownAnimation(
      builder: (context, animation, axisAlignment, child) {
        builderCalled = true;
        return FadeTransition(opacity: animation, child: child);
      },
    )));

    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(builderCalled, isTrue);
  });

  testWidgets('duration/curve drive the reveal progress', (tester) async {
    await tester.pumpWidget(host(
      const CustomDropdownAnimation(
        type: DropdownAnimationType.sizeFade,
        duration: Duration(milliseconds: 600),
      ),
    ));

    await tester.tap(find.text('Select'));
    await tester.pump(); // start
    await tester.pump(const Duration(milliseconds: 60));

    final size = tester.widget<SizeTransition>(find.byType(SizeTransition));
    expect(size.sizeFactor.value, greaterThan(0.0));
    expect(size.sizeFactor.value, lessThan(1.0),
        reason: 'still revealing 60ms into a 600ms open');

    await tester.pumpAndSettle();
    final settled = tester.widget<SizeTransition>(find.byType(SizeTransition));
    expect(settled.sizeFactor.value, 1.0);
  });

  testWidgets('staggerItems wraps items in an entrance and settles visible',
      (tester) async {
    await tester.pumpWidget(host(
      // sizeFade overlay (no SlideTransition of its own) so any SlideTransition
      // comes from the staggered item entrance.
      const CustomDropdownAnimation(staggerItems: true),
      key: const ValueKey('stagger'),
    ));

    // Scope to the items ListView (the page route also uses SlideTransition).
    final itemSlides = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(SlideTransition),
    );

    await tester.tap(find.text('Select'));
    await tester.pump(const Duration(milliseconds: 16));
    expect(itemSlides, findsWidgets,
        reason: 'items get a slide entrance when staggered');

    await tester.pumpAndSettle();
    expect(find.text('A'), findsOneWidget);
    await tester.tap(find.text('A').last); // still selectable
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('no staggered entrance by default', (tester) async {
    await tester.pumpWidget(host(
      const CustomDropdownAnimation(), // sizeFade, staggerItems false
      key: const ValueKey('nostagger'),
    ));

    await tester.tap(find.text('Select'));
    await tester.pump(const Duration(milliseconds: 16));
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SlideTransition),
      ),
      findsNothing,
    );
    await tester.pumpAndSettle();
  });

  testWidgets('disabled animation ignores staggerItems', (tester) async {
    await tester.pumpWidget(host(
      const CustomDropdownAnimation(enabled: false, staggerItems: true),
      key: const ValueKey('none-stagger'),
    ));

    await tester.tap(find.text('Select'));
    await tester.pump(); // instant
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SlideTransition),
      ),
      findsNothing,
    );
    expect(find.text('A'), findsOneWidget);
  });
}
