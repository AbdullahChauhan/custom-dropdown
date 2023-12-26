part of '../custom_dropdown.dart';

class CustomDropdownDecoration {
  final Color? closedFillColor;
  final Color? expandedFillColor;
  final List<BoxShadow>? closedShadow;
  final List<BoxShadow>? expandedShadow;
  final Widget? closedSuffixIcon;
  final Widget? expandedSuffixIcon;
  final BoxBorder? closedBorder;
  final BorderRadius? closedBorderRadius;
  final BoxBorder? closedErrorBorder;
  final BorderRadius? closedErrorBorderRadius;
  final BoxBorder? expandedBorder;
  final BorderRadius? expandedBorderRadius;
  final ScrollbarThemeData? overlayScrollbarDecoration;
  final SearchFieldDecoration? searchFieldDecoration;
  final ListItemDecoration? listItemDecoration;

  const CustomDropdownDecoration({
    this.closedFillColor,
    this.expandedFillColor,
    this.closedShadow,
    this.expandedShadow,
    this.closedSuffixIcon,
    this.expandedSuffixIcon,
    this.closedBorder,
    this.closedBorderRadius,
    this.closedErrorBorder,
    this.closedErrorBorderRadius,
    this.expandedBorder,
    this.expandedBorderRadius,
    this.overlayScrollbarDecoration,
    this.searchFieldDecoration,
    this.listItemDecoration,
  });
}
