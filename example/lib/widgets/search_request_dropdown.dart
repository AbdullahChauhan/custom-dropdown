import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:animated_custom_dropdown_example/models/job.dart';
import 'package:flutter/cupertino.dart';

Future<List<Job>> _getFakeRequestData(String query) async {
  return await Future.delayed(const Duration(seconds: 1), () {
    return jobItems.where((e) {
      return e.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  });
}

class SearchRequestDropdown extends StatelessWidget {
  const SearchRequestDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.searchRequest(
      futureRequest: _getFakeRequestData,
      hintText: 'Search job role',
      onChanged: (value) {
        log('SearchRequestDropdown onChanged value: $value');
      },
      searchRequestLoadingIndicator: const Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class MultiSelectSearchRequestDropdown extends StatelessWidget {
  const MultiSelectSearchRequestDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.multiSelectSearchRequest(
      futureRequest: _getFakeRequestData,
      hintText: 'Search job role',
      onListChanged: (value) {
        log('MultiSelectSearchDropdown onChanged value: $value');
      },
    );
  }
}
