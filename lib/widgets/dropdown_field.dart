part of '../custom_dropdown.dart';

// overlay icon
const _defaultOverlayIconDown = Icon(
  Icons.keyboard_arrow_down_rounded,
  size: 20,
);

class _DropDownField<T> extends StatefulWidget {
  final VoidCallback onTap;
  final SingleSelectController<T?> selectedItemNotifier;
  final String hintText;
  final Color? fillColor;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final TextAlign? textAlign;
  final TextStyle? headerStyle, hintStyle;
  final Widget? prefixIcon, suffixIcon;
  final List<BoxShadow>? shadow;
  final EdgeInsets? headerPadding;
  final double? headerHeight;
  final int maxLines;
  final _HeaderBuilder<T>? headerBuilder;
  final _HeaderListBuilder<T>? headerListBuilder;
  final _HintBuilder? hintBuilder;
  final _DropdownType dropdownType;
  final bool enabled;
  final MultiSelectController<T> selectedItemsNotifier;
  final bool canClearSelection;
  final VoidCallback? onClear;
  final String? labelText;
  final TextStyle? labelStyle, floatingLabelStyle;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool isOpen;

  const _DropDownField({
    super.key,
    required this.onTap,
    required this.selectedItemNotifier,
    required this.maxLines,
    required this.dropdownType,
    required this.selectedItemsNotifier,
    this.canClearSelection = false,
    this.onClear,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.isOpen = false,
    this.hintText = 'Select value',
    this.fillColor,
    this.border,
    this.borderRadius,
    this.textAlign,
    this.hintStyle,
    this.headerStyle,
    this.headerBuilder,
    this.shadow,
    this.headerListBuilder,
    this.hintBuilder,
    this.prefixIcon,
    this.suffixIcon,
    this.headerPadding,
    this.headerHeight,
    this.enabled = true,
  });

  @override
  State<_DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<_DropDownField<T>> {
  T? selectedItem;
  late List<T> selectedItems;

  bool get _hasSelection => switch (widget.dropdownType) {
        _DropdownType.singleSelect => selectedItem != null,
        _DropdownType.multipleSelect => selectedItems.isNotEmpty,
      };

  static const _labelAnimDuration = Duration(milliseconds: 200);

  /// Vertical room reserved above the field for the floated label.
  static const _floatGap = 16.0;

  bool get _hasLabel => widget.labelText != null;

  bool get _labelFloated => switch (widget.floatingLabelBehavior) {
        FloatingLabelBehavior.always => true,
        FloatingLabelBehavior.never => false,
        FloatingLabelBehavior.auto => _hasSelection || widget.isOpen,
      };

  /// With [FloatingLabelBehavior.never] the label only acts as a placeholder,
  /// so it is hidden once there is a selection.
  bool get _labelVisible =>
      _hasLabel &&
      !(widget.floatingLabelBehavior == FloatingLabelBehavior.never &&
          _hasSelection);

  Widget _floatingLabel(bool floated) {
    final restingStyle = widget.labelStyle ??
        const TextStyle(fontSize: 16, color: Color(0xFFA7A7A7));
    final floatingStyle = widget.floatingLabelStyle ??
        const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B));
    final start = (widget.headerPadding ?? _defaultHeaderPadding).left;

    // Honor textAlign for the label's horizontal position, so it lines up with
    // the (centered/end-aligned) header and hint.
    final x = switch (widget.textAlign) {
      TextAlign.center => 0.0,
      TextAlign.end || TextAlign.right => 1.0,
      _ => -1.0,
    };

    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedAlign(
          duration: _labelAnimDuration,
          curve: Curves.easeOut,
          alignment: AlignmentDirectional(x, floated ? -1.0 : 0.0),
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: start, end: start),
            child: AnimatedDefaultTextStyle(
              duration: _labelAnimDuration,
              curve: Curves.easeOut,
              style: floated ? floatingStyle : restingStyle,
              child: Text(
                widget.labelText!,
                maxLines: 1,
                textAlign: widget.textAlign,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;
  }

  Widget hintBuilder(BuildContext context) {
    return widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText, widget.enabled)
        : defaultHintBuilder(widget.hintText, widget.enabled);
  }

  Widget headerBuilder(BuildContext context) {
    return widget.headerBuilder != null
        ? widget.headerBuilder!(context, selectedItem as T, widget.enabled)
        : defaultHeaderBuilder(oneItem: selectedItem);
  }

  Widget headerListBuilder(BuildContext context) {
    return widget.headerListBuilder != null
        ? widget.headerListBuilder!(context, selectedItems, widget.enabled)
        : defaultHeaderBuilder(itemList: selectedItems);
  }

  Widget defaultHeaderBuilder({T? oneItem, List<T>? itemList}) {
    return Text(
      itemList != null ? itemList.join(', ') : oneItem.toString(),
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      overflow: TextOverflow.ellipsis,
      style: widget.headerStyle ??
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: widget.enabled ? null : Colors.black.withOpacity(.5),
          ),
    );
  }

  Widget defaultHintBuilder(String hint, bool enabled) {
    return Text(
      hint,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: widget.textAlign,
      style: widget.hintStyle ??
          const TextStyle(
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
    final field = _closedField(context);

    if (!_hasLabel) {
      return GestureDetector(onTap: widget.onTap, child: field);
    }

    final floated = _labelFloated;
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPadding(
            duration: _labelAnimDuration,
            curve: Curves.easeOut,
            padding: EdgeInsets.only(top: floated ? _floatGap : 0),
            child: field,
          ),
          if (_labelVisible) _floatingLabel(floated),
        ],
      ),
    );
  }

  Widget _closedField(BuildContext context) {
    // The floating label, when present and resting, doubles as the placeholder,
    // so the in-field hint is suppressed in that case.
    Widget header() {
      switch (widget.dropdownType) {
        case _DropdownType.singleSelect:
          if (selectedItem != null) return headerBuilder(context);
        case _DropdownType.multipleSelect:
          if (selectedItems.isNotEmpty) return headerListBuilder(context);
      }
      return _hasLabel ? const SizedBox.shrink() : hintBuilder(context);
    }

    return Container(
      height: widget.headerHeight,
      padding: widget.headerPadding ?? _defaultHeaderPadding,
      decoration: BoxDecoration(
        color: widget.fillColor ??
            (widget.enabled
                ? CustomDropdownDecoration._defaultFillColor
                : CustomDropdownDecoration._defaultFillColor.withOpacity(.5)),
        border: widget.border,
        borderRadius: widget.borderRadius ?? _defaultBorderRadius,
        boxShadow: widget.shadow,
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null) ...[
            widget.prefixIcon!,
            const SizedBox(width: 12),
          ],
          Expanded(child: header()),
          const SizedBox(width: 12),
          if (widget.canClearSelection && widget.enabled && _hasSelection)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onClear,
              child: const Icon(Icons.clear_rounded, size: 20),
            )
          else
            widget.suffixIcon ??
                (widget.enabled
                    ? _defaultOverlayIconDown
                    : Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black.withOpacity(.5),
                        size: 20,
                      )),
        ],
      ),
    );
  }
}
