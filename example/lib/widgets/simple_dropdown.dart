import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _list = [
  'Developer',
  'Designer',
  'Consultant',
  'Student',
];

class SimpleDropdown extends StatefulWidget {
  const SimpleDropdown({Key? key}) : super(key: key);

  @override
  State<SimpleDropdown> createState() => _SimpleDropdownState();
}

class _SimpleDropdownState extends State<SimpleDropdown> {
  String? _selectedItem;
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: _list,
      initialItem: _selectedItem,
      excludeSelected: false,
      onChanged: (value) {
        log('SimpleDropdown onChanged value: $value');
        setState(() {
          _selectedItem = value;
        });
      },
    );
  }
}
