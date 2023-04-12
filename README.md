# Custom Dropdown

**Custom Dropdown** package lets you add customizable animated dropdown widget.

[![pub.dev](https://img.shields.io/pub/v/animated_custom_dropdown.svg?style=flat?logo=dart)](https://pub.dev/packages/animated_custom_dropdown)
[![likes](https://img.shields.io/pub/likes/animated_custom_dropdown)](https://pub.dev/packages/animated_custom_dropdown/score)
[![popularity](https://img.shields.io/pub/popularity/animated_custom_dropdown)](https://pub.dev/packages/animated_custom_dropdown/score)
[![pub points](https://img.shields.io/pub/points/animated_custom_dropdown)](https://pub.dev/packages/animated_custom_dropdown/score)

[![buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/abdullahchauhan)

### If you like this package, please leave a like there on [pub.dev](https://pub.dev/packages/animated_custom_dropdown) and star on [GitHub](https://github.com/AbdullahChauhan/custom-dropdown).

## Features

Lots of properties to use and customize dropdown widget as per your need. Also usable under Form widget for required validation.

- Custom dropdown using constructor **CustomDropdown()**.
- Custom dropdown with search field using named constructor **CustomDropdown.search()**.
- Custom dropdown with search request field using named constructor **CustomDropdown.searchRequest()**.

<hr>

## Getting started

1. Add the latest version of package to your `pubspec.yaml` (and run `flutter pub get`):

```dart
dependencies:
  animated_custom_dropdown: ^latest_version
```

2. Import the package and use it in your Flutter App.

```dart
import 'package:animated_custom_dropdown/custom_dropdown.dart';
```

<hr>

## Example usage

### **1. Custom dropdown**
```dart
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class SimpleDropDown extends StatelessWidget {
  final List<String> list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
  ];

  SimpleDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: list,
      selectedItem: list[0],
      onChanged: (value) {
        print('changing value to: $value');
      },
    );
  }
}
```

### **2. Custom dropdown with search:** *A custom dropdown with the possibility to filter the items.*
Let's start with the type of object we are going to work with:
```dart
class Job with CustomDropdownListFilter {
  String name;
  IconData icon;

  Job(this.name, this.icon);

  @override
  String toString() {
    return '$name';
  }

  @override
  bool test(String query) {
    return name.contains(query);
  }
}
```
By default the list is filtered by applying a `item.toString().toLowerCase().contains(query.toLowerCase())` on every item, so we would need to implement toString() to improve the precision of the filter. </br>
But if the filter on the object is more complex, you can add the `CustomDropdownListFilter` mixin to it, which gives you access to the `test(query)` method, and by this the items of the list will be filtered.

Now the widget:

```dart
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class SearchDropDown extends StatelessWidget {
  final List<Job> list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
  ];

  SearchDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.search(
      hintText: 'Select job role',
      items: list,
      onChanged: (value) {
        print('changing value to: $value');
      },
      excludeSelected: true,
    );
  }
}
```

### **3. Custom dropdown with search request:** *A custom dropdown with a search request to load the items.*
Let's use a personalized object for the items:
```dart
class Pair {
  String text;
  IconData icon;

  Pair(this.text, this.icon);

  @override
  String toString() {
    return text;
  }
}
```

Now the widget:

```dart
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class SearchRequestDropDown extends StatelessWidget {
  final List<Pair> list = [
    Pair('Developer', Icons.developer_board),
    Pair('Designer', Icons.deblur_sharp),
    Pair('Consultant', Icons.money_off),
    Pair('Student', Icons.edit),
  ];

  ///this should be a call to the api or service or similar
  Future<List<Pair>> getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return list.where((e) {
        return e.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  SearchRequestDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Pair>.searchRequest(
      futureRequest: getFakeRequestData,
      hintText: 'Search job role',
      excludeSelected: true,
      items: list,
      onChanged: (value) {
        print('changing value to: $value');
      },
    );
  }
}
```

### **4. Custom dropdown with validation:** *A custom dropdown with validation.*

```dart
class ValidationDropDown extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  String? selected = null;

  final List<String> list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
  ];

  ValidationDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown<String>(
            selectedItem: selected,
            hintText: 'Select job role',
            items: list,
            excludeSelected: false,
            validateOnChange: true,//run validation on item selected
            onChanged: (value) {
              print('changing value to: $value');
              selected = value;//store the value
            },
            validator: (value) {//function to validate is the current selected item is valid or not
              if (value == null) {
                return "Must not be null";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Customization
For a complete customization of the package, go to the [example](https://github.com/AbdullahChauhan/custom-dropdown/blob/master/example/lib/main.dart).

## Preview

![Example App](https://github.com/AbdullahChauhan/custom-dropdown/blob/master/readme_assets/preview.gif)

<hr>

## Todos

- [ ] Dropdown field/header builder.

## Issues & Feedback

Please file an [issue](https://github.com/AbdullahChauhan/custom-dropdown/issues) to send feedback or report a bug. Thank you!
