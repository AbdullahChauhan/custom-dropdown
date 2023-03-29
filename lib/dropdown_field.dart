part of 'custom_dropdown.dart';

const _textFieldIcon = Icon(
  Icons.keyboard_arrow_down_rounded,
  color: Colors.black,
  size: 20,
);
const _contentPadding = EdgeInsets.only(left: 16);
const _noTextStyle = TextStyle(height: 0);
const _borderSide = BorderSide(color: Colors.transparent);
const _errorBorderSide = BorderSide(color: Colors.redAccent, width: 2);

class _DropDownField<T> extends StatefulWidget {
  final TextEditingController controller = TextEditingController();
  final VoidCallback onTap;

  final String? hintText;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;
  final Color? fillColor;

  ValueNotifier<T?> selectedItemNotifier;
  final Widget Function(BuildContext context, T result)? headerBuilder;
  final Widget Function(BuildContext context, String hint)? hintBuilder;

  _DropDownField({
    Key? key,
    required this.onTap,
    required this.selectedItemNotifier,
    this.headerBuilder,
    this.suffixIcon,
    this.hintText,
    this.hintBuilder,
    this.errorText,
    this.errorStyle,
    this.borderSide,
    this.errorBorderSide,
    this.borderRadius,
    this.fillColor,
  }) : super(key: key);

  @override
  State<_DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<_DropDownField<T>> {
  String? prevText;
  bool listenChanges = true;

  @override
  void initState() {
    super.initState();

    widget.selectedItemNotifier.addListener(() {
      if (widget.selectedItemNotifier.value == null) {
        widget.controller.text = '';
      } else {
        widget.controller.text = widget.selectedItemNotifier.value!.toString();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // default list item builder
  Widget defaultListItemBuilder(BuildContext context, T result) {
    return Text(
      result.toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  // default header builder
  Widget defaultHeaderBuilder(BuildContext context, T result) {
    return Text(
      result.toString(),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 16,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.borderSide ?? _borderSide,
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.errorBorderSide ?? _errorBorderSide,
    );

    return TextFormField(
      controller: widget.controller,
      validator: (val) {
        if (val?.isEmpty ?? false) return widget.errorText ?? '';
        return null;
      },
      readOnly: true,
      onTap: widget.onTap,
      //style: widget.style,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: _contentPadding,
        suffixIcon: widget.suffixIcon ?? _textFieldIcon,
        hintText: widget.hintText,
        //hintStyle: widget.hintStyle,
        fillColor: widget.fillColor,
        filled: true,
        errorStyle: widget.errorText != null ? widget.errorStyle : _noTextStyle,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
