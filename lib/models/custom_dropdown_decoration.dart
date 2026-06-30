part of '../custom_dropdown.dart';

class CustomDropdownDecoration {
  /// [CustomDropdown] field color (closed state).
  ///
  /// Default to [Colors.white].
  final Color? closedFillColor;

  /// [CustomDropdown] overlay color (opened/expanded state).
  ///
  /// Default to [Colors.white].
  final Color? expandedFillColor;

  /// [CustomDropdown] box shadow (closed state).
  final List<BoxShadow>? closedShadow;

  /// [CustomDropdown] box shadow (opened/expanded state).
  final List<BoxShadow>? expandedShadow;

  /// Suffix icon for closed state of [CustomDropdown].
  final Widget? closedSuffixIcon;

  /// Suffix icon for opened/expanded state of [CustomDropdown].
  final Widget? expandedSuffixIcon;

  /// [CustomDropdown] header prefix icon.
  final Widget? prefixIcon;

  /// Border for closed state of [CustomDropdown].
  final BoxBorder? closedBorder;

  /// Border radius for closed state of [CustomDropdown].
  final BorderRadius? closedBorderRadius;

  /// Fixed height for the closed [CustomDropdown] header.
  ///
  /// When set, the closed field uses this height and its content is centered
  /// vertically. When null, the height is driven by the header padding.
  final double? closedHeaderHeight;

  /// Error border for closed state of [CustomDropdown].
  final BoxBorder? closedErrorBorder;

  /// Error border radius for closed state of [CustomDropdown].
  final BorderRadius? closedErrorBorderRadius;

  /// Border for opened/expanded state of [CustomDropdown].
  final BoxBorder? expandedBorder;

  /// Border radius for opened/expanded state of [CustomDropdown].
  final BorderRadius? expandedBorderRadius;

  /// The style to use for the [CustomDropdown] header hint.
  final TextStyle? hintStyle;

  /// The style of the floating label in its resting (placeholder) position.
  /// Only applies when `labelText` is provided.
  final TextStyle? labelStyle;

  /// The style of the floating label once it has floated up.
  /// Only applies when `labelText` is provided.
  final TextStyle? floatingLabelStyle;

  /// Controls when the floating label floats up.
  /// Only applies when `labelText` is provided. Defaults to
  /// [FloatingLabelBehavior.auto] (floats when the dropdown has a value or is
  /// open).
  final FloatingLabelBehavior floatingLabelBehavior;

  /// Vertical gap reserved above the field for the floated label (the space
  /// between the floated label and the field below it).
  ///
  /// Only applies when `labelText`/`label` is provided. Defaults to `16`.
  final double floatingLabelGap;

  /// The style to use for the [CustomDropdown] header text.
  final TextStyle? headerStyle;

  /// The style to use for the [CustomDropdown] no result found area.
  final TextStyle? noResultFoundStyle;

  /// The style to use for the string returning from [CustomDropdown.validator].
  final TextStyle? errorStyle;

  /// The style to use for the [CustomDropdown] list item text.
  final TextStyle? listItemStyle;

  /// [CustomDropdown] scrollbar decoration (opened/expanded state).
  final ScrollbarThemeData? overlayScrollbarDecoration;

  /// [CustomDropdown] search field decoration.
  final SearchFieldDecoration? searchFieldDecoration;

  /// [CustomDropdown] list item decoration.
  final ListItemDecoration? listItemDecoration;

  const CustomDropdownDecoration({
    this.closedFillColor,
    this.expandedFillColor,
    this.closedShadow,
    this.expandedShadow,
    this.closedSuffixIcon,
    this.expandedSuffixIcon,
    this.prefixIcon,
    this.closedBorder,
    this.closedBorderRadius,
    this.closedHeaderHeight,
    this.closedErrorBorder,
    this.closedErrorBorderRadius,
    this.expandedBorder,
    this.expandedBorderRadius,
    this.hintStyle,
    this.labelStyle,
    this.floatingLabelStyle,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.floatingLabelGap = 16,
    this.headerStyle,
    this.noResultFoundStyle,
    this.errorStyle,
    this.listItemStyle,
    this.overlayScrollbarDecoration,
    this.searchFieldDecoration,
    this.listItemDecoration,
  });

  static const Color _defaultFillColor = Colors.white;
}
