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

const _defaultFillColor = Colors.white;
const _defaultErrorColor = Colors.red;

mixin CustomDropdownListFilter {
  // used to filter elements against query on CustomDropdown<T>.search
  bool filter(String query);
}

const _defaultBorderRadius = BorderRadius.all(
  Radius.circular(12),
);

final Border _defaultErrorBorder = Border.all(
  color: _defaultErrorColor,
  width: 1.5,
);

const _defaultErrorStyle = TextStyle(
  color: _defaultErrorColor,
  fontSize: 14,
  height: 0.5,
);

const _defaultHintValue = 'Select value';

class CustomDropdown<T> extends StatefulWidget {
  final List<T>? items;
  final T? initialItem;
  final String? hintText;
  final BoxBorder? closedBorder;
  final BorderRadius? closedBorderRadius;
  final BoxBorder? expandedBorder;
  final BorderRadius? expandedBorderRadius;
  final String? Function(T?)? validator;
  final BoxBorder? closedErrorBorder;
  final BoxBorder? expandedErrorBorder;
  final BorderRadius? closedErrorBorderRadius;
  final BorderRadius? expandedErrorBorderRadius;
  final TextStyle? errorStyle;
  final bool validateOnChange;
  final Widget? closedSuffixIcon;
  final Widget? expandedSuffixIcon;
  final Function(T)? onChanged;
  final bool excludeSelected;
  final Color? closedFillColor;
  final Color? expandedFillColor;
  final bool canCloseOutsideBounds;
  final bool hideSelectedFieldWhenExpanded;
  final Future<List<T>> Function(String)? futureRequest;
  final VoidCallback? onTextFieldTap;
  final String? noResultFoundText;

  /// Duration after which the [futureRequest] is to be executed
  final Duration? futureRequestDelay;
  // ignore: library_private_types_in_public_api
  final _SearchType? searchType;
  final Widget Function(BuildContext context, T result)? listItemBuilder;
  final Widget Function(BuildContext context, T result)? headerBuilder;
  final Widget Function(BuildContext context, String hint)? hintBuilder;

  CustomDropdown({
    Key? key,
    required this.items,
    this.initialItem,
    this.hintText,
    this.noResultFoundText,
    this.onTextFieldTap,
    this.errorStyle,
    this.closedErrorBorder,
    this.closedErrorBorderRadius,
    this.expandedErrorBorder,
    this.expandedErrorBorderRadius,
    this.validator,
    this.validateOnChange = true,
    this.closedBorder,
    this.closedBorderRadius,
    this.expandedBorder,
    this.expandedBorderRadius,
    this.closedSuffixIcon,
    this.expandedSuffixIcon,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.onChanged,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = true,
    this.closedFillColor = Colors.white,
    this.expandedFillColor = Colors.white,
  })  : assert(
          items!.isNotEmpty,
          'Items list must contain at least one item.',
        ),
        assert(
          initialItem == null || items!.contains(initialItem),
          'Initial item must match with one of the item in items list.',
        ),
        searchType = null,
        futureRequest = null,
        futureRequestDelay = null,
        super(key: key);

  CustomDropdown.search({
    Key? key,
    required this.items,
    this.initialItem,
    this.hintText,
    this.noResultFoundText,
    this.onTextFieldTap,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.errorStyle,
    this.closedErrorBorder,
    this.closedErrorBorderRadius,
    this.expandedErrorBorder,
    this.expandedErrorBorderRadius,
    this.validator,
    this.validateOnChange = true,
    this.closedBorder,
    this.closedBorderRadius,
    this.closedSuffixIcon,
    this.expandedSuffixIcon,
    this.expandedBorder,
    this.expandedBorderRadius,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.closedFillColor = Colors.white,
    this.expandedFillColor = Colors.white,
  })  : assert(
          items!.isNotEmpty,
          'Items list must contain at least one item.',
        ),
        assert(
          initialItem == null || items!.contains(initialItem),
          'Initial item must match with one of the item in items list.',
        ),
        searchType = _SearchType.onListData,
        futureRequest = null,
        futureRequestDelay = null,
        super(key: key);

  const CustomDropdown.searchRequest({
    Key? key,
    required this.futureRequest,
    this.futureRequestDelay,
    this.initialItem,
    this.items,
    this.hintText,
    this.noResultFoundText,
    this.onTextFieldTap,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.errorStyle,
    this.closedErrorBorder,
    this.closedErrorBorderRadius,
    this.expandedErrorBorder,
    this.expandedErrorBorderRadius,
    this.validator,
    this.validateOnChange = true,
    this.closedBorder,
    this.closedBorderRadius,
    this.expandedBorder,
    this.expandedBorderRadius,
    this.closedSuffixIcon,
    this.expandedSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.closedFillColor = Colors.white,
    this.expandedFillColor = Colors.white,
  })  : searchType = _SearchType.onRequestData,
        super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final layerLink = LayerLink();
  late ValueNotifier<T?> selectedItemNotifier;

  @override
  void initState() {
    super.initState();
    selectedItemNotifier = ValueNotifier(widget.initialItem);
  }

  @override
  Widget build(BuildContext context) {
    final safeHintText = widget.hintText ?? _defaultHintValue;

    return FormField<T>(
      initialValue: selectedItemNotifier.value,
      validator: (val) {
        if (widget.validator != null) {
          return widget.validator!(val);
        }
        return null;
      },
      builder: (FormFieldState<T> formFieldState) {
        return InputDecorator(
          decoration: InputDecoration(
            errorStyle: widget.errorStyle ?? _defaultErrorStyle,
            errorText: formFieldState.errorText,
            border: InputBorder.none,
          ),
          child: _OverlayBuilder(
            overlay: (size, hideCallback) {
              return _DropdownOverlay<T>(
                onTextFieldTap: widget.onTextFieldTap ?? () {},
                onItemSelect: (T value) {
                  selectedItemNotifier.value = value;

                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }

                  formFieldState.didChange(value);

                  if (widget.validateOnChange) {
                    formFieldState.validate();
                  }
                },
                noResultFound: widget.noResultFoundText ?? 'No result found.',
                items: widget.items ?? [],
                selectedItemNotifier: selectedItemNotifier,
                size: size,
                listItemBuilder: widget.listItemBuilder,
                layerLink: layerLink,
                hideOverlay: hideCallback,
                headerBuilder: widget.headerBuilder,
                hintText: safeHintText,
                hintBuilder: widget.hintBuilder,
                excludeSelected: widget.excludeSelected,
                canCloseOutsideBounds: widget.canCloseOutsideBounds,
                searchType: widget.searchType,
                border: formFieldState.hasError
                    ? widget.expandedErrorBorder ?? _defaultErrorBorder
                    : widget.expandedBorder,
                borderRadius: formFieldState.hasError
                    ? widget.expandedErrorBorderRadius
                    : widget.expandedBorderRadius,
                futureRequest: widget.futureRequest,
                futureRequestDelay: widget.futureRequestDelay,
                hideSelectedFieldWhenOpen: widget.hideSelectedFieldWhenExpanded,
                fillColor: widget.expandedFillColor,
                suffixIcon: widget.expandedSuffixIcon,
              );
            },
            child: (showCallback) {
              return CompositedTransformTarget(
                link: layerLink,
                child: _DropDownField<T>(
                  onTap: showCallback,
                  selectedItemNotifier: selectedItemNotifier,
                  border: formFieldState.hasError
                      ? widget.closedErrorBorder ?? _defaultErrorBorder
                      : widget.closedBorder,
                  borderRadius: formFieldState.hasError
                      ? widget.closedErrorBorderRadius
                      : widget.closedBorderRadius,
                  hintText: safeHintText,
                  hintBuilder: widget.hintBuilder,
                  headerBuilder: widget.headerBuilder,
                  suffixIcon: widget.closedSuffixIcon,
                  fillColor: widget.closedFillColor,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
