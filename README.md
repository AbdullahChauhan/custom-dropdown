# Custom Dropdown
**Custom Dropdown** package lets you add customizable animated dropdown widget.

## Features
Lots of properties to use and customize dropdown widget as per your need. Also usable under Form widget for required validation. 
- Custom dropdown using constructor **CustomDropdown()**.
- Custom dropdown with search field using named constructor **CustomDropdown.search()**.

<hr>

## Getting started

1. Add the latest version of package to your `pubspec.yaml` (and run `flutter pub get`):
```dart
dependencies:
  animated_custom_dropdown: 1.2.0
```
2. Import the package and use it in your Flutter App.
```dart
import 'package:animated_custom_dropdown/custom_dropdown.dart';
```
<hr>

## Example usage

```dart
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class CustomDropdownExample extends StatefulWidget {
  const CustomDropdownExample({Key? key}) : super(key: key);

  @override
  _CustomDropdownExampleState createState() => _CustomDropdownExampleState();
}

class _CustomDropdownExampleState extends State<CustomDropdownExample> {
  final jobRoleCtrl = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      hintText: 'Select job role',
      items: const ['Developer', 'Designer', 'Consultant', 'Student'],
      controller: jobRoleCtrl,
    );
  }
}
```

## Preview

![Example App](https://github.com/AbdullahChauhan/custom-dropdown/blob/master/readme_assets/preview.gif)

<hr>

## Todos

- [x] Align on screen bottom so if space under widget is small, dropdown will open above the widget with proper animation.
- [x] Search on provided data.
- [ ] Search on API request.

## Issues & Feedback
Please file an [issue](https://github.com/AbdullahChauhan/custom-dropdown/issues) to send feedback or report a bug. Thank you!
