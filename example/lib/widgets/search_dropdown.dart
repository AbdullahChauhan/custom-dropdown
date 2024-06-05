import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const _list = [
  'Pakistani',
  'Indian',
  'Middle Eastern',
  'Western',
  'Chinese',
  'Italian',
];

class SearchDropdown extends StatefulWidget {
  const SearchDropdown({Key? key}) : super(key: key);

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  String? _selectedItem = _list[2];
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      hintText: 'Select cuisines',
      items: _list,
      initialItem: _selectedItem,
      overlayHeight: 342,
      onChanged: (value) {
        setState(() {
          _selectedItem = value;
        });
        log('SearchDropdown onChanged value: $value');
      },
    );
  }
}

class MultiSelectSearchDropdown extends StatelessWidget {
  const MultiSelectSearchDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.multiSelectSearch(
      hintText: 'Select cuisines',
      items: _list,
      onListChanged: (value) {
        log('MultiSelectSearchDropdown onChanged value: $value');
      },
    );
  }
}
