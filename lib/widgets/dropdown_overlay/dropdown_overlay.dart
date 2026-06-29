part of '../../custom_dropdown.dart';

const _defaultOverlayIconUp = Icon(
  Icons.keyboard_arrow_up_rounded,
  size: 20,
);

const _defaultHeaderPadding = EdgeInsets.all(16.0);
const _overlayOuterPadding =
    EdgeInsetsDirectional.only(bottom: 12, start: 12, end: 12);
const _defaultOverlayShadowOffset = Offset(0, 6);
const _defaultListItemPadding =
    EdgeInsets.symmetric(vertical: 12, horizontal: 16);

class _DropdownOverlay<T> extends StatefulWidget {
  final List<T> items;
  final ScrollController? itemsScrollCtrl;
  final SingleSelectController<T?> selectedItemNotifier;
  final MultiSelectController<T> selectedItemsNotifier;
  final Function(T) onItemSelect;
  final Size size;
  final LayerLink layerLink;
  final GlobalKey fieldKey;
  final VoidCallback hideOverlay;
  final String hintText, searchHintText, noResultFoundText;
  final bool excludeSelected, hideSelectedFieldWhenOpen, canCloseOutsideBounds;
  final _SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final int searchRequestMinChars;
  final int maxLines;
  final double? overlayHeight;
  final TextAlign? textAlign;
  final TextStyle? hintStyle, headerStyle, noResultFoundStyle, listItemStyle;
  final EdgeInsets? headerPadding, listItemPadding, itemsListPadding;
  final Widget? searchRequestLoadingIndicator;
  final _ListItemBuilder<T>? listItemBuilder;
  final _HeaderBuilder<T>? headerBuilder;
  final _HeaderListBuilder<T>? headerListBuilder;
  final _HintBuilder? hintBuilder;
  final _NoResultFoundBuilder? noResultFoundBuilder;
  final CustomDropdownDecoration? decoration;
  final _DropdownType dropdownType;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.itemsScrollCtrl,
    required this.size,
    required this.layerLink,
    required this.fieldKey,
    required this.hideOverlay,
    required this.hintText,
    required this.searchHintText,
    required this.selectedItemNotifier,
    required this.selectedItemsNotifier,
    required this.excludeSelected,
    required this.onItemSelect,
    required this.noResultFoundText,
    required this.canCloseOutsideBounds,
    required this.maxLines,
    required this.overlayHeight,
    required this.textAlign,
    required this.dropdownType,
    required this.decoration,
    required this.hintStyle,
    required this.headerStyle,
    required this.listItemStyle,
    required this.noResultFoundStyle,
    required this.hideSelectedFieldWhenOpen,
    required this.searchRequestLoadingIndicator,
    required this.headerPadding,
    required this.itemsListPadding,
    required this.listItemPadding,
    required this.headerBuilder,
    required this.hintBuilder,
    required this.searchType,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.searchRequestMinChars,
    required this.listItemBuilder,
    required this.headerListBuilder,
    required this.noResultFoundBuilder,
  });

  @override
  _DropdownOverlayState<T> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<_DropdownOverlay<T>>
    with WidgetsBindingObserver {
  bool displayOverly = true, displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  bool? mayFoundSearchRequestResult;
  late List<T> items;
  late T? selectedItem;
  late List<T> selectedItems;
  late ScrollController scrollController;
  final key1 = GlobalKey(), key2 = GlobalKey();

  Widget hintBuilder(BuildContext context) {
    return widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText, true)
        : defaultHintBuilder(context, widget.hintText);
  }

  Widget headerBuilder(BuildContext context) {
    return widget.headerBuilder != null
        ? widget.headerBuilder!(context, selectedItem as T, true)
        : defaultHeaderBuilder(context, item: selectedItem);
  }

  Widget headerListBuilder(BuildContext context) {
    return widget.headerListBuilder != null
        ? widget.headerListBuilder!(context, selectedItems, true)
        : defaultHeaderBuilder(context, items: selectedItems);
  }

  Widget noResultFoundBuilder(BuildContext context) {
    return widget.noResultFoundBuilder != null
        ? widget.noResultFoundBuilder!(context, widget.noResultFoundText)
        : defaultNoResultFoundBuilder(context, widget.noResultFoundText);
  }

  Widget defaultListItemBuilder(
    BuildContext context,
    T result,
    bool isSelected,
    VoidCallback onItemSelect,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            result.toString(),
            maxLines: widget.maxLines,
            textAlign: widget.textAlign,
            overflow: TextOverflow.ellipsis,
            style: widget.listItemStyle ?? const TextStyle(fontSize: 16),
          ),
        ),
        if (widget.dropdownType == _DropdownType.multipleSelect)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12.0),
            child: Checkbox(
              onChanged: (_) => onItemSelect(),
              value: isSelected,
              activeColor:
                  widget.decoration?.listItemDecoration?.selectedIconColor,
              side: widget.decoration?.listItemDecoration?.selectedIconBorder,
              shape: widget.decoration?.listItemDecoration?.selectedIconShape,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
          ),
      ],
    );
  }

  Widget defaultHeaderBuilder(BuildContext context, {T? item, List<T>? items}) {
    return Text(
      items != null ? items.join(', ') : item.toString(),
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      overflow: TextOverflow.ellipsis,
      style: widget.headerStyle ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget defaultHintBuilder(BuildContext context, String hint) {
    return Text(
      hint,
      maxLines: 1,
      textAlign: widget.textAlign,
      overflow: TextOverflow.ellipsis,
      style: widget.hintStyle ??
          const TextStyle(
            fontSize: 16,
            color: Color(0xFFA7A7A7),
          ),
    );
  }

  Widget defaultNoResultFoundBuilder(BuildContext context, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          text,
          style: widget.noResultFoundStyle ?? const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = widget.itemsScrollCtrl ?? ScrollController();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOverlayPosition();
    });

    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;

    widget.selectedItemNotifier.addListener(singleSelectListener);
    widget.selectedItemsNotifier.addListener(multiSelectListener);

    if (widget.excludeSelected &&
        widget.items.length > 1 &&
        selectedItem != null) {
      T value = selectedItem as T;
      items = widget.items.where((item) => item != value).toList();
    } else {
      items = widget.items;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.selectedItemNotifier.removeListener(singleSelectListener);
    widget.selectedItemsNotifier.removeListener(multiSelectListener);

    if (widget.itemsScrollCtrl == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  // Called by the framework whenever the view's metrics change, most notably
  // when the on-screen keyboard opens or closes. Recalculating here keeps the
  // overlay from being hidden behind the keyboard while searching (issue #116).
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Run synchronously (not in a post-frame callback): didChangeMetrics fires
    // before the resized frame is laid out, so adjusting the scroll offset here
    // means the frame is painted with the field already in view. Doing it after
    // the frame would let one frame paint with the field off-screen, flickering
    // the overlay out and back the first time the keyboard opens.
    _ensureFieldVisible();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOverlayPosition();
    });
  }

  // Keep the dropdown field within the (now smaller) viewport when the keyboard
  // is up. If the field belongs to a scrollable that shrank for the keyboard,
  // scrolling it back into view keeps its leader layer painted so the overlay
  // (a CompositedTransformFollower) stays visible instead of vanishing.
  void _ensureFieldVisible() {
    if (!mounted) return;

    final view = View.of(context);
    final devicePixelRatio = view.devicePixelRatio;
    final keyboardHeight = view.viewInsets.bottom / devicePixelRatio;
    if (keyboardHeight <= 0) return;
    final screenHeight = view.physicalSize.height / devicePixelRatio;

    final fieldContext = widget.fieldKey.currentContext;
    final fieldBox = fieldContext?.findRenderObject() as RenderBox?;
    if (fieldContext == null || fieldBox == null || !fieldBox.hasSize) return;

    final position = Scrollable.maybeOf(fieldContext)?.position;
    if (position == null || !position.hasPixels) return;

    // How far the field's bottom extends past the area left above the keyboard.
    const margin = 8.0;
    final fieldBottom =
        fieldBox.localToGlobal(Offset.zero).dy + fieldBox.size.height;
    final overshoot = fieldBottom - (screenHeight - keyboardHeight - margin);
    if (overshoot <= 0) return;

    final target = (position.pixels + overshoot)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    if (target != position.pixels) {
      position.jumpTo(target);
    }
  }

  // Decides whether the overlay should be displayed below or above the dropdown
  // field based on the space actually available, accounting for the keyboard
  // height.
  //
  // The decision is anchored to the field's *live* position (read via
  // [widget.fieldKey]) rather than the overlay's own box. The overlay box moves
  // when it flips and the field moves when the Scaffold resizes for the
  // keyboard; measuring the field directly keeps the inputs stable and prevents
  // the overlay from flip-flopping between top and bottom.
  void _updateOverlayPosition() {
    if (!mounted) return;

    final fieldBox =
        widget.fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final contentBox = key2.currentContext?.findRenderObject() as RenderBox?;
    if (fieldBox == null || !fieldBox.hasSize || contentBox == null) return;

    // Read the keyboard height straight from the platform view rather than from
    // MediaQuery: the overlay is hosted in an Overlay whose MediaQuery can have
    // its bottom viewInsets stripped (by Scaffold/Overlay), which would report a
    // keyboard height of 0 and leave the overlay stuck behind the keyboard.
    final view = View.of(context);
    final devicePixelRatio = view.devicePixelRatio;
    final screenHeight = view.physicalSize.height / devicePixelRatio;
    final keyboardHeight = view.viewInsets.bottom / devicePixelRatio;
    final topInset = view.padding.top / devicePixelRatio;

    // The overlay overlaps the field: when shown below it starts at the field's
    // top edge, when shown above it ends near the field's top edge.
    final fieldTop = fieldBox.localToGlobal(Offset.zero).dy;
    final contentHeight = contentBox.size.height;

    final roomBelow = (screenHeight - keyboardHeight) - fieldTop;
    final roomAbove = fieldTop - topInset;

    final bool shouldDisplayBottom;
    if (roomBelow >= contentHeight) {
      // Fits below (keyboard excluded) — keep the default downward direction.
      shouldDisplayBottom = true;
    } else if (roomAbove >= contentHeight) {
      // Doesn't fit below but fits above — flip up, clear of the keyboard.
      shouldDisplayBottom = false;
    } else {
      // Fits neither way; pick the side with more room.
      shouldDisplayBottom = roomBelow >= roomAbove;
    }

    if (shouldDisplayBottom != displayOverlayBottom) {
      setState(() => displayOverlayBottom = shouldDisplayBottom);
    }
  }

  void singleSelectListener() {
    if (mounted) {
      selectedItem = widget.selectedItemNotifier.value;
    }
  }

  void multiSelectListener() {
    if (mounted) {
      selectedItems = widget.selectedItemsNotifier.value;
    }
  }

  void onItemSelect(T value) {
    widget.onItemSelect(value);
    if (widget.dropdownType == _DropdownType.singleSelect) {
      setState(() => displayOverly = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // decoration
    final decoration = widget.decoration;

    // search availability check
    final onSearch = widget.searchType != null;

    // overlay offset
    final overlayOffset = Offset(-12, displayOverlayBottom ? 0 : 64);

    // list padding
    final listPadding =
        onSearch ? const EdgeInsets.only(top: 8) : EdgeInsets.zero;

    // items list
    final list = items.isNotEmpty
        ? _ItemsList<T>(
            scrollController: scrollController,
            listItemBuilder: widget.listItemBuilder ?? defaultListItemBuilder,
            excludeSelected: items.length > 1 ? widget.excludeSelected : false,
            selectedItem: selectedItem,
            selectedItems: selectedItems,
            items: items,
            itemsListPadding: widget.itemsListPadding ?? listPadding,
            listItemPadding: widget.listItemPadding ?? _defaultListItemPadding,
            onItemSelect: onItemSelect,
            decoration: decoration?.listItemDecoration,
            dropdownType: widget.dropdownType,
          )
        : (mayFoundSearchRequestResult != null &&
                    !mayFoundSearchRequestResult!) ||
                widget.searchType == _SearchType.onListData
            ? noResultFoundBuilder(context)
            : const SizedBox(height: 12);

    final child = Stack(
      children: [
        Positioned(
          width: widget.size.width + 24,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            followerAnchor:
                displayOverlayBottom ? Alignment.topLeft : Alignment.bottomLeft,
            showWhenUnlinked: false,
            offset: overlayOffset,
            child: Container(
              key: key1,
              margin: _overlayOuterPadding,
              decoration: BoxDecoration(
                color: decoration?.expandedFillColor ??
                    CustomDropdownDecoration._defaultFillColor,
                border: decoration?.expandedBorder,
                borderRadius:
                    decoration?.expandedBorderRadius ?? _defaultBorderRadius,
                boxShadow: decoration?.expandedShadow ??
                    [
                      BoxShadow(
                        blurRadius: 24.0,
                        color: Colors.black.withOpacity(.08),
                        offset: _defaultOverlayShadowOffset,
                      ),
                    ],
              ),
              child: Material(
                color: Colors.transparent,
                child: _AnimatedSection(
                  animationDismissed: widget.hideOverlay,
                  expand: displayOverly,
                  axisAlignment: displayOverlayBottom ? 1.0 : -1.0,
                  child: SizedBox(
                    key: key2,
                    height: items.length > 4
                        ? widget.overlayHeight ?? (onSearch ? 270 : 225)
                        : null,
                    child: ClipRRect(
                      borderRadius: decoration?.expandedBorderRadius ??
                          _defaultBorderRadius,
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (notification) {
                          notification.disallowIndicator();
                          return true;
                        },
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            scrollbarTheme: decoration
                                    ?.overlayScrollbarDecoration ??
                                ScrollbarThemeData(
                                  thumbVisibility: MaterialStateProperty.all(
                                    true,
                                  ),
                                  thickness: MaterialStateProperty.all(5),
                                  radius: const Radius.circular(4),
                                  thumbColor: MaterialStateProperty.all(
                                    Colors.grey[300],
                                  ),
                                ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!widget.hideSelectedFieldWhenOpen)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() => displayOverly = false);
                                  },
                                  child: Padding(
                                    padding: widget.headerPadding ??
                                        _defaultHeaderPadding,
                                    child: Row(
                                      children: [
                                        if (widget.decoration?.prefixIcon !=
                                            null) ...[
                                          widget.decoration!.prefixIcon!,
                                          const SizedBox(width: 12),
                                        ],
                                        Expanded(
                                          child: switch (widget.dropdownType) {
                                            _DropdownType.singleSelect =>
                                              selectedItem != null
                                                  ? headerBuilder(context)
                                                  : hintBuilder(context),
                                            _DropdownType.multipleSelect =>
                                              selectedItems.isNotEmpty
                                                  ? headerListBuilder(context)
                                                  : hintBuilder(context),
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        decoration?.expandedSuffixIcon ??
                                            _defaultOverlayIconUp,
                                      ],
                                    ),
                                  ),
                                ),
                              if (onSearch &&
                                  widget.searchType == _SearchType.onListData)
                                if (!widget.hideSelectedFieldWhenOpen)
                                  _SearchField<T>.forListData(
                                    items: widget.items,
                                    searchHintText: widget.searchHintText,
                                    onSearchedItems: (val) {
                                      setState(() => items = val);
                                    },
                                    decoration:
                                        decoration?.searchFieldDecoration,
                                  )
                                else
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() => displayOverly = false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        top: 12.0,
                                        start: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          if (widget.decoration?.prefixIcon !=
                                              null) ...[
                                            widget.decoration!.prefixIcon!,
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child: _SearchField<T>.forListData(
                                              items: widget.items,
                                              searchHintText:
                                                  widget.searchHintText,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                              decoration: decoration
                                                  ?.searchFieldDecoration,
                                            ),
                                          ),
                                          decoration?.expandedSuffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                  )
                              else if (onSearch &&
                                  widget.searchType ==
                                      _SearchType.onRequestData)
                                if (!widget.hideSelectedFieldWhenOpen)
                                  _SearchField<T>.forRequestData(
                                    items: widget.items,
                                    searchHintText: widget.searchHintText,
                                    onFutureRequestLoading: (val) {
                                      setState(() {
                                        isSearchRequestLoading = val;
                                      });
                                    },
                                    futureRequest: widget.futureRequest,
                                    futureRequestDelay:
                                        widget.futureRequestDelay,
                                    minChars: widget.searchRequestMinChars,
                                    onSearchedItems: (val) {
                                      setState(() => items = val);
                                    },
                                    mayFoundResult: (val) =>
                                        mayFoundSearchRequestResult = val,
                                    decoration:
                                        decoration?.searchFieldDecoration,
                                  )
                                else
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() => displayOverly = false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        top: 12.0,
                                        start: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          if (widget.decoration?.prefixIcon !=
                                              null) ...[
                                            widget.decoration!.prefixIcon!,
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child:
                                                _SearchField<T>.forRequestData(
                                              items: widget.items,
                                              searchHintText:
                                                  widget.searchHintText,
                                              onFutureRequestLoading: (val) {
                                                setState(() {
                                                  isSearchRequestLoading = val;
                                                });
                                              },
                                              futureRequest:
                                                  widget.futureRequest,
                                              futureRequestDelay:
                                                  widget.futureRequestDelay,
                                              minChars:
                                                  widget.searchRequestMinChars,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                              mayFoundResult: (val) =>
                                                  mayFoundSearchRequestResult =
                                                      val,
                                              decoration: decoration
                                                  ?.searchFieldDecoration,
                                            ),
                                          ),
                                          decoration?.expandedSuffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                  ),
                              if (isSearchRequestLoading)
                                widget.searchRequestLoadingIndicator ??
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      ),
                                    )
                              else
                                items.length > 4 ? Expanded(child: list) : list
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (widget.canCloseOutsideBounds) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() => displayOverly = false),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          child,
        ],
      );
    }

    return child;
  }
}
