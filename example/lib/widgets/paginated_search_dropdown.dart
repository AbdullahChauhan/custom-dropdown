import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const _pageSize = 20;

/// A fixed dataset the fake backend searches over.
final List<String> _allItems = List.generate(100, (i) => 'Item ${i + 1}');

/// Fake paginated backend: filters [_allItems] by [query] and returns the
/// requested [page] (1-based) of the matches.
Future<List<String>> _fetchPage(String query, int page) async {
  await Future.delayed(const Duration(milliseconds: 500));

  final matches = _allItems
      .where((e) => e.toLowerCase().contains(query.toLowerCase()))
      .toList();

  final start = (page - 1) * _pageSize;
  if (start >= matches.length) return const [];
  final end = (start + _pageSize).clamp(0, matches.length);
  return matches.sublist(start, end);
}

/// Showcases infinite scroll: the first page loads on open, and the next page
/// is appended automatically as you scroll near the bottom.
class PaginatedSearchDropdown extends StatelessWidget {
  const PaginatedSearchDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.searchRequest(
      hintText: 'Infinite scroll — open, search & scroll',
      paginatedRequest: _fetchPage,
      pageSize: _pageSize,
      onChanged: (value) {
        log('PaginatedSearchDropdown onChanged value: $value');
      },
    );
  }
}
