part of '../../custom_dropdown.dart';

class _ItemsList<T> extends StatelessWidget {
  final ScrollController scrollController;
  final T? selectedItem;
  final List<T> items;
  final List<T> selectedItems;
  final Function(T) onItemSelect;
  final bool excludeSelected;
  final EdgeInsets padding;
  // ignore: library_private_types_in_public_api
  final _ListItemBuilder<T> listItemBuilder;
  final _DropdownType dropdownType;

  const _ItemsList({
    super.key,
    required this.scrollController,
    required this.selectedItem,
    required this.items,
    required this.onItemSelect,
    required this.excludeSelected,
    required this.padding,
    required this.listItemBuilder,
    required this.selectedItems,
    required this.dropdownType,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: padding,
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
              splashColor: Colors.transparent,
              highlightColor: Colors.grey[200],
              onTap: () => onItemSelect(items[index]),
              child: Ink(
                color: selected ? Colors.grey[100] : Colors.transparent,
                padding: _listItemPadding,
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
