part of 'custom_dropdown.dart';

const _textFieldIcon = Icon(
  Icons.keyboard_arrow_down_rounded,
  color: Colors.black,
  size: 20,
);

class _DropDownField<T> extends StatefulWidget {
  final TextEditingController controller = TextEditingController();
  final VoidCallback onTap;

  final String hintText;
  final String? errorText;
  final TextStyle? errorStyle;

  //border
  final BoxBorder? border;
  final BorderRadius? borderRadius;

  //error border
  final BorderSide? errorBorderSide;

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
    this.hintText = 'Select value',
    this.hintBuilder,
    this.errorText,
    this.errorStyle,
    this.border,
    this.borderRadius,
    this.errorBorderSide,
    this.fillColor,
  }) : super(key: key);

  @override
  State<_DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<_DropDownField<T>> {
  String? prevText;

  @override
  void initState() {
    super.initState();

    widget.selectedItemNotifier.addListener(() {
      if (widget.selectedItemNotifier.value == null) {
        widget.controller.text = '';
      } else {
        widget.controller.text = widget.selectedItemNotifier.value!.toString();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // default header builder
  Widget _defaultHeaderBuilder(T result) {
    return Text(
      result.toString(),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 16,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // default hint builder
  Widget _defaultHintBuilder(String hint) {
    return Text(
      hint,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFFA7A7A7),
        fontWeight: FontWeight.w400,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*final border = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.borderSide ?? _borderSide,
    );

    final errorBorder = BoxBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.errorBorderSide ?? _errorBorderSide,
    );*/

    //final border = Border.all(color: Colors.transparent);
    //final errorBorder = Border.all(color: Colors.red);

    // overlay icon
    const overlayIcon = Icon(
      Icons.keyboard_arrow_down_rounded,
      color: Colors.black,
      size: 20,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.fillColor ?? _defaultFillColor,
          border: widget.border,
          borderRadius: widget.borderRadius ?? _defaultBorderRadius,
        ),
        child: Padding(
          padding: _headerPadding,
          child: Row(
            children: [
              Expanded(
                child: widget.selectedItemNotifier.value == null
                    ? widget.hintBuilder != null
                        ? widget.hintBuilder!(context, widget.hintText)
                        : _defaultHintBuilder(widget.hintText)
                    : widget.headerBuilder != null
                        ? widget.headerBuilder!(context, widget.selectedItemNotifier.value!)
                        : _defaultHeaderBuilder(widget.selectedItemNotifier.value!),
              ),
              const SizedBox(width: 12),
              overlayIcon,
            ],
          ),
        ),
      ),
    );

/*
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
        hintStyle: defaultHintBuilder(),
        //widget.hintStyle,
        fillColor: widget.fillColor,
        filled: true,
        errorStyle: widget.errorText != null ? widget.errorStyle : _noTextStyle,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );*/
  }
}
