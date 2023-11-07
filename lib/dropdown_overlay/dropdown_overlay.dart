part of '../custom_dropdown.dart';

const _defaultOverlayIconUp = Icon(
  Icons.keyboard_arrow_up_rounded,
  color: Colors.black,
  size: 20,
);

const _headerPadding = EdgeInsets.all(16.0);
const _overlayOuterPadding = EdgeInsets.only(bottom: 12, left: 12, right: 12);
const _overlayShadowOffset = Offset(0, 6);
const _listItemPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 16);

class _DropdownOverlay<T> extends StatefulWidget {
  final List<T> items;
  final ValueNotifier<T?> selectedItemNotifier;

  final _ValueNotifierList<T> selectedItemsNotifier;

  final Function(T) onItemSelect;
  final Size size;
  final LayerLink layerLink;
  final VoidCallback hideOverlay;
  final String hintText;
  final bool excludeSelected;
  final bool? hideSelectedFieldWhenOpen;
  final bool canCloseOutsideBounds;
  final _SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final Color? fillColor;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final String noResultFoundText;
  final Widget? suffixIcon;
  // ignore: library_private_types_in_public_api
  final _ListItemBuilder<T>? listItemBuilder;
  // ignore: library_private_types_in_public_api
  final _HeaderBuilder<T>? headerBuilder;

  // ignore: library_private_types_in_public_api
  final _HeaderListBuilder<T>? headerListBuilder;

  // ignore: library_private_types_in_public_api
  final _HintBuilder? hintBuilder;
  // ignore: library_private_types_in_public_api
  final _NoResultFoundBuilder? noResultFoundBuilder;

  final _DropdownType widgetType;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.hintText,
    required this.selectedItemNotifier,
    required this.selectedItemsNotifier,
    required this.excludeSelected,
    required this.onItemSelect,
    required this.noResultFoundText,
    required this.canCloseOutsideBounds,
    required this.widgetType,
    this.suffixIcon,
    this.headerBuilder,
    this.hintBuilder,
    this.hideSelectedFieldWhenOpen = false,
    this.searchType,
    this.futureRequest,
    this.futureRequestDelay,
    this.listItemBuilder,
    this.headerListBuilder,
    this.noResultFoundBuilder,
    this.border,
    this.borderRadius,
    this.fillColor,
  }) : super(key: key);

  @override
  _DropdownOverlayState<T> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<_DropdownOverlay<T>> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  bool? mayFoundSearchRequestResult;

  late List<T> items;
  late T? selectedItem;

  late List<T> selectedItems;

  final key1 = GlobalKey(), key2 = GlobalKey();
  final scrollController = ScrollController();

  Widget defaultListItemBuilder(BuildContext context, T result) {
    return Text(
      result.toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget defaultHeaderBuilder(BuildContext context,
      {T? oneItem, List<T>? itemList}) {
    return Text(
      itemList != null ? itemList.join(',') : oneItem.toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16),
    );
  }

  // default header builder
  Widget defaultHintBuilder(BuildContext context, String hint) {
    return Text(
      hint,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFFA7A7A7),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget noResultFoundBuilder(BuildContext context, String text) {
    if (widget.noResultFoundBuilder != null) {
      return widget.noResultFoundBuilder!(context, text);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final render1 = key1.currentContext?.findRenderObject() as RenderBox;
      final render2 = key2.currentContext?.findRenderObject() as RenderBox;
      final screenHeight = MediaQuery.of(context).size.height;
      double y = render1.localToGlobal(Offset.zero).dy;
      if (screenHeight - y < render2.size.height) {
        displayOverlayBottom = false;
        setState(() {});
      }
    });

    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;

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
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // search availability check
    final onSearch = widget.searchType != null;

    // overlay offset
    final overlayOffset = Offset(-12, displayOverlayBottom ? 0 : 60);

    // list padding
    final listPadding =
        onSearch ? const EdgeInsets.only(top: 8) : EdgeInsets.zero;

    Widget hintBuilder() => widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText)
        : defaultHintBuilder(context, widget.hintText);

    // items list
    final list = items.isNotEmpty
        ? _ItemsList<T>(
            scrollController: scrollController,
            listItemBuilder: widget.listItemBuilder ?? defaultListItemBuilder,
            excludeSelected: items.length > 1 ? widget.excludeSelected : false,
            selectedItem: selectedItem,
            selectedItems: selectedItems,
            items: items,
            padding: listPadding,
            onItemSelect: (T value) {
              widget.onItemSelect(value);
              if (widget.widgetType != _DropdownType.multiSelect) {
                setState(() => displayOverly = false);
              }
            },
            widgetType: widget.widgetType,
          )
        : (mayFoundSearchRequestResult != null &&
                    !mayFoundSearchRequestResult!) ||
                widget.searchType == _SearchType.onListData
            ? noResultFoundBuilder(context, widget.noResultFoundText)
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
              padding: _overlayOuterPadding,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.fillColor ?? _defaultFillColor,
                  border: widget.border,
                  borderRadius: widget.borderRadius ?? _defaultBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24.0,
                      color: Colors.black.withOpacity(.08),
                      offset: _overlayShadowOffset,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedSection(
                    animationDismissed: widget.hideOverlay,
                    expand: displayOverly,
                    axisAlignment: displayOverlayBottom ? 1.0 : -1.0,
                    child: SizedBox(
                      key: key2,
                      height: items.length > 4
                          ? onSearch
                              ? 270
                              : 225
                          : null,
                      child: ClipRRect(
                        borderRadius:
                            widget.borderRadius ?? _defaultBorderRadius,
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (notification) {
                            notification.disallowIndicator();
                            return true;
                          },
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              scrollbarTheme: ScrollbarThemeData(
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
                                if (!widget.hideSelectedFieldWhenOpen!)
                                  Padding(
                                    padding: _headerPadding,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: switch (widget.widgetType) {
                                            _DropdownType.singleValue =>
                                              selectedItem != null
                                                  ? widget.headerBuilder != null
                                                      ? widget.headerBuilder!(
                                                          context,
                                                          selectedItem as T)
                                                      : defaultHeaderBuilder(
                                                          context,
                                                          oneItem: selectedItem)
                                                  : hintBuilder(),
                                            _DropdownType.multiSelect =>
                                              selectedItems.isNotEmpty
                                                  ? widget.headerListBuilder !=
                                                          null
                                                      ? widget.headerListBuilder!(
                                                          context,
                                                          selectedItems)
                                                      : defaultHeaderBuilder(
                                                          context,
                                                          itemList:
                                                              selectedItems)
                                                  : hintBuilder(),
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        widget.suffixIcon ??
                                            _defaultOverlayIconUp,
                                      ],
                                    ),
                                  ),
                                if (onSearch &&
                                    widget.searchType == _SearchType.onListData)
                                  if (!widget.hideSelectedFieldWhenOpen!)
                                    _SearchField<T>.forListData(
                                      items: widget.items,
                                      onSearchedItems: (val) {
                                        setState(() => items = val);
                                      },
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        left: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _SearchField<T>.forListData(
                                              items: widget.items,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                            ),
                                          ),
                                          widget.suffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    )
                                else if (onSearch &&
                                    widget.searchType ==
                                        _SearchType.onRequestData)
                                  if (!widget.hideSelectedFieldWhenOpen!)
                                    _SearchField<T>.forRequestData(
                                      items: widget.items,
                                      onFutureRequestLoading: (val) {
                                        setState(() {
                                          isSearchRequestLoading = val;
                                        });
                                      },
                                      futureRequest: widget.futureRequest,
                                      futureRequestDelay:
                                          widget.futureRequestDelay,
                                      onSearchedItems: (val) {
                                        setState(() => items = val);
                                      },
                                      mayFoundResult: (val) =>
                                          mayFoundSearchRequestResult = val,
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        left: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:
                                                _SearchField<T>.forRequestData(
                                              items: items,
                                              onFutureRequestLoading: (val) {
                                                setState(() {
                                                  isSearchRequestLoading = val;
                                                });
                                              },
                                              futureRequest:
                                                  widget.futureRequest,
                                              futureRequestDelay:
                                                  widget.futureRequestDelay,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                              mayFoundResult: (val) =>
                                                  mayFoundSearchRequestResult =
                                                      val,
                                            ),
                                          ),
                                          widget.suffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                if (isSearchRequestLoading)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Center(
                                        child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 3,
                                      ),
                                    )),
                                  )
                                else
                                  items.length > 4
                                      ? Expanded(child: list)
                                      : list
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
        ),
      ],
    );

    return GestureDetector(
      onTap: () => setState(() => displayOverly = false),
      child: widget.canCloseOutsideBounds
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: child,
            )
          : child,
    );
  }
}
