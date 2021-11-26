import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'overlay_builder.dart';
part 'dropdown_field.dart';
part 'dropdown_overlay.dart';
part 'animated_section.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final InputBorder? border;
  final InputBorder? errorBorder;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.border,
    this.errorBorder,
    this.suffixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    /// hint text
    final hintText = widget.hintText ?? 'Select value';

    // hint style :: if provided then merge with default
    final hintStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFFA7A7A7),
      fontWeight: FontWeight.w400,
    ).merge(widget.hintStyle);

    // selected item style :: if provided then merge with default
    final selectedStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ).merge(widget.selectedStyle);

    return _OverlayBuilder(
      overlay: (size, hideCallback) {
        return _DropdownOverlay(
          items: widget.items,
          controller: widget.controller,
          size: size,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle:
              widget.controller.text.isNotEmpty ? selectedStyle : hintStyle,
          suffixIcon: widget.suffixIcon,
          hintText: hintText,
          listItemStyle: widget.listItemStyle,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            controller: widget.controller,
            onTap: showCallback,
            style: selectedStyle,
            border: widget.border,
            errorBorder: widget.errorBorder,
            errorStyle: widget.errorStyle,
            errorText: widget.errorText,
            hintStyle: hintStyle,
            hintText: hintText,
            suffixIcon: widget.suffixIcon,
            onChanged: widget.onChanged,
          ),
        );
      },
    );
  }
}
