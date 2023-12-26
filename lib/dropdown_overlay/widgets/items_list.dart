part of '../../custom_dropdown.dart';

class _ItemsList<T> extends StatelessWidget {
  final ScrollController scrollController;
  final T? selectedItem;
  final List<T> items;
  final List<T> selectedItems;
  final Function(T) onItemSelect;
  final bool excludeSelected;
  final EdgeInsets itemsListPadding;
  final EdgeInsets listItemPadding;
  final _ListItemBuilder<T> listItemBuilder;
  final ListItemDecoration? decoration;
  final _DropdownType dropdownType;

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
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: decoration?.splashColor ?? Colors.transparent,
              highlightColor: decoration?.highlightColor ?? Colors.grey[200],
              onTap: () => onItemSelect(items[index]),
              child: Ink(
                color: selected
                    ? (decoration?.selectedColor ?? Colors.grey[100])
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
        },
      ),
    );
  }
}
