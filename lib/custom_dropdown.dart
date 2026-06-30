library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

export 'custom_dropdown.dart';

// models
part 'models/custom_dropdown_decoration.dart';
part 'models/custom_dropdown_list_filter.dart';
part 'models/disabled_decoration.dart';
part 'models/list_item_decoration.dart';
part 'models/controllers.dart';
part 'models/search_field_decoration.dart';
part 'models/custom_dropdown_animation.dart';
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

/// Controls the side the overlay opens towards.
enum DropdownOverlayDirection {
  /// Open below if there is room, otherwise above (keyboard-aware). Default.
  auto,

  /// Always open below the field.
  below,

  /// Always open above the field.
  above,
}

const _defaultErrorColor = Colors.red;

const _defaultBorderRadius = BorderRadius.all(
  Radius.circular(12),
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

  /// Scroll controller to access items list scroll behavior.
  final ScrollController? itemsScrollController;

  /// Text that suggests what sort of data the dropdown represents.
  ///
  /// Default to "Select value".
  final String? hintText;

  /// Optional Material-style floating label shown above/inside the closed
  /// field. When provided it acts as the field's placeholder while resting and
  /// floats up once the dropdown has a value or is open (see
  /// [CustomDropdownDecoration.floatingLabelBehavior]).
  final String? labelText;

  /// A custom widget for the floating label, used instead of [labelText] for
  /// full control (e.g. an icon + text). It is positioned and floated the same
  /// way; plain [Text] descendants still pick up [CustomDropdownDecoration]'s
  /// `labelStyle` / `floatingLabelStyle` unless you style them explicitly.
  final Widget? label;

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
  final Function(T?)? onChanged;

  /// Called when the list of items of the [CustomDropdown] should change.
  final Function(List<T>)? onListChanged;

  /// Hide the selected item from the [items] list.
  final bool excludeSelected;

  /// Whether tapping a list item selects it.
  ///
  /// Defaults to `true` (tapping the row selects the item). Set to `false` to
  /// take full control of selection from inside [listItemBuilder] — the row no
  /// longer auto-selects, and your builder decides when to call the
  /// `onItemSelect` callback it receives.
  final bool selectOnItemTap;

  /// Can close [CustomDropdown] overlay by tapping outside.
  /// Here "outside" covers the entire screen.
  final bool canCloseOutsideBounds;

  /// Hide the header field when [CustomDropdown] overlay opened/expanded.
  final bool hideSelectedFieldWhenExpanded;

  /// The asynchronous computation from which the items list returns.
  final Future<List<T>> Function(String)? futureRequest;

  /// Page-aware async request enabling infinite scroll (lazy loading).
  ///
  /// When provided (instead of [futureRequest]) the dropdown loads the first
  /// page on open/search and appends the next page as the user scrolls near the
  /// bottom, stopping once a page returns fewer than [pageSize] items.
  final PaginatedSearchRequest<T>? paginatedRequest;

  /// Number of items per page for [paginatedRequest]. A page with fewer than
  /// this many items is treated as the last page. Defaults to `20`.
  final int pageSize;

  /// Widget shown at the bottom of the list while the next page loads.
  final Widget? loadMoreIndicator;

  /// Text that notify there's no search results match.
  ///
  /// Default to "No result found.".
  final String? noResultFoundText;

  /// Duration after which the [futureRequest] is to be executed.
  final Duration? futureRequestDelay;

  /// Minimum number of characters that must be typed before [futureRequest]
  /// is triggered. Below this length the request is not made and the base
  /// [items] are shown. Only applies to the search-request constructors.
  ///
  /// Defaults to `0` (request on every change).
  final int searchRequestMinChars;

  /// Text maxlines for header and list item text.
  final int maxlines;

  /// Text align for head, hint and list item and so on.
  /// Default [TextAlign.start]
  final TextAlign textAlign;

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

  /// Controls how the overlay animates open and closed.
  ///
  /// Defaults to a height + fade reveal. Provide a [CustomDropdownAnimation] to
  /// pick a different built-in transition, tune the duration/curves, disable
  /// animation ([CustomDropdownAnimation.none]) or supply a fully custom
  /// transition.
  final CustomDropdownAnimation animation;

  /// Open the dropdown overlay automatically on first build.
  ///
  /// Defaults to `false`.
  final bool initiallyOpen;

  /// The side the overlay opens towards.
  ///
  /// Defaults to [DropdownOverlayDirection.auto] (open below if there is room,
  /// otherwise above). Use `below`/`above` to force a direction.
  final DropdownOverlayDirection overlayDirection;

  /// Autofocus the search field (raising the keyboard) when the overlay opens.
  /// Only applies to the search constructors. Defaults to `false`.
  final bool autofocusOnSearch;

  /// [CustomDropdown] enabled/disabled state.
  /// If disabled, you can not open the dropdown.
  final bool enabled;

  /// When `true`, a clear button is shown on the closed field while there is a
  /// selection, allowing the user to reset it back to the empty/hint state.
  ///
  /// For single-select this sets the value back to `null`; for multi-select it
  /// clears all selected items. Defaults to `false`.
  final bool canClearSelection;

  /// [CustomDropdown] disabled decoration.
  ///
  /// Note: Only applicable if dropdown is disabled.
  final CustomDropdownDisabledDecoration? disabledDecoration;

  /// [CustomDropdown] will close on tap Clear filter for all search
  /// and searchRequest constructors
  final bool closeDropDownOnClearFilterSearch;

  /// The [overlayController] allows you to explicitly handle the [CustomDropdown] overlay states (show/hide).
  final OverlayPortalController? overlayController;

  /// The [controller] that can be used to control [CustomDropdown] selected item.
  final SingleSelectController<T?>? controller;

  /// The [multiSelectController] that can be used to control [CustomDropdown.multiSelect] selected items.
  final MultiSelectController<T>? multiSelectController;

  /// Callback for dropdown [visibility].
  ///
  /// If both [visibility] and [overlayController] are provided, this callback never listens the changes of [overlayController].
  /// You have to explicitly check for [overlayController] visibility states using its `isShowing` property.
  final Function(bool)? visibility;

  final _SearchType? _searchType;

  final _DropdownType _dropdownType;

  CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.controller,
    this.itemsScrollController,
    this.initialItem,
    this.hintText,
    this.labelText,
    this.label,
    this.decoration,
    this.validator,
    this.validateOnChange = true,
    this.visibility,
    this.overlayController,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.maxlines = 1,
    this.textAlign = TextAlign.start,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = true,
    this.enabled = true,
    this.canClearSelection = false,
    this.selectOnItemTap = true,
    this.animation = const CustomDropdownAnimation(),
    this.initiallyOpen = false,
    this.autofocusOnSearch = false,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.disabledDecoration,
  })  : assert(
          initialItem == null || controller == null,
          'Only one of initialItem or controller can be specified at a time',
        ),
        assert(
          initialItem == null || items!.contains(initialItem),
          'Initial item must match with one of the item in items list.',
        ),
        assert(
          controller == null ||
              controller.value == null ||
              items!.contains(controller.value),
          'Controller value must match with one of the item in items list.',
        ),
        _searchType = null,
        _dropdownType = _DropdownType.singleSelect,
        futureRequest = null,
        futureRequestDelay = null,
        searchRequestMinChars = 0,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        noResultFoundBuilder = null,
        noResultFoundText = null,
        searchHintText = null,
        initialItems = null,
        onListChanged = null,
        listValidator = null,
        headerListBuilder = null,
        searchRequestLoadingIndicator = null,
        closeDropDownOnClearFilterSearch = false,
        multiSelectController = null;

  CustomDropdown.search({
    super.key,
    required this.items,
    required this.onChanged,
    this.controller,
    this.itemsScrollController,
    this.initialItem,
    this.hintText,
    this.labelText,
    this.label,
    this.decoration,
    this.visibility,
    this.overlayController,
    this.searchHintText,
    this.noResultFoundText,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.validator,
    this.validateOnChange = true,
    this.maxlines = 1,
    this.textAlign = TextAlign.start,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.enabled = true,
    this.canClearSelection = false,
    this.selectOnItemTap = true,
    this.animation = const CustomDropdownAnimation(),
    this.initiallyOpen = false,
    this.autofocusOnSearch = false,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.disabledDecoration,
    this.closeDropDownOnClearFilterSearch = false,
  })  : assert(
          initialItem == null || controller == null,
          'Only one of initialItem or controller can be specified at a time',
        ),
        assert(
          initialItem == null || items!.contains(initialItem),
          'Initial item must match with one of the item in items list.',
        ),
        assert(
          controller == null ||
              controller.value == null ||
              items!.contains(controller.value),
          'Controller value must match with one of the item in items list.',
        ),
        _searchType = _SearchType.onListData,
        _dropdownType = _DropdownType.singleSelect,
        futureRequest = null,
        futureRequestDelay = null,
        searchRequestMinChars = 0,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        initialItems = null,
        onListChanged = null,
        listValidator = null,
        headerListBuilder = null,
        searchRequestLoadingIndicator = null,
        multiSelectController = null;

  const CustomDropdown.searchRequest({
    super.key,
    this.futureRequest,
    required this.onChanged,
    this.paginatedRequest,
    this.pageSize = 20,
    this.loadMoreIndicator,
    this.futureRequestDelay,
    this.searchRequestMinChars = 0,
    this.initialItem,
    this.items,
    this.controller,
    this.itemsScrollController,
    this.hintText,
    this.labelText,
    this.label,
    this.decoration,
    this.visibility,
    this.overlayController,
    this.searchHintText,
    this.noResultFoundText,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.validator,
    this.validateOnChange = true,
    this.maxlines = 1,
    this.textAlign = TextAlign.start,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.searchRequestLoadingIndicator,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.enabled = true,
    this.canClearSelection = false,
    this.selectOnItemTap = true,
    this.animation = const CustomDropdownAnimation(),
    this.initiallyOpen = false,
    this.autofocusOnSearch = false,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.disabledDecoration,
    this.closeDropDownOnClearFilterSearch = false,
  })  : assert(
          initialItem == null || controller == null,
          'Only one of initialItem or controller can be specified at a time',
        ),
        assert(
          (futureRequest == null) != (paginatedRequest == null),
          'Provide exactly one of futureRequest or paginatedRequest',
        ),
        _searchType = _SearchType.onRequestData,
        _dropdownType = _DropdownType.singleSelect,
        initialItems = null,
        onListChanged = null,
        listValidator = null,
        headerListBuilder = null,
        multiSelectController = null;

  CustomDropdown.multiSelect({
    super.key,
    required this.items,
    required this.onListChanged,
    this.multiSelectController,
    this.controller,
    this.initialItems,
    this.overlayController,
    this.itemsScrollController,
    this.listValidator,
    this.visibility,
    this.headerListBuilder,
    this.hintText,
    this.labelText,
    this.label,
    this.decoration,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.hintBuilder,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.maxlines = 1,
    this.textAlign = TextAlign.start,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.enabled = true,
    this.canClearSelection = false,
    this.selectOnItemTap = true,
    this.animation = const CustomDropdownAnimation(),
    this.initiallyOpen = false,
    this.autofocusOnSearch = false,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.disabledDecoration,
  })  : assert(
          initialItems == null || multiSelectController == null,
          'Only one of initialItems or controller can be specified at a time',
        ),
        assert(
          initialItems == null ||
              initialItems.isEmpty ||
              initialItems.any((e) => items!.contains(e)),
          'Initial items must match with the items in the items list.',
        ),
        assert(
          multiSelectController == null ||
              multiSelectController.value.isEmpty ||
              multiSelectController.value.any((e) => items!.contains(e)),
          'Controller value must match with one of the item in items list.',
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
        searchRequestMinChars = 0,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        noResultFoundBuilder = null,
        searchHintText = null,
        searchRequestLoadingIndicator = null,
        closeDropDownOnClearFilterSearch = false;

  CustomDropdown.multiSelectSearch({
    super.key,
    required this.items,
    required this.onListChanged,
    this.multiSelectController,
    this.initialItems,
    this.controller,
    this.visibility,
    this.itemsScrollController,
    this.overlayController,
    this.listValidator,
    this.listItemBuilder,
    this.hintBuilder,
    this.decoration,
    this.headerListBuilder,
    this.noResultFoundText,
    this.noResultFoundBuilder,
    this.hintText,
    this.labelText,
    this.label,
    this.searchHintText,
    this.validateOnChange = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.maxlines = 1,
    this.textAlign = TextAlign.start,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.enabled = true,
    this.canClearSelection = false,
    this.selectOnItemTap = true,
    this.animation = const CustomDropdownAnimation(),
    this.initiallyOpen = false,
    this.autofocusOnSearch = false,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.disabledDecoration,
    this.closeDropDownOnClearFilterSearch = false,
  })  : assert(
          initialItems == null || multiSelectController == null,
          'Only one of initialItems or controller can be specified at a time',
        ),
        assert(
          initialItems == null ||
              initialItems.isEmpty ||
              initialItems.any((e) => items!.contains(e)),
          'Initial items must match with the items in the items list.',
        ),
        assert(
          multiSelectController == null ||
              multiSelectController.value.isEmpty ||
              multiSelectController.value.any((e) => items!.contains(e)),
          'Controller value must match with one of the item in items list.',
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
        searchRequestMinChars = 0,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        searchRequestLoadingIndicator = null;

  const CustomDropdown.multiSelectSearchRequest({
    super.key,
    this.futureRequest,
    required this.onListChanged,
    this.paginatedRequest,
    this.pageSize = 20,
    this.loadMoreIndicator,
    this.multiSelectController,
    this.futureRequestDelay,
    this.searchRequestMinChars = 0,
    this.initialItems,
    this.items,
    this.controller,
    this.itemsScrollController,
    this.overlayController,
    this.visibility,
    this.hintText,
    this.labelText,
    this.label,
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
    this.textAlign = TextAlign.start,
    this.overlayHeight,
    this.searchRequestLoadingIndicator,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.enabled = true,
    this.canClearSelection = false,
    this.selectOnItemTap = true,
    this.animation = const CustomDropdownAnimation(),
    this.initiallyOpen = false,
    this.autofocusOnSearch = false,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.disabledDecoration,
    this.closeDropDownOnClearFilterSearch = false,
  })  : assert(
          initialItems == null || multiSelectController == null,
          'Only one of initialItems or controller can be specified at a time',
        ),
        assert(
          (futureRequest == null) != (paginatedRequest == null),
          'Provide exactly one of futureRequest or paginatedRequest',
        ),
        _searchType = _SearchType.onRequestData,
        _dropdownType = _DropdownType.multipleSelect,
        initialItem = null,
        onChanged = null,
        headerBuilder = null,
        excludeSelected = false,
        validator = null;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with AutomaticKeepAliveClientMixin {
  final layerLink = LayerLink();

  /// Key on the dropdown field, used by the overlay to read the field's live
  /// position so it can flip above/below the field reliably (e.g. to stay
  /// clear of the on-screen keyboard).
  final fieldKey = GlobalKey();
  late SingleSelectController<T?> selectedItemNotifier;
  late MultiSelectController<T> selectedItemsNotifier;
  FormFieldState<(T?, List<T>)>? _formFieldState;

  /// Whether the overlay is currently open. While open we keep this widget
  /// alive so that a scrollable parent (e.g. a ListView) can't dispose it —
  /// and tear down the open overlay — when the keyboard pushes the field out
  /// of the viewport.
  bool _overlayOpen = false;

  @override
  bool get wantKeepAlive => _overlayOpen;

  void _onVisibilityChanged(bool visible) {
    if (_overlayOpen != visible) {
      _overlayOpen = visible;
      updateKeepAlive();
      // Rebuild so a floating label can react to the open/closed state.
      if (mounted) setState(() {});
    }
    widget.visibility?.call(visible);
  }

  void _clearSelection() {
    switch (widget._dropdownType) {
      case _DropdownType.singleSelect:
        selectedItemNotifier.value = null;
      case _DropdownType.multipleSelect:
        selectedItemsNotifier.value = [];
    }
  }

  void _selectedItemListener() {
    widget.onChanged?.call(selectedItemNotifier.value);
    _formFieldState?.didChange((selectedItemNotifier.value, []));
    if (widget.validateOnChange) {
      _formFieldState?.validate();
    }
  }

  void _selectedItemsListener() {
    widget.onListChanged?.call(selectedItemsNotifier.value);
    _formFieldState?.didChange((null, selectedItemsNotifier.value));
    if (widget.validateOnChange) {
      _formFieldState?.validate();
    }
  }

  @override
  void initState() {
    super.initState();

    selectedItemNotifier =
        widget.controller ?? SingleSelectController(widget.initialItem);

    selectedItemsNotifier = widget.multiSelectController ??
        MultiSelectController(widget.initialItems ?? []);

    selectedItemNotifier.addListener(_selectedItemListener);

    selectedItemsNotifier.addListener(_selectedItemsListener);
  }

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialItem != oldWidget.initialItem &&
        selectedItemNotifier.value != widget.initialItem) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        selectedItemNotifier.value = widget.initialItem;
      });
    }

    if (widget.initialItems != oldWidget.initialItems &&
        selectedItemsNotifier.value != widget.initialItems) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        selectedItemsNotifier.value = widget.initialItems ?? [];
      });
    }

    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      selectedItemNotifier = widget.controller!;
    }

    if (widget.multiSelectController != oldWidget.multiSelectController &&
        widget.multiSelectController != null) {
      selectedItemsNotifier = widget.multiSelectController!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      selectedItemNotifier.dispose();
    } else {
      selectedItemNotifier.removeListener(_selectedItemListener);
    }

    if (widget.multiSelectController == null) {
      selectedItemsNotifier.dispose();
    } else {
      selectedItemsNotifier.removeListener(_selectedItemsListener);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin

    final enabled = widget.enabled;
    final decoration = widget.decoration;
    final disabledDecoration = widget.disabledDecoration;
    final safeHintText = widget.hintText ?? 'Select value';

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: FormField<(T?, List<T>)>(
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
          _formFieldState = formFieldState;
          return InputDecorator(
            // Fully neutralize the ambient `inputDecorationTheme`. Since Flutter
            // 3.35 `InputDecorator` merges the theme's decoration, which would
            // otherwise re-introduce a border, an opaque fill and horizontal
            // padding around the dropdown (issues #115, #117, #110). We only
            // want this decorator to surface the FormField's error text.
            decoration: InputDecoration(
              errorStyle: decoration?.errorStyle ?? _defaultErrorStyle,
              errorText: formFieldState.errorText,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              filled: false,
              fillColor: Colors.transparent,
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
            ),
            child: _OverlayBuilder(
              overlayPortalController: widget.overlayController,
              initiallyOpen: widget.initiallyOpen,
              visibility: _onVisibilityChanged,
              overlay: (size, hideCallback) {
                return _DropdownOverlay<T>(
                  onItemSelect: (T value) {
                    switch (widget._dropdownType) {
                      case _DropdownType.singleSelect:
                        selectedItemNotifier.value = value;
                      case _DropdownType.multipleSelect:
                        final currentVal = selectedItemsNotifier.value.toList();
                        if (currentVal.contains(value)) {
                          currentVal.remove(value);
                        } else {
                          currentVal.add(value);
                        }
                        selectedItemsNotifier.value = currentVal;
                    }
                  },
                  noResultFoundText:
                      widget.noResultFoundText ?? 'No result found.',
                  noResultFoundBuilder: widget.noResultFoundBuilder,
                  items: widget.items ?? [],
                  itemsScrollCtrl: widget.itemsScrollController,
                  selectedItemNotifier: selectedItemNotifier,
                  selectedItemsNotifier: selectedItemsNotifier,
                  size: size,
                  listItemBuilder: widget.listItemBuilder,
                  layerLink: layerLink,
                  fieldKey: fieldKey,
                  hideOverlay: hideCallback,
                  textAlign: widget.textAlign,
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
                  selectOnItemTap: widget.selectOnItemTap,
                  overlayDirection: widget.overlayDirection,
                  animation: widget.animation,
                  canCloseOutsideBounds: widget.canCloseOutsideBounds,
                  searchType: widget._searchType,
                  autofocusOnSearch: widget.autofocusOnSearch,
                  futureRequest: widget.futureRequest,
                  futureRequestDelay: widget.futureRequestDelay,
                  searchRequestMinChars: widget.searchRequestMinChars,
                  paginatedRequest: widget.paginatedRequest,
                  pageSize: widget.pageSize,
                  loadMoreIndicator: widget.loadMoreIndicator,
                  hideSelectedFieldWhenOpen:
                      widget.hideSelectedFieldWhenExpanded,
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
                  key: fieldKey,
                  link: layerLink,
                  child: _DropDownField<T>(
                    onTap: showCallback,
                    selectedItemNotifier: selectedItemNotifier,
                    border: formFieldState.hasError
                        ? (decoration?.closedErrorBorder ??
                            Border.all(
                              color: decoration?.errorStyle?.color ??
                                  _defaultErrorColor,
                              width: 1.5,
                            ))
                        : enabled
                            ? decoration?.closedBorder
                            : disabledDecoration?.border,
                    borderRadius: formFieldState.hasError
                        ? decoration?.closedErrorBorderRadius
                        : enabled
                            ? decoration?.closedBorderRadius
                            : disabledDecoration?.borderRadius,
                    textAlign: widget.textAlign,
                    shadow: enabled
                        ? decoration?.closedShadow
                        : disabledDecoration?.shadow,
                    hintStyle: enabled
                        ? decoration?.hintStyle
                        : disabledDecoration?.hintStyle,
                    headerStyle: enabled
                        ? decoration?.headerStyle
                        : disabledDecoration?.headerStyle,
                    hintText: safeHintText,
                    hintBuilder: widget.hintBuilder,
                    headerBuilder: widget.headerBuilder,
                    headerListBuilder: widget.headerListBuilder,
                    prefixIcon: enabled
                        ? decoration?.prefixIcon
                        : disabledDecoration?.prefixIcon,
                    suffixIcon: enabled
                        ? decoration?.closedSuffixIcon
                        : disabledDecoration?.suffixIcon,
                    fillColor: enabled
                        ? decoration?.closedFillColor
                        : disabledDecoration?.fillColor,
                    maxLines: widget.maxlines,
                    headerPadding: widget.closedHeaderPadding,
                    headerHeight: decoration?.closedHeaderHeight,
                    dropdownType: widget._dropdownType,
                    selectedItemsNotifier: selectedItemsNotifier,
                    enabled: widget.enabled,
                    canClearSelection: widget.canClearSelection,
                    onClear: _clearSelection,
                    labelText: widget.labelText,
                    label: widget.label,
                    labelStyle: decoration?.labelStyle,
                    floatingLabelStyle: decoration?.floatingLabelStyle,
                    floatingLabelBehavior: decoration?.floatingLabelBehavior ??
                        FloatingLabelBehavior.auto,
                    floatingLabelGap: decoration?.floatingLabelGap ?? 16,
                    isOpen: _overlayOpen,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
