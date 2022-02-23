part of 'custom_dropdown.dart';

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
  final BorderRadius? borderRadius;
  final _SearchType? searchType;
  final Future<List<String>> Function(String)? futureRequest;

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
    this.borderRadius,
    this.searchType,
    this.futureRequest,
  }) : super(key: key);

  @override
  _DropdownOverlayState createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<_DropdownOverlay> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  late String headerText;
  late List<String> items;
  late List<String> filteredItems;
  final key1 = GlobalKey(), key2 = GlobalKey();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
    if (widget.excludeSelected! && widget.controller.text.isNotEmpty) {
      items = widget.items.where((item) => item != headerText).toList();
    } else {
      items = widget.items;
    }
    filteredItems = items;
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // search availability check
    final onSearch = widget.searchType == _SearchType.onListData ||
        widget.searchType == _SearchType.onRequestData;

    // border radius
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);

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
            excludeSelected: widget.excludeSelected!,
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
        : const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'No result found.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );

    return GestureDetector(
      onTap: () => setState(() => displayOverly = false),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              width: widget.size.width + 24,
              child: CompositedTransformFollower(
                link: widget.layerLink,
                followerAnchor: displayOverlayBottom
                    ? Alignment.topLeft
                    : Alignment.bottomLeft,
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
                                    isAlwaysShown: true,
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
                                    if (widget.searchType ==
                                        _SearchType.onListData)
                                      _SearchField.forListData(
                                        items: filteredItems,
                                        onSearchedItems: (val) {
                                          setState(() => items = val);
                                        },
                                      )
                                    else
                                      _SearchField.forRequestData(
                                        futureRequest: widget.futureRequest,
                                        items: filteredItems,
                                        onSearchedItems: (val) {
                                          setState(() => items = val);
                                        },
                                        onFutureRequestLoading: (val) {
                                          setState(
                                            () => isSearchRequestLoading = val,
                                          );
                                        },
                                      ),
                                    if (isSearchRequestLoading)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
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
        ),
      ),
    );
  }
}

class _ItemsList extends StatelessWidget {
  final ScrollController scrollController;
  final List<String> items;
  final bool excludeSelected;
  final String headerText;
  final ValueSetter<String> onItemSelect;
  final EdgeInsets padding;
  final TextStyle? itemTextStyle;

  const _ItemsList({
    Key? key,
    required this.scrollController,
    required this.items,
    required this.excludeSelected,
    required this.headerText,
    required this.onItemSelect,
    required this.padding,
    this.itemTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listItemStyle = const TextStyle(
      fontSize: 16,
    ).merge(itemTextStyle);

    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: padding,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final selected = !excludeSelected && headerText == items[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.grey[200],
              onTap: () => onItemSelect(items[index]),
              child: Container(
                color: selected ? Colors.grey[100] : Colors.transparent,
                padding: _listItemPadding,
                child: Text(
                  items[index],
                  style: listItemStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final List<String> items;
  final ValueChanged<List<String>> onSearchedItems;
  final _SearchType? searchType;
  final Future<List<String>> Function(String)? futureRequest;
  final ValueChanged<bool>? onFutureRequestLoading;

  const _SearchField.forListData({
    Key? key,
    required this.items,
    required this.onSearchedItems,
  })  : searchType = _SearchType.onListData,
        futureRequest = null,
        onFutureRequestLoading = null,
        super(key: key);

  const _SearchField.forRequestData({
    Key? key,
    required this.items,
    required this.onSearchedItems,
    this.futureRequest,
    this.onFutureRequestLoading,
  })  : searchType = _SearchType.onRequestData,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        onChanged: (val) async {
          List<String>? result;
          if (searchType != null && searchType == _SearchType.onRequestData) {
            onFutureRequestLoading!(true);
            try {
              result = await futureRequest!(val);
              onFutureRequestLoading!(false);
            } catch (e) {
              onFutureRequestLoading!(false);
            }
          } else {
            result = items
                .where((item) => item.toLowerCase().contains(val.toLowerCase()))
                .toList();
          }
          onSearchedItems(result ?? []);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[50],
          constraints: const BoxConstraints.tightFor(height: 40),
          contentPadding: const EdgeInsets.all(8),
          hintText: 'Search',
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
