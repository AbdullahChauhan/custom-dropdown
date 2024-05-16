import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:animated_custom_dropdown_example/models/job.dart';
import 'package:flutter/material.dart';

class MultiSelectControllerDropdown extends StatefulWidget {
  const MultiSelectControllerDropdown({Key? key}) : super(key: key);

  @override
  State<MultiSelectControllerDropdown> createState() =>
      _MultiSelectControllerDropdownState();
}

class _MultiSelectControllerDropdownState
    extends State<MultiSelectControllerDropdown> {
  final controller = MultiSelectController<Job>([]);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown<Job>.multiSelect(
          multiSelectController: controller,
          hintText: 'Select job role',
          items: jobItems,
          decoration: CustomDropdownDecoration(
            closedSuffixIcon: InkWell(
              onTap: () {
                log('Clearing MultiSelectControllerDropdown');
                controller.clear();
              },
              child: const Icon(Icons.close),
            ),
            expandedSuffixIcon: InkWell(
              onTap: () {
                log('Clearing MultiSelectControllerDropdown');
                controller.clear();
              },
              child: const Icon(Icons.close),
            ),
          ),
          onListChanged: (value) {
            log('MultiSelectControllerDropdown onChanged value: $value');
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.clear();
            },
            child: const Text(
              'Clear',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (controller.value.contains(jobItems[0])) {
                controller.remove(jobItems[0]);
              } else {
                controller.add(jobItems[0]);
              }
            },
            child: const Text(
              'Toggle first item selection',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
