part of '../custom_dropdown.dart';

class ListItemDecoration {
  /// Splash color for for [CustomDropdown] list item area.
  final Color? splashColor;

  /// Highlight color for [CustomDropdown] list item area.
  final Color? highlightColor;

  /// Selected item color for [CustomDropdown] list item area.
  final Color? selectedColor;

  const ListItemDecoration({
    this.splashColor,
    this.highlightColor,
    this.selectedColor,
  });
}
