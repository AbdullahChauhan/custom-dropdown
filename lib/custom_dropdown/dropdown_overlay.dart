part of 'custom_dropdown.dart';

class _DropdownOverlay<T> extends StatefulWidget {
  final List<T> items;
  final Size size;
  final LayerLink layerLink;
  final VoidCallback hideOverlay;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextStyle? headerStyle;
  final TextStyle? listItemStyle;

  final String? hintText;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.controller,
    required this.suffixIcon,
    this.hintText,
    this.headerStyle,
    this.listItemStyle,
  }) : super(key: key);

  @override
  _DropdownOverlayState createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<_DropdownOverlay> {
  bool displayOverly = true;
  late String headerText;
  late List<dynamic> items;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    headerText = widget.controller.text;
    items = widget.items.where((element) => element != headerText).toList();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listItemStyle = const TextStyle(
      fontSize: 16,
    ).merge(widget.listItemStyle);

    final scrollableChild = Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (_, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.grey[100],
              onTap: () {
                if (headerText != items[index]) {
                  widget.controller.text = items[index];
                }
                setState(() => displayOverly = false);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
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
                showWhenUnlinked: false,
                offset: const Offset(-12, 0),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                    left: 12,
                    right: 12,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24.0,
                          color: Colors.black.withOpacity(.08),
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedSection(
                        animationDismissed: widget.hideOverlay,
                        expand: displayOverly,
                        child: SizedBox(
                          height: items.length > 4 ? 200 : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
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
                                    thickness: MaterialStateProperty.all(3.25),
                                    radius: const Radius.circular(8),
                                    thumbColor: MaterialStateProperty.all(
                                      Colors.grey[350],
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 16,
                                        bottom: 16,
                                        right: 14,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              headerText.isNotEmpty
                                                  ? headerText
                                                  : '${widget.hintText}',
                                              style: widget.headerStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          widget.suffixIcon ??
                                              const Icon(
                                                Icons.keyboard_arrow_up_rounded,
                                                color: Colors.black,
                                                size: 20,
                                              ),
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
                                        ? Expanded(child: scrollableChild)
                                        : scrollableChild
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
