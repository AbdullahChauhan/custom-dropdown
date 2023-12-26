part of '../custom_dropdown.dart';

class SearchFieldDecoration {
  final Color? fillColor;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget Function(VoidCallback onClear)? suffixIcon;
  final InputBorder? border;
  final InputBorder? focusedBorder;

  const SearchFieldDecoration({
    this.fillColor,
    this.constraints,
    this.contentPadding,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.focusedBorder,
  });
}
