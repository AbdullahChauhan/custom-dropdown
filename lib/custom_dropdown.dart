library animated_custom_dropdown;

import 'dart:async';

import 'package:flutter/material.dart';

export 'custom_dropdown.dart';

part 'animated_section.dart';

part 'dropdown_field.dart';

part 'dropdown_overlay/dropdown_overlay.dart';

part 'dropdown_overlay/widgets/items_list.dart';

part 'dropdown_overlay/widgets/search_field.dart';

part 'overlay_builder.dart';

enum _SearchType { onListData, onRequestData }

class CustomDropdown<T> extends StatefulWidget {

  final List<T>? items;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? fieldSuffixIcon;
  final Function(T)? onChanged;
  final bool? excludeSelected;
  final Color? fillColor;
  final bool? canCloseOutsideBounds;
  final bool? hideSelectedFieldWhenOpen;
  final Future<List<T>> Function(String)? futureRequest;

  //duration after which the 'futureRequest' is to be executed
  final Duration? futureRequestDelay;

  // ignore: library_private_types_in_public_api
  final _SearchType? searchType;

  // ignore: library_private_types_in_public_api
  final Widget Function(BuildContext context, T result)? listItemBuilder;

  // ignore: library_private_types_in_public_api
  final Widget Function(BuildContext context, T result)? selectedItemBuilder;

  CustomDropdown({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.listItemBuilder,
    this.selectedItemBuilder,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.fillColor = Colors.white,
  })  : assert(items!.isNotEmpty, 'Items list must contain at least one item.'),
        assert(
          controller.text.isEmpty || items!.contains(controller.text),
          'Controller value must match with one of the item in items list.',
        ),
        searchType = null,
        futureRequest = null,
        futureRequestDelay = null,
        canCloseOutsideBounds = true,
        hideSelectedFieldWhenOpen = false,
        super(key: key);

  CustomDropdown.search({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.listItemBuilder,
    this.selectedItemBuilder,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenOpen = false,
    this.fillColor = Colors.white,
  })  : assert(items!.isNotEmpty, 'Items list must contain at least one item.'),
        assert(
          controller.text.isEmpty || items!.contains(controller.text),
          'Controller value must match with one of the item in items list.',
        ),
        searchType = _SearchType.onListData,
        futureRequest = null,
        futureRequestDelay = null,
        super(key: key);

  const CustomDropdown.searchRequest({
    Key? key,
    required this.controller,
    required this.futureRequest,
    this.futureRequestDelay,
    this.items,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemBuilder,
    this.selectedItemBuilder,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenOpen = false,
    this.fillColor = Colors.white,
  })  : searchType = _SearchType.onRequestData,
        super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
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
        return _DropdownOverlay<T>(
          items: widget.items ?? [],
          controller: widget.controller,
          size: size,
          listItemBuilder: widget.listItemBuilder,
          onChanged: widget.onChanged,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle: widget.controller.text.isNotEmpty ? selectedStyle : hintStyle,
          hintText: hintText,
          excludeSelected: widget.excludeSelected,
          canCloseOutsideBounds: widget.canCloseOutsideBounds,
          searchType: widget.searchType,
          futureRequest: widget.futureRequest,
          futureRequestDelay: widget.futureRequestDelay,
          hideSelectedFieldWhenOpen: widget.hideSelectedFieldWhenOpen,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField<T>(
            controller: widget.controller,
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
            //onChanged: widget.onChanged,
            fillColor: widget.fillColor,
          ),
        );
      },
    );
  }
}
