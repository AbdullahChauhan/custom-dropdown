part of '../../../custom_dropdown.dart';

class _SearchField<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<List<T>> onSearchedItems;
  final String searchHintText;
  final _SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final ValueChanged<bool>? onFutureRequestLoading, mayFoundResult;
  final SearchFieldDecoration? decoration;
  final int minChars;
  final TextAlign? textAlign;

  /// When true, query changes are routed to [onPaginatedQuery] (the overlay
  /// owns the page loading) instead of the one-shot [futureRequest] path.
  final bool paginated;
  final ValueChanged<String>? onPaginatedQuery;

  const _SearchField.forListData({
    super.key,
    required this.items,
    required this.onSearchedItems,
    required this.searchHintText,
    required this.decoration,
    this.textAlign,
  })  : searchType = _SearchType.onListData,
        futureRequest = null,
        futureRequestDelay = null,
        minChars = 0,
        paginated = false,
        onPaginatedQuery = null,
        onFutureRequestLoading = null,
        mayFoundResult = null;

  const _SearchField.forRequestData({
    super.key,
    required this.items,
    required this.onSearchedItems,
    required this.searchHintText,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.onFutureRequestLoading,
    required this.mayFoundResult,
    required this.decoration,
    this.minChars = 0,
    this.textAlign,
    this.paginated = false,
    this.onPaginatedQuery,
  }) : searchType = _SearchType.onRequestData;

  @override
  State<_SearchField<T>> createState() => _SearchFieldState<T>();
}

class _SearchFieldState<T> extends State<_SearchField<T>> {
  final searchCtrl = TextEditingController();
  bool isFieldEmpty = false;
  FocusNode focusNode = FocusNode();
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.searchType == _SearchType.onRequestData &&
        widget.items.isEmpty) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  void onSearch(String query) {
    final result = widget.items.where(
      (item) {
        if (item is CustomDropdownListFilter) {
          return item.filter(query);
        } else {
          return item.toString().toLowerCase().contains(query.toLowerCase());
        }
      },
    ).toList();
    widget.onSearchedItems(result);
  }

  void onClear() {
    if (searchCtrl.text.isNotEmpty) {
      searchCtrl.clear();
      if (widget.paginated) {
        widget.onPaginatedQuery?.call('');
      } else {
        widget.onSearchedItems(widget.items);
      }
    }
  }

  void searchRequest(String val) async {
    List<T> result = [];
    try {
      result = await widget.futureRequest!(val);
      if (!mounted) return;
      widget.onFutureRequestLoading!(false);
    } catch (_) {
      if (!mounted) return;
      widget.onFutureRequestLoading!(false);
    }
    if (!mounted) return;
    widget.onSearchedItems(isFieldEmpty ? widget.items : result);
    widget.mayFoundResult!(result.isNotEmpty);

    if (isFieldEmpty) {
      isFieldEmpty = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        focusNode: focusNode,
        style: widget.decoration?.textStyle,
        textAlign: widget.textAlign ?? TextAlign.start,
        onChanged: (val) async {
          if (val.isEmpty) {
            isFieldEmpty = true;
          } else if (isFieldEmpty) {
            isFieldEmpty = false;
          }

          if (widget.paginated) {
            // Reset to page 1 for the new query (overlay loads the page).
            final query = val.length >= widget.minChars ? val : '';
            _delayTimer?.cancel();
            if (widget.futureRequestDelay != null) {
              _delayTimer = Timer(widget.futureRequestDelay!, () {
                if (mounted) widget.onPaginatedQuery?.call(query);
              });
            } else {
              widget.onPaginatedQuery?.call(query);
            }
            return;
          }

          if (widget.searchType != null &&
              widget.searchType == _SearchType.onRequestData &&
              val.isNotEmpty) {
            // Don't fire the request until the minimum number of characters is
            // reached; show the base items in the meantime.
            if (val.length < widget.minChars) {
              _delayTimer?.cancel();
              widget.onFutureRequestLoading!(false);
              widget.onSearchedItems(widget.items);
              return;
            }

            widget.onFutureRequestLoading!(true);

            if (widget.futureRequestDelay != null) {
              _delayTimer?.cancel();
              _delayTimer =
                  Timer(widget.futureRequestDelay ?? Duration.zero, () {
                searchRequest(val);
              });
            } else {
              searchRequest(val);
            }
          } else if (widget.searchType == _SearchType.onListData) {
            onSearch(val);
          } else {
            widget.onSearchedItems(widget.items);
          }
        },
        controller: searchCtrl,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.decoration?.fillColor ??
              SearchFieldDecoration._defaultFillColor,
          constraints: widget.decoration?.constraints ??
              const BoxConstraints.tightFor(height: 40),
          contentPadding:
              widget.decoration?.contentPadding ?? const EdgeInsets.all(8),
          hintText: widget.searchHintText,
          hintStyle: widget.decoration?.hintStyle,
          prefixIcon: widget.decoration?.prefixIcon ??
              const Icon(Icons.search, size: 22),
          suffixIcon: widget.decoration?.suffixIcon?.call(onClear) ??
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 20),
              ),
          border: widget.decoration?.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(.25),
                  width: 1,
                ),
              ),
          enabledBorder: widget.decoration?.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(.25),
                  width: 1,
                ),
              ),
          focusedBorder: widget.decoration?.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(.25),
                  width: 1,
                ),
              ),
        ),
      ),
    );
  }
}
