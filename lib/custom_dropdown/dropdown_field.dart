part of 'custom_dropdown.dart';

const _icon = Icon(
  Icons.keyboard_arrow_down_rounded,
  color: Colors.black,
  size: 20,
);

class _DropDownField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final Function(String)? onChanged;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? errorText;
  final TextStyle? errorStyle;
  final InputBorder? border;
  final InputBorder? errorBorder;
  final Widget? suffixIcon;

  const _DropDownField({
    Key? key,
    required this.controller,
    required this.onTap,
    this.onChanged,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.style,
    this.errorText,
    this.errorStyle,
    this.border,
    this.errorBorder,
  }) : super(key: key);

  @override
  State<_DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<_DropDownField> {
  String? prevText;
  bool listenChanges = true;

  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    }
  }

  @override
  void didUpdateWidget(covariant _DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    } else {
      listenChanges = false;
    }
  }

  void listenItemChanges() {
    if (listenChanges) {
      final text = widget.controller.text;
      if (prevText != null && prevText != text && text.isNotEmpty) {
        widget.onChanged!(text);
      }
      prevText = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        );

    final errorBorder = widget.errorBorder ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        );

    return TextFormField(
      controller: widget.controller,
      validator: (val) {
        if (val?.isEmpty ?? false) return widget.errorText ?? '';
      },
      readOnly: true,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      style: widget.style,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 16),
        suffixIcon: widget.suffixIcon ?? _icon,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        fillColor: Colors.white,
        filled: true,
        errorStyle: widget.errorText != null
            ? widget.errorStyle
            : const TextStyle(height: 0),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
