import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'field InputDecorator ignores ambient inputDecorationTheme (#115/#117/#110)',
    (tester) async {
      // A hostile theme that, before the fix, leaked a border + fill + padding
      // into the dropdown field via InputDecorator (Flutter 3.35+).
      final hostileTheme = ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 3),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: hostileTheme,
          home: Scaffold(
            body: CustomDropdown<String>(
              items: const ['A', 'B', 'C'],
              hintText: 'Select',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      final decoration = decorator.decoration;

      expect(decoration.filled, isFalse, reason: 'theme fill must be suppressed');
      expect(decoration.border, InputBorder.none);
      expect(decoration.enabledBorder, InputBorder.none);
      expect(decoration.focusedBorder, InputBorder.none);
      expect(decoration.disabledBorder, InputBorder.none);
      expect(decoration.errorBorder, InputBorder.none);
      expect(decoration.focusedErrorBorder, InputBorder.none);
      expect(decoration.contentPadding, EdgeInsets.zero);
    },
  );
}
