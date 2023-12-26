part of '../custom_dropdown.dart';

class CustomDropdownDecoration {
  final Color? closedFillColor;
  final Color? expandedFillColor;
  final Color? listItemHighlightColor;
  final Color? listItemSelectedColor;
  final List<BoxShadow>? overlayShadow;
  final ScrollbarThemeData? overlayScrollbarDecoration;
  final SearchFieldDecoration? searchFieldDecoration;

  const CustomDropdownDecoration({
    this.closedFillColor,
    this.expandedFillColor,
    this.listItemHighlightColor,
    this.listItemSelectedColor,
    this.overlayShadow,
    this.overlayScrollbarDecoration,
    this.searchFieldDecoration,
  });
}
