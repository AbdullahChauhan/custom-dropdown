import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

/// Fake paginated backend: 5 pages of 20 items, then "no more".
Future<List<String>> _fetchPage(String query, int page) async {
  await Future.delayed(const Duration(milliseconds: 600));
  if (page > 5) return const [];
  final suffix = query.isEmpty ? '' : ' · "$query"';
  return List.generate(20, (i) => 'Item ${(page - 1) * 20 + i + 1}$suffix');
}

/// Showcases infinite scroll: the first page loads on open, and the next page
/// is appended automatically as you scroll near the bottom.
class PaginatedSearchDropdown extends StatelessWidget {
  const PaginatedSearchDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.searchRequest(
      hintText: 'Infinite scroll — open & scroll down',
      paginatedRequest: _fetchPage,
      pageSize: 20,
      onChanged: (value) {
        log('PaginatedSearchDropdown onChanged value: $value');
      },
    );
  }
}
