import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _list = [
  'Developer',
  'Designer',
  'Consultant',
  'Student',
];

/// Floating Material label + a clear button to reset the selection.
class LabelClearDropdown extends StatelessWidget {
  const LabelClearDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      labelText: 'Job role',
      canClearSelection: true,
      items: _list,
      onChanged: (value) {
        log('LabelClearDropdown onChanged value: $value');
      },
    );
  }
}

/// Force the overlay to always open above the field.
class DirectionDropdown extends StatelessWidget {
  const DirectionDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Always opens above',
      overlayDirection: DropdownOverlayDirection.above,
      items: _list,
      onChanged: (value) {
        log('DirectionDropdown onChanged value: $value');
      },
    );
  }
}

/// `textAlign` applied across the header, hint and list items.
class AlignedDropdown extends StatelessWidget {
  const AlignedDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Center aligned',
      textAlign: TextAlign.center,
      items: _list,
      onChanged: (value) {
        log('AlignedDropdown onChanged value: $value');
      },
    );
  }
}
