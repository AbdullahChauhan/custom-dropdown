part of '../custom_dropdown.dart';

const _headerPadding = EdgeInsets.only(
  left: 16.0,
  top: 16,
  bottom: 16,
  right: 14,
);
const _overlayOuterPadding = EdgeInsets.only(bottom: 12, left: 12, right: 12);
const _overlayShadowOffset = Offset(0, 6);
const _listItemPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 16);

class _DropdownOverlay extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final Size size;
  final LayerLink layerLink;
  final VoidCallback hideOverlay;
  final String hintText;
  final TextStyle? headerStyle;
  final TextStyle? listItemStyle;
  final bool? excludeSelected;
  final bool? hideSelectedFieldWhenOpen;
  final bool? canCloseOutsideBounds;
  final _SearchType? searchType;
  final Future<List<String>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;

  final _ListItemBuilder? listItemBuilder;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.controller,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.hintText,
    this.headerStyle,
    this.listItemStyle,
    this.excludeSelected,
    this.canCloseOutsideBounds,
    this.hideSelectedFieldWhenOpen = false,
    this.searchType,
    this.futureRequest,
    this.futureRequestDelay,
    this.listItemBuilder,
  }) : super(key: key);

  @override
  _DropdownOverlayState createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<_DropdownOverlay> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  bool? mayFoundSearchRequestResult;

  late String headerText;
  late List<String> items;
  late List<String> filteredItems;
  final key1 = GlobalKey(), key2 = GlobalKey();
  final scrollController = ScrollController();

  // default list item builder
  Widget defaultListItemBuilder(BuildContext context, String result) {
    return Text(
      result,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
      ).merge(widget.listItemStyle),
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

    headerText = widget.controller.text;
    if (widget.excludeSelected! &&
        widget.items.length > 1 &&
        widget.controller.text.isNotEmpty) {
      items = widget.items.where((item) => item != headerText).toList();
    } else {
      items = widget.items;
    }
    filteredItems = items;
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

    // border radius
    final borderRadius = BorderRadius.circular(12);

    // overlay icon
    final overlayIcon = Icon(
      displayOverlayBottom
          ? Icons.keyboard_arrow_up_rounded
          : Icons.keyboard_arrow_down_rounded,
      color: Colors.black,
      size: 20,
    );

    // overlay offset
    final overlayOffset = Offset(-12, displayOverlayBottom ? 0 : 60);

    // list padding
    final listPadding =
        onSearch ? const EdgeInsets.only(top: 8) : EdgeInsets.zero;

    // items list
    final list = items.isNotEmpty
        ? _ItemsList(
            scrollController: scrollController,
            listItemBuilder: widget.listItemBuilder ?? defaultListItemBuilder,
            excludeSelected:
                widget.items.length > 1 ? widget.excludeSelected! : false,
            items: items,
            padding: listPadding,
            headerText: headerText,
            itemTextStyle: widget.listItemStyle,
            onItemSelect: (value) {
              if (headerText != value) {
                widget.controller.text = value;
              }
              setState(() => displayOverly = false);
            },
          )
        : (mayFoundSearchRequestResult != null &&
                    !mayFoundSearchRequestResult!) ||
                widget.searchType == _SearchType.onListData
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'No result found.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
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
                  color: Colors.white,
                  borderRadius: borderRadius,
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
                        borderRadius: borderRadius,
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
                                          child: Text(
                                            headerText.isNotEmpty
                                                ? headerText
                                                : widget.hintText,
                                            style: widget.headerStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        overlayIcon,
                                      ],
                                    ),
                                  ),
                                if (onSearch &&
                                    widget.searchType == _SearchType.onListData)
                                  if (!widget.hideSelectedFieldWhenOpen!)
                                    _SearchField.forListData(
                                      items: filteredItems,
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
                                            child: _SearchField.forListData(
                                              items: filteredItems,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                            ),
                                          ),
                                          overlayIcon,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    )
                                else if (onSearch &&
                                    widget.searchType ==
                                        _SearchType.onRequestData)
                                  if (!widget.hideSelectedFieldWhenOpen!)
                                    _SearchField.forRequestData(
                                      items: filteredItems,
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
                                            child: _SearchField.forRequestData(
                                              items: filteredItems,
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
                                          overlayIcon,
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
      child: widget.canCloseOutsideBounds!
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
