library animated_custom_dropdown;

export 'custom_dropdown.dart';

import 'package:flutter/material.dart';

part 'animated_section.dart';
part 'dropdown_field.dart';
part 'dropdown_overlay.dart';
part 'overlay_builder.dart';

enum _SearchType { onListData }

class CustomDropdown extends StatefulWidget {
  final List<Map<String, dynamic>>? items;
  final Map<String, dynamic>? selectedValue;
  final String? nameKey;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? fieldSuffixIcon;
  final Function(Map<String, dynamic>)? onChanged;
  final bool? excludeSelected;
  final Color? fillColor;
  final EdgeInsets? contentPadding;
  final bool? canCloseOutsideBounds;
  final _SearchType? searchType;

  const CustomDropdown({
    Key? key,
    this.nameKey,
    this.items,
    this.hintText,
    this.selectedValue,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.contentPadding,
    this.excludeSelected = true,
    this.fillColor = Colors.white,
  })  : searchType = null,
        canCloseOutsideBounds = true,
        super(key: key);

  const CustomDropdown.search({
    Key? key,
    this.items,
    this.nameKey,
    this.hintText,
    this.selectedValue,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.contentPadding,
    this.excludeSelected = false,
    this.canCloseOutsideBounds = true,
    this.fillColor = Colors.white,
  })  : searchType = _SearchType.onListData,
        super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final layerLink = LayerLink();

  late TextEditingController textEditingController;
  List<String> dataItems = [];

  @override
  void initState() {
    init();

    super.initState();
  }

  void init() {
    textEditingController =
        TextEditingController(text: widget.selectedValue?[widget.nameKey]);
    dataItems = widget.items
            ?.map((element) => element[widget.nameKey].toString())
            .toList() ??
        [];
  }

  void onChangeEx(String value) {
    var result = widget.items?.indexWhere((e) => e[widget.nameKey] == value);

    if (result != -1) {
      widget.onChanged?.call(widget.items?[result ?? 0] ?? {});
    } else {
      widget.onChanged?.call({});
    }
  }

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

    return AbsorbPointer(
      absorbing: ((widget.items == null) || (widget.items?.isEmpty ?? false))
          ? true
          : false,
      child: _OverlayBuilder(
        overlay: (size, hideCallback) {
          return _DropdownOverlay(
            items: dataItems,
            controller: textEditingController,
            size: size,
            layerLink: layerLink,
            hideOverlay: hideCallback,
            headerStyle: (textEditingController.text.isNotEmpty)
                ? selectedStyle
                : hintStyle,
            hintText: hintText,
            listItemStyle: widget.listItemStyle,
            excludeSelected: widget.excludeSelected,
            canCloseOutsideBounds: widget.canCloseOutsideBounds,
            searchType: widget.searchType,
            onChanged: (value) => onChangeEx(value),
          );
        },
        child: (showCallback) {
          return CompositedTransformTarget(
            link: layerLink,
            child: _DropDownField(
              isItemsNullOrEmpty: dataItems.isEmpty,
              controller: textEditingController,
              onTap: showCallback,
              style: selectedStyle,
              borderRadius: widget.borderRadius,
              borderSide: widget.borderSide,
              errorBorderSide: widget.errorBorderSide,
              errorStyle: widget.errorStyle,
              errorText: widget.errorText,
              hintStyle: hintStyle,
              hintText: hintText,
              suffixIcon: widget.fieldSuffixIcon,
              // onChanged: widget.onChanged,
              fillColor: widget.fillColor,
              contentPadding: widget.contentPadding,
            ),
          );
        },
      ),
    );
  }
}
