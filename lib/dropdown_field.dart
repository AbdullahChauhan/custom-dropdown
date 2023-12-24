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

  final _DropdownType widgetType;
  final _ValueNotifierList<T> selectedItemsNotifier;

  const _DropDownField({
    super.key,
    required this.onTap,
    required this.selectedItemNotifier,
    required this.maxLines,
    required this.widgetType,
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

  Widget _defaultHeaderBuilder({T? oneItem, List<T>? itemList}) {
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

  Widget _defaultHintBuilder(String hint) {
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
    switch (widget.widgetType) {
      case _DropdownType.singleValue:
        selectedItem = widget.selectedItemNotifier.value;
      case _DropdownType.multiSelect:
        selectedItems = widget.selectedItemsNotifier.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget hintBuilder() => widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText)
        : _defaultHintBuilder(widget.hintText);

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
              child: switch (widget.widgetType) {
                _DropdownType.singleValue => selectedItem != null
                    ? widget.headerBuilder != null
                        ? widget.headerBuilder!(context, selectedItem as T)
                        : _defaultHeaderBuilder(oneItem: selectedItem)
                    : hintBuilder(),
                _DropdownType.multiSelect => selectedItems.isNotEmpty
                    ? widget.headerListBuilder != null
                        ? widget.headerListBuilder!(context, selectedItems)
                        : _defaultHeaderBuilder(itemList: selectedItems)
                    : hintBuilder(),
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
