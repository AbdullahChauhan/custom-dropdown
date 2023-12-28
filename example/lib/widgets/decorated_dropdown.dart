import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:animated_custom_dropdown_example/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecoratedDropdown extends StatelessWidget {
  const DecoratedDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.search(
      items: jobItems,
      initialItem: jobItems[2],
      hintText: 'Select job role',
      searchHintText: 'Search job role',
      excludeSelected: false,
      hideSelectedFieldWhenExpanded: true,
      closedHeaderPadding: const EdgeInsets.all(20),
      onChanged: (value) {
        log('DecoratedDropdown onChanged value: $value');
      },
      headerBuilder: (context, selectedItem) {
        return Text(
          selectedItem.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        );
      },
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return Text(
          item.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        );
      },
      noResultFoundBuilder: (context, text) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
      decoration: CustomDropdownDecoration(
        closedFillColor: Colors.black,
        expandedFillColor: Colors.black,
        closedSuffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        expandedSuffixIcon: const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.grey,
        ),
        closedShadow: [
          const BoxShadow(
            offset: Offset(0, 4),
            color: Colors.blue,
            blurRadius: 8,
          ),
        ],
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Colors.grey[700],
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          hintStyle: TextStyle(color: Colors.grey[400]),
          textStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          suffixIcon: (onClear) {
            return GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, color: Colors.grey[400]),
            );
          },
        ),
        listItemDecoration: ListItemDecoration(
          selectedColor: Colors.grey[900],
          highlightColor: Colors.grey[800],
        ),
      ),
    );
  }
}

class MultiSelectDecoratedDropdown extends StatelessWidget {
  const MultiSelectDecoratedDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.multiSelectSearch(
      items: jobItems,
      hintText: 'Select job role',
      searchHintText: 'Search job role',
      closedHeaderPadding: const EdgeInsets.all(20),
      onListChanged: (value) {
        log('MultiSelectDecoratedDropdown onChanged value: $value');
      },
      maxlines: 2,
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            CupertinoCheckbox(
              value: isSelected,
              onChanged: (_) => onItemSelect(),
            ),
          ],
        );
      },
      decoration: CustomDropdownDecoration(
        closedFillColor: Colors.black,
        expandedFillColor: Colors.black,
        hintStyle: TextStyle(
          color: Colors.yellow[200],
          fontSize: 16,
        ),
        headerStyle: const TextStyle(
          color: Colors.yellow,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        noResultFoundStyle: const TextStyle(
          color: Colors.yellow,
          fontSize: 16,
        ),
        closedSuffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.yellow,
        ),
        expandedSuffixIcon: const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.yellow,
        ),
        closedShadow: [
          const BoxShadow(
            offset: Offset(0, 4),
            color: Colors.blue,
            blurRadius: 8,
          ),
        ],
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Colors.grey[700],
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          hintStyle: TextStyle(color: Colors.grey[400]),
          textStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          suffixIcon: (onClear) {
            return GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, color: Colors.grey[400]),
            );
          },
        ),
        listItemDecoration: ListItemDecoration(
          selectedColor: Colors.grey[900],
          highlightColor: Colors.grey[800],
        ),
      ),
    );
  }
}
