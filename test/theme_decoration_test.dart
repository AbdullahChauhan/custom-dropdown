import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:material_ui/material_ui.dart';
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

      expect(decoration.filled, isFalse,
          reason: 'theme fill must be suppressed');
      expect(decoration.border, InputBorder.none);
      expect(decoration.enabledBorder, InputBorder.none);
      expect(decoration.focusedBorder, InputBorder.none);
      expect(decoration.disabledBorder, InputBorder.none);
      expect(decoration.errorBorder, InputBorder.none);
      expect(decoration.focusedErrorBorder, InputBorder.none);
      expect(decoration.contentPadding, EdgeInsets.zero);
    },
  );

  testWidgets(
    'no gray fill / error background when a validation error is shown (#94)',
    (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          // A theme that would otherwise paint a filled error background.
          theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey,
            ),
          ),
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomDropdown<String>(
                items: const ['A', 'B', 'C'],
                hintText: 'Select',
                validateOnChange: false,
                validator: (v) => v == null ? 'Required' : null,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Force the error state.
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      final decoration =
          tester.widget<InputDecorator>(find.byType(InputDecorator)).decoration;

      expect(decoration.filled, isFalse,
          reason: 'no filled background even while showing an error');
      expect(decoration.fillColor, Colors.transparent);
      expect(decoration.errorBorder, InputBorder.none);
    },
  );
}
