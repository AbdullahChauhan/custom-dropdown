import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:animated_custom_dropdown_example/models/job.dart';
import 'package:flutter/material.dart';

class ControllerValidationDropdown extends StatefulWidget {
  const ControllerValidationDropdown({Key? key}) : super(key: key);

  @override
  State<ControllerValidationDropdown> createState() =>
      _ControllerValidationDropdownState();
}

class _ControllerValidationDropdownState
    extends State<ControllerValidationDropdown> {
  final formKey = GlobalKey<FormState>();
  final controller = SingleSelectController<Job>(jobItems[0]);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown<Job>(
            controller: controller,
            hintText: 'Select job role',
            items: jobItems,
            onChanged: (value) {
              log('ControllerValidationDropdown onChanged value: $value');
            },
            validator: (value) {
              if (value == null) {
                return "Must not be null";
              }
              return null;
            },
            decoration: CustomDropdownDecoration(
              closedSuffixIcon: InkWell(
                onTap: () {
                  log('Clearing ControllerValidationDropdown');
                  controller.clear();
                },
                child: const Icon(Icons.close),
              ),
            ),
          ),
          const SizedBox(height: 8),
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
