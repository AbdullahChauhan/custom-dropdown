library animated_custom_dropdown;

import 'dart:async';

import 'package:flutter/material.dart';

export 'custom_dropdown.dart';

// models
part 'models/custom_dropdown_decoration.dart';
part 'models/custom_dropdown_list_filter.dart';
part 'models/list_item_decoration.dart';
part 'models/search_field_decoration.dart';
part 'models/value_notifier_list.dart';
// utils
part 'utils/signatures.dart';
// widgets
part 'widgets/animated_section.dart';
part 'widgets/dropdown_field.dart';
part 'widgets/dropdown_overlay/dropdown_overlay.dart';
part 'widgets/dropdown_overlay/widgets/items_list.dart';
part 'widgets/dropdown_overlay/widgets/search_field.dart';
part 'widgets/overlay_builder.dart';

enum _DropdownType { singleSelect, multipleSelect }

enum _SearchType { onListData, onRequestData }

const _defaultErrorColor = Colors.red;

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

class CustomDropdown<T> extends StatefulWidget {
  /// The list of items user can select.
  final List<T>? items;

  /// Initial selected item from the list of [items].
  final T? initialItem;

  /// Initial selected items from the list of [items].
  final List<T>? initialItems;

  /// Text that suggests what sort of data the dropdown represents.
  ///
  /// Default to "Select value".
  final String? hintText;

  /// Text that suggests what to search in the search field.
  ///
  /// Default to "Search".
  final String? searchHintText;

  /// A method that validates the selected item.
  /// Returns an error string to display as per the validation, or null otherwise.
  final String? Function(T?)? validator;

  /// A method that validates the selected items.
  /// Returns an error string to display as per the validation, or null otherwise.
  final String? Function(List<T>)? listValidator;

  /// Enable the validation listener on item change.
  /// This implies to [validator] everytime when the item change.
  final bool validateOnChange;

  /// Called when the item of the [CustomDropdown] should change.
  final Function(T)? onChanged;

  /// Called when the list of items of the [CustomDropdown] should change.
  final Function(List<T>)? onListChanged;

  /// Hide the selected item from the [items] list.
  final bool excludeSelected;

  /// Can close [CustomDropdown] overlay by tapping outside.
  /// Here "outside" covers the entire screen.
  final bool canCloseOutsideBounds;

  /// Hide the header field when [CustomDropdown] overlay opened/expanded.
  final bool hideSelectedFieldWhenExpanded;

  /// The asynchronous computation from which the items list returns.
  final Future<List<T>> Function(String)? futureRequest;

  /// Text that notify there's no search results match.
  ///
  /// Default to "No result found.".
  final String? noResultFoundText;

  /// Duration after which the [futureRequest] is to be executed.
  final Duration? futureRequestDelay;

  /// Text maxlines for header and list item text.
  final int maxlines;

  /// Padding for [CustomDropdown] header (closed state).
  final EdgeInsets? closedHeaderPadding;

  /// Padding for [CustomDropdown] header (opened/expanded state).
  final EdgeInsets? expandedHeaderPadding;

  /// Padding for [CustomDropdown] items list.
  final EdgeInsets? itemsListPadding;

  /// Padding for [CustomDropdown] each list item.
  final EdgeInsets? listItemPadding;

  /// Widget to display while search request loading.
  final Widget? searchRequestLoadingIndicator;

  /// [CustomDropdown] opened/expanded area height.
  /// Only applicable if items are greater than 4 otherwise adjust automatically.
  final double? overlayHeight;

  /// The [listItemBuilder] that will be used to build item on demand.
  final _ListItemBuilder<T>? listItemBuilder;

  /// The [headerBuilder] that will be used to build [CustomDropdown] header field.
  final _HeaderBuilder<T>? headerBuilder;

  /// The [hintBuilder] that will be used to build [CustomDropdown] hint of header field.
  final _HintBuilder? hintBuilder;

  /// The [noResultFoundBuilder] that will be used to build area when there's no search results match.
  final _NoResultFoundBuilder? noResultFoundBuilder;

  /// The [headerListBuilder] that will be used to build [CustomDropdown] header field.
  final _HeaderListBuilder<T>? headerListBuilder;

  /// [CustomDropdown] decoration.
  /// Contain sub-decorations [SearchFieldDecoration], [ListItemDecoration] and [ScrollbarThemeData].
  final CustomDropdownDecoration? decoration;

  final _SearchType? _searchType;

  final _DropdownType _dropdownType;

  CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialItem,
    this.hintText,
    this.decoration,
    this.validator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.maxlines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = true,
  })  : assert(
          items!.isNotEmpty,
          'Items list must contain at least one item.',
        ),
        assert(
          initialItem == null || items!.contains(initialItem),
          'Initial item must match with one of the item in items list.',
        ),
        _searchType = null,
        _dropdownType = _DropdownType.singleSelect,
        futureRequest = null,
        futureRequestDelay = null,
        noResultFoundBuilder = null,
        noResultFoundText = null,
        searchHintText = null,
        initialItems = null,
        onListChanged = null,
        listValidator = null,
        headerListBuilder = null,
        searchRequestLoadingIndicator = null;

  CustomDropdown.search({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialItem,
    this.hintText,
    this.decoration,
    this.searchHintText,
    this.noResultFoundText,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.validator,
    this.validateOnChange = true,
    this.maxlines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
  })  : assert(
          items!.isNotEmpty,
          'Items list must contain at least one item.',
        ),
        assert(
          initialItem == null || items!.contains(initialItem),
          'Initial item must match with one of the item in items list.',
        ),
        _searchType = _SearchType.onListData,
        _dropdownType = _DropdownType.singleSelect,
        futureRequest = null,
        futureRequestDelay = null,
        initialItems = null,
        onListChanged = null,
        listValidator = null,
        headerListBuilder = null,
        searchRequestLoadingIndicator = null;

  const CustomDropdown.searchRequest({
    super.key,
    required this.futureRequest,
    required this.onChanged,
    this.futureRequestDelay,
    this.initialItem,
    this.items,
    this.hintText,
    this.decoration,
    this.searchHintText,
    this.noResultFoundText,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.validator,
    this.validateOnChange = true,
    this.maxlines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.searchRequestLoadingIndicator,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
  })  : _searchType = _SearchType.onRequestData,
        _dropdownType = _DropdownType.singleSelect,
        initialItems = null,
        onListChanged = null,
        listValidator = null,
        headerListBuilder = null;

  CustomDropdown.multiSelect({
    super.key,
    required this.items,
    required this.onListChanged,
    this.initialItems,
    this.listValidator,
    this.headerListBuilder,
    this.hintText,
    this.decoration,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.hintBuilder,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.maxlines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
  })  : assert(
          items!.isNotEmpty,
          'Items list must contain at least one item.',
        ),
        assert(
          initialItems == null ||
              initialItems.isEmpty ||
              initialItems.any((e) => items!.contains(e)),
          'Initial items must match with the items in the items list.',
        ),
        _searchType = null,
        _dropdownType = _DropdownType.multipleSelect,
        initialItem = null,
        noResultFoundText = null,
        validator = null,
        headerBuilder = null,
        onChanged = null,
        excludeSelected = false,
        futureRequest = null,
        futureRequestDelay = null,
        noResultFoundBuilder = null,
        searchHintText = null,
        searchRequestLoadingIndicator = null;

  CustomDropdown.multiSelectSearch({
    super.key,
    required this.items,
    required this.onListChanged,
    this.initialItems,
    this.listValidator,
    this.listItemBuilder,
    this.hintBuilder,
    this.decoration,
    this.headerListBuilder,
    this.noResultFoundText,
    this.noResultFoundBuilder,
    this.hintText,
    this.searchHintText,
    this.validateOnChange = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.maxlines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
  })  : assert(
          items!.isNotEmpty,
          'Items list must contain at least one item.',
        ),
        assert(
          initialItems == null ||
              initialItems.isEmpty ||
              initialItems.any((e) => items!.contains(e)),
          'Initial items must match with the items in the items list.',
        ),
        _searchType = _SearchType.onListData,
        _dropdownType = _DropdownType.multipleSelect,
        initialItem = null,
        onChanged = null,
        validator = null,
        excludeSelected = false,
        headerBuilder = null,
        futureRequest = null,
        futureRequestDelay = null,
        searchRequestLoadingIndicator = null;

  const CustomDropdown.multiSelectSearchRequest({
    super.key,
    required this.futureRequest,
    required this.onListChanged,
    this.futureRequestDelay,
    this.initialItems,
    this.items,
    this.hintText,
    this.decoration,
    this.searchHintText,
    this.noResultFoundText,
    this.headerListBuilder,
    this.listItemBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.listValidator,
    this.validateOnChange = true,
    this.maxlines = 1,
    this.overlayHeight,
    this.searchRequestLoadingIndicator,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
  })  : _searchType = _SearchType.onRequestData,
        _dropdownType = _DropdownType.multipleSelect,
        initialItem = null,
        onChanged = null,
        headerBuilder = null,
        excludeSelected = false,
        validator = null;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final layerLink = LayerLink();
  late ValueNotifier<T?> selectedItemNotifier;
  late _ValueNotifierList<T> selectedItemsNotifier;

  @override
  void initState() {
    super.initState();
    selectedItemNotifier = ValueNotifier(widget.initialItem);
    selectedItemsNotifier = _ValueNotifierList(widget.initialItems ?? []);
  }

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialItem != oldWidget.initialItem) {
      selectedItemNotifier = ValueNotifier(widget.initialItem);
    }

    if (widget.initialItems != oldWidget.initialItems) {
      selectedItemsNotifier = _ValueNotifierList(widget.initialItems ?? []);
    }
  }

  @override
  void dispose() {
    selectedItemNotifier.dispose();
    selectedItemsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration;
    final safeHintText = widget.hintText ?? 'Select value';

    return FormField<(T?, List<T>)>(
      initialValue: (selectedItemNotifier.value, selectedItemsNotifier.value),
      validator: (val) {
        if (widget._dropdownType == _DropdownType.singleSelect &&
            widget.validator != null) {
          return widget.validator!(val?.$1);
        }
        if (widget._dropdownType == _DropdownType.multipleSelect &&
            widget.listValidator != null) {
          return widget.listValidator!(val?.$2 ?? []);
        }
        return null;
      },
      builder: (formFieldState) {
        return InputDecorator(
          decoration: InputDecoration(
            errorStyle: decoration?.errorStyle ?? _defaultErrorStyle,
            errorText: formFieldState.errorText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          child: _OverlayBuilder(
            overlay: (size, hideCallback) {
              return _DropdownOverlay<T>(
                onItemSelect: (T value) {
                  switch (widget._dropdownType) {
                    case _DropdownType.singleSelect:
                      selectedItemNotifier.value = value;
                      widget.onChanged?.call(value);
                      formFieldState.didChange((value, []));
                    case _DropdownType.multipleSelect:
                      final currentVal = selectedItemsNotifier.value.toList();
                      if (currentVal.contains(value)) {
                        currentVal.remove(value);
                      } else {
                        currentVal.add(value);
                      }
                      selectedItemsNotifier.value = currentVal;
                      widget.onListChanged?.call(currentVal);
                      formFieldState.didChange((null, currentVal));
                  }
                  if (widget.validateOnChange) {
                    formFieldState.validate();
                  }
                },
                noResultFoundText:
                    widget.noResultFoundText ?? 'No result found.',
                noResultFoundBuilder: widget.noResultFoundBuilder,
                items: widget.items ?? [],
                selectedItemNotifier: selectedItemNotifier,
                selectedItemsNotifier: selectedItemsNotifier,
                size: size,
                listItemBuilder: widget.listItemBuilder,
                layerLink: layerLink,
                hideOverlay: hideCallback,
                hintStyle: decoration?.hintStyle,
                headerStyle: decoration?.headerStyle,
                noResultFoundStyle: decoration?.noResultFoundStyle,
                listItemStyle: decoration?.listItemStyle,
                headerBuilder: widget.headerBuilder,
                headerListBuilder: widget.headerListBuilder,
                hintText: safeHintText,
                searchHintText: widget.searchHintText ?? 'Search',
                hintBuilder: widget.hintBuilder,
                decoration: decoration,
                overlayHeight: widget.overlayHeight,
                excludeSelected: widget.excludeSelected,
                canCloseOutsideBounds: widget.canCloseOutsideBounds,
                searchType: widget._searchType,
                futureRequest: widget.futureRequest,
                futureRequestDelay: widget.futureRequestDelay,
                hideSelectedFieldWhenOpen: widget.hideSelectedFieldWhenExpanded,
                maxLines: widget.maxlines,
                headerPadding: widget.expandedHeaderPadding,
                itemsListPadding: widget.itemsListPadding,
                listItemPadding: widget.listItemPadding,
                searchRequestLoadingIndicator:
                    widget.searchRequestLoadingIndicator,
                dropdownType: widget._dropdownType,
              );
            },
            child: (showCallback) {
              return CompositedTransformTarget(
                link: layerLink,
                child: _DropDownField<T>(
                  onTap: showCallback,
                  selectedItemNotifier: selectedItemNotifier,
                  border: formFieldState.hasError
                      ? (decoration?.closedErrorBorder ?? _defaultErrorBorder)
                      : decoration?.closedBorder,
                  borderRadius: formFieldState.hasError
                      ? decoration?.closedErrorBorderRadius
                      : decoration?.closedBorderRadius,
                  shadow: decoration?.closedShadow,
                  hintStyle: decoration?.hintStyle,
                  headerStyle: decoration?.headerStyle,
                  hintText: safeHintText,
                  hintBuilder: widget.hintBuilder,
                  headerBuilder: widget.headerBuilder,
                  headerListBuilder: widget.headerListBuilder,
                  suffixIcon: decoration?.closedSuffixIcon,
                  fillColor: decoration?.closedFillColor,
                  maxLines: widget.maxlines,
                  headerPadding: widget.closedHeaderPadding,
                  dropdownType: widget._dropdownType,
                  selectedItemsNotifier: selectedItemsNotifier,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
