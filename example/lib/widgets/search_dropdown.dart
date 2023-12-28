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

class SearchDropdown extends StatelessWidget {
  const SearchDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      hintText: 'Select cuisines',
      items: _list,
      overlayHeight: 342,
      onChanged: (value) {
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
