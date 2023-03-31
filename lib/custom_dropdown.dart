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
  ValueNotifier<T?> selectedItemNotifier;
  final List<T>? items;
  final String? hintText;
  final String? errorText;
  final TextStyle? errorStyle;

  //border
  //closed
  final BoxBorder? closedBorder;
  final BorderRadius? closedBorderRadius;
  //expanded
  final BoxBorder? expandedBorder;
  final BorderRadius? expandedBorderRadius;
  //error
  final BorderSide? errorBorderSide;

  final Widget? fieldSuffixIcon;
  final Function(T)? onChanged;
  final bool excludeSelected;
  final Color? closedFillColor;
  final Color? expandedFillColor;
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
  final Widget Function(BuildContext context, T result)? headerBuilder;

  // ignore: library_private_types_in_public_api
  final Widget Function(BuildContext context, String hint)? hintBuilder;

  CustomDropdown({
    Key? key,
    required this.items,
    T? selectedItem,
    this.hintText,
    //error
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    //closed border
    this.closedBorder,
    this.closedBorderRadius,
    //open border
    this.expandedBorder,
    this.expandedBorderRadius,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.closedFillColor = Colors.white,
    this.expandedFillColor = Colors.white,
  })  : assert(items!.isNotEmpty, 'Items list must contain at least one item.'),
        searchType = null,
        futureRequest = null,
        futureRequestDelay = null,
        canCloseOutsideBounds = true,
        hideSelectedFieldWhenOpen = false,
        selectedItemNotifier = ValueNotifier(selectedItem),
        super(key: key);

  CustomDropdown.search({
    Key? key,
    required this.items,
    T? selectedItem,
    this.hintText,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    //border
    this.closedBorder,
    this.closedBorderRadius,
    //open border
    this.expandedBorder,
    this.expandedBorderRadius,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenOpen = false,
    this.closedFillColor = Colors.white,
    this.expandedFillColor = Colors.white,
  })  : assert(items!.isNotEmpty, 'Items list must contain at least one item.'),
        searchType = _SearchType.onListData,
        futureRequest = null,
        futureRequestDelay = null,
        selectedItemNotifier = ValueNotifier(selectedItem),
        super(key: key);

  CustomDropdown.searchRequest({
    Key? key,
    required this.futureRequest,
    this.futureRequestDelay,
    T? selectedItem,
    this.items,
    this.hintText,
    this.errorText,
    this.errorStyle,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.errorBorderSide,
    //border
    this.closedBorder,
    this.closedBorderRadius,
    //open border
    this.expandedBorder,
    this.expandedBorderRadius,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenOpen = false,
    this.closedFillColor = Colors.white,
    this.expandedFillColor = Colors.white,
  })  : searchType = _SearchType.onRequestData,
        selectedItemNotifier = ValueNotifier(selectedItem),
        super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final layerLink = LayerLink();

  @override
  void initState() {
    super.initState();

    if (widget.onChanged != null) {
      widget.selectedItemNotifier.addListener(() {
        if (widget.selectedItemNotifier.value != null) {
          widget.onChanged!(widget.selectedItemNotifier.value!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// hint text
    final hintText = widget.hintText ?? 'Select value';

    return _OverlayBuilder(
      overlay: (size, hideCallback) {
        return _DropdownOverlay<T>(
          items: widget.items ?? [],
          selectedItemNotifier: widget.selectedItemNotifier,
          size: size,
          listItemBuilder: widget.listItemBuilder,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerBuilder: widget.headerBuilder,
          hintText: hintText,
          hintBuilder: widget.hintBuilder,
          excludeSelected: widget.excludeSelected,
          canCloseOutsideBounds: widget.canCloseOutsideBounds,
          searchType: widget.searchType,
          border: widget.expandedBorder,
          borderRadius: widget.expandedBorderRadius,
          futureRequest: widget.futureRequest,
          futureRequestDelay: widget.futureRequestDelay,
          hideSelectedFieldWhenOpen: widget.hideSelectedFieldWhenOpen,
          fillColor: widget.expandedFillColor,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField<T>(
            onTap: showCallback,
            selectedItemNotifier: widget.selectedItemNotifier,
            border: widget.closedBorder,
            borderRadius: widget.closedBorderRadius,
            errorBorderSide: widget.errorBorderSide,
            errorStyle: widget.errorStyle,
            errorText: widget.errorText,
            hintText: hintText,
            hintBuilder: widget.hintBuilder,
            headerBuilder: widget.headerBuilder,
            suffixIcon: widget.fieldSuffixIcon,
            //onChanged: widget.onChanged,
            fillColor: widget.closedFillColor,
          ),
        );
      },
    );
  }
}
