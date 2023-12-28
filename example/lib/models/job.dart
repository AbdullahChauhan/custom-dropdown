import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<Job> jobItems = [
  Job('Developer', Icons.developer_mode),
  Job('Designer', Icons.design_services),
  Job('Consultant', Icons.account_balance),
  Job('Student', Icons.school),
];

class Job with CustomDropdownListFilter {
  final String name;
  final IconData icon;

  const Job(this.name, this.icon);

  @override
  String toString() {
    return name;
  }

  @override
  bool filter(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }
}
