part of '../custom_dropdown.dart';

class ListItemDecoration {
  /// Splash color for for [CustomDropdown] list item area.
  final Color? splashColor;

  /// Highlight color for [CustomDropdown] list item area.
  final Color? highlightColor;

  /// Selected color for [CustomDropdown] list item area.
  final Color? selectedColor;

  /// Selected icon color for [CustomDropdown] list item area.
  /// Useless if [listItemBuilder] provided.
  final MaterialStateProperty<Color?>? selectedIconColor;

  const ListItemDecoration({
    this.splashColor,
    this.highlightColor,
    this.selectedColor,
    this.selectedIconColor,
  });
}
