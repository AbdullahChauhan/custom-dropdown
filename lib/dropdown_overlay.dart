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
  final Widget? suffixIcon;
  final TextStyle? headerStyle;
  final TextStyle? listItemStyle;
  final bool? excludeSelected;
  final BorderRadius? borderRadius;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.controller,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.suffixIcon,
    required this.hintText,
    this.headerStyle,
    this.listItemStyle,
    this.excludeSelected,
    this.borderRadius,
  }) : super(key: key);

  @override
  _DropdownOverlayState createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<_DropdownOverlay> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  late String headerText;
  late List<String> items;
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
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    // items list
    final list = _ItemsList(
      scrollController: scrollController,
      excludeSelected: widget.excludeSelected!,
      items: items,
      headerText: headerText,
      itemTextStyle: widget.listItemStyle,
      onItemSelect: (value) {
        if (headerText != value) {
          widget.controller.text = value;
        }
        setState(() => displayOverly = false);
      },
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
                          height: items.length > 4 ? 225 : null,
                          child: ClipRRect(
                            borderRadius: borderRadius,
                            child: NotificationListener<
                                OverscrollIndicatorNotification>(
                              onNotification: (notification) {
                                notification.disallowGlow();
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
                                          widget.suffixIcon ?? overlayIcon,
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      indent: 16,
                                      endIndent: 16,
                                      height: 0,
                                      color: Colors.grey[300],
                                    ),
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
  final TextStyle? itemTextStyle;

  const _ItemsList({
    Key? key,
    required this.scrollController,
    required this.items,
    required this.excludeSelected,
    required this.headerText,
    required this.onItemSelect,
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
        padding: EdgeInsets.zero,
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
