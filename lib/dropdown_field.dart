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
  final int maxlines;

  // ignore: library_private_types_in_public_api
  final _HeaderBuilder<T>? headerBuilder;
  // ignore: library_private_types_in_public_api
  final _HintBuilder? hintBuilder;

  const _DropDownField({
    Key? key,
    required this.onTap,
    required this.selectedItemNotifier,
    required this.maxlines,
    this.hintText = 'Select value',
    this.fillColor,
    this.border,
    this.borderRadius,
    this.errorText,
    this.errorStyle,
    this.errorBorderSide,
    this.headerBuilder,
    this.hintBuilder,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<_DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<_DropDownField<T>> {
  T? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItemNotifier.value;
  }

  Widget _defaultHeaderBuilder(T result) {
    return Text(
      result.toString(),
      maxLines: widget.maxlines,
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
    selectedItem = widget.selectedItemNotifier.value;
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
              child: selectedItem != null
                  ? widget.headerBuilder != null
                      ? widget.headerBuilder!(context, selectedItem as T)
                      : _defaultHeaderBuilder(selectedItem as T)
                  : widget.hintBuilder != null
                      ? widget.hintBuilder!(context, widget.hintText)
                      : _defaultHintBuilder(widget.hintText),
            ),
            const SizedBox(width: 12),
            widget.suffixIcon ?? _defaultOverlayIconDown,
          ],
        ),
      ),
    );
  }
}
