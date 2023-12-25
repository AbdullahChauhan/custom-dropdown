part of 'custom_dropdown.dart';

// overlay icon
const _defaultOverlayIconDown = Icon(
  Icons.keyboard_arrow_down_rounded,
  color: Colors.black,
  size: 20,
);

class _DropDownField<T> extends StatefulWidget {
  final VoidCallback onTap;
  final ValueNotifier<T?> selectedItemNotifier;
  final String hintText;
  final Color? fillColor;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? errorBorderSide;
  final Widget? suffixIcon;
  final int maxLines;
  // ignore: library_private_types_in_public_api
  final _HeaderBuilder<T>? headerBuilder;
  // ignore: library_private_types_in_public_api
  final _HeaderListBuilder<T>? headerListBuilder;
  // ignore: library_private_types_in_public_api
  final _HintBuilder? hintBuilder;
  final _DropdownType dropdownType;
  final _ValueNotifierList<T> selectedItemsNotifier;

  const _DropDownField({
    super.key,
    required this.onTap,
    required this.selectedItemNotifier,
    required this.maxLines,
    required this.dropdownType,
    required this.selectedItemsNotifier,
    this.hintText = 'Select value',
    this.fillColor,
    this.border,
    this.borderRadius,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    this.headerBuilder,
    this.headerListBuilder,
    this.hintBuilder,
    this.suffixIcon,
  });

  @override
  State<_DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<_DropDownField<T>> {
  T? selectedItem;
  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;
  }

  Widget get hintBuilder {
    return widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText)
        : defaultHintBuilder(widget.hintText);
  }

  Widget get headerBuilder {
    return widget.headerBuilder != null
        ? widget.headerBuilder!(context, selectedItem as T)
        : defaultHeaderBuilder(oneItem: selectedItem);
  }

  Widget get headerListBuilder {
    return widget.headerListBuilder != null
        ? widget.headerListBuilder!(context, selectedItems)
        : defaultHeaderBuilder(itemList: selectedItems);
  }

  Widget defaultHeaderBuilder({T? oneItem, List<T>? itemList}) {
    return Text(
      itemList != null ? itemList.join(', ') : oneItem.toString(),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget defaultHintBuilder(String hint) {
    return Text(
      hint,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFFA7A7A7),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _DropDownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    switch (widget.dropdownType) {
      case _DropdownType.singleSelect:
        selectedItem = widget.selectedItemNotifier.value;
      case _DropdownType.multipleSelect:
        selectedItems = widget.selectedItemsNotifier.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: _headerPadding,
        decoration: BoxDecoration(
          color: widget.fillColor ?? _defaultFillColor,
          border: widget.border,
          borderRadius: widget.borderRadius ?? _defaultBorderRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: switch (widget.dropdownType) {
                _DropdownType.singleSelect =>
                  selectedItem != null ? headerBuilder : hintBuilder,
                _DropdownType.multipleSelect =>
                  selectedItems.isNotEmpty ? headerListBuilder : hintBuilder,
              },
            ),
            const SizedBox(width: 12),
            widget.suffixIcon ?? _defaultOverlayIconDown,
          ],
        ),
      ),
    );
  }
}
