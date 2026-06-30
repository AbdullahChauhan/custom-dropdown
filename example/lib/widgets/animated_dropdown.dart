import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _list = [
  'Developer',
  'Designer',
  'Consultant',
  'Student',
  'Engineer',
  'Analyst',
  'Architect',
  'Manager',
  'Intern',
  'Researcher',
];

/// Showcases the configurable overlay animation system: pick a transition,
/// toggle the staggered list-item entrance, and see it applied live.
class AnimatedDropdown extends StatefulWidget {
  const AnimatedDropdown({super.key});

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<AnimatedDropdown> {
  DropdownAnimationType _type = DropdownAnimationType.scaleFade;
  bool _stagger = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown<DropdownAnimationType>(
          hintText: 'Animation type',
          items: DropdownAnimationType.values,
          initialItem: _type,
          onChanged: (value) {
            if (value != null) setState(() => _type = value);
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Staggered item entrance'),
          value: _stagger,
          onChanged: (value) => setState(() => _stagger = value),
        ),
        const SizedBox(height: 4),
        CustomDropdown<String>(
          // Rebuild when the config changes so the new animation applies.
          key: ValueKey('$_type-$_stagger'),
          hintText: 'Open me to preview',
          items: _list,
          // Make the list tall enough that several items animate in at once.
          overlayHeight: 342,
          animation: CustomDropdownAnimation(
            type: _type,
            // A quick overlay reveal so the per-item cascade is the star.
            duration: const Duration(milliseconds: 200),
            staggerItems: _stagger,
            itemStagger: const Duration(milliseconds: 90),
            itemDuration: const Duration(milliseconds: 350),
          ),
          onChanged: (value) {
            log('AnimatedDropdown onChanged value: $value');
          },
        ),
      ],
    );
  }
}
