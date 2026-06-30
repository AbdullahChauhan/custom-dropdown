part of '../../../custom_dropdown.dart';

class _ItemsList<T> extends StatelessWidget {
  final ScrollController scrollController;
  final T? selectedItem;
  final List<T> items, selectedItems;
  final Function(T) onItemSelect;
  final bool excludeSelected;
  final EdgeInsets itemsListPadding, listItemPadding;
  final _ListItemBuilder<T> listItemBuilder;
  final ListItemDecoration? decoration;
  final _DropdownType dropdownType;
  final bool selectOnItemTap;
  final CustomDropdownAnimation animation;

  const _ItemsList({
    super.key,
    required this.scrollController,
    required this.selectedItem,
    required this.items,
    required this.onItemSelect,
    required this.excludeSelected,
    required this.itemsListPadding,
    required this.listItemPadding,
    required this.listItemBuilder,
    required this.selectedItems,
    required this.decoration,
    required this.dropdownType,
    required this.selectOnItemTap,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: itemsListPadding,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final selected = switch (dropdownType) {
            _DropdownType.singleSelect =>
              !excludeSelected && selectedItem == items[index],
            _DropdownType.multipleSelect => selectedItems.contains(items[index])
          };
          final Widget item = Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: decoration?.splashColor ??
                  ListItemDecoration._defaultSplashColor,
              highlightColor: decoration?.highlightColor ??
                  ListItemDecoration._defaultHighlightColor,
              onTap: selectOnItemTap ? () => onItemSelect(items[index]) : null,
              child: Ink(
                color: selected
                    ? (decoration?.selectedColor ??
                        ListItemDecoration._defaultSelectedColor)
                    : Colors.transparent,
                padding: listItemPadding,
                child: listItemBuilder(
                  context,
                  items[index],
                  selected,
                  () => onItemSelect(items[index]),
                ),
              ),
            ),
          );

          if (!animation.enabled || !animation.staggerItems) return item;

          return _StaggeredItem(
            index: index,
            duration: animation.itemDuration,
            stagger: animation.itemStagger,
            curve: animation.curve,
            child: item,
          );
        },
      ),
    );
  }
}

/// Plays a one-shot fade + slide-up entrance for a list item, delayed by its
/// position so the list cascades in when the overlay opens.
class _StaggeredItem extends StatefulWidget {
  final int index;
  final Duration duration, stagger;
  final Curve curve;
  final Widget child;

  const _StaggeredItem({
    required this.index,
    required this.duration,
    required this.stagger,
    required this.curve,
    required this.child,
  });

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: widget.curve);
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    // Cap the per-item delay so long lists don't take forever to appear.
    final steps = widget.index > 12 ? 12 : widget.index;
    _startTimer = Timer(widget.stagger * steps, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.18),
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}
