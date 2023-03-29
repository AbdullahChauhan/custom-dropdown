part of '../../custom_dropdown.dart';

class _SearchField extends StatefulWidget {
  final List<String> items;
  final ValueChanged<List<String>> onSearchedItems;
  final _SearchType? searchType;
  final Future<List<String>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final ValueChanged<bool>? onFutureRequestLoading;
  final ValueChanged<bool>? mayFoundResult;

  const _SearchField.forListData({
    Key? key,
    required this.items,
    required this.onSearchedItems,
  })  : searchType = _SearchType.onListData,
        futureRequest = null,
        futureRequestDelay = null,
        onFutureRequestLoading = null,
        mayFoundResult = null,
        super(key: key);

  const _SearchField.forRequestData({
    Key? key,
    required this.items,
    required this.onSearchedItems,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.onFutureRequestLoading,
    required this.mayFoundResult,
  })  : searchType = _SearchType.onRequestData,
        super(key: key);

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
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

  void onSearch(String str) {
    final result = widget.items
        .where((item) => item.toLowerCase().contains(str.toLowerCase()))
        .toList();
    widget.onSearchedItems(result);
  }

  void onClear() {
    if (searchCtrl.text.isNotEmpty) {
      searchCtrl.clear();
      widget.onSearchedItems(widget.items);
    }
  }

  void searchRequest(String val) async {
    List<String> result = [];
    try {
      result = await widget.futureRequest!(val);
      widget.onFutureRequestLoading!(false);
    } catch (_) {
      widget.onFutureRequestLoading!(false);
    }
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
        onChanged: (val) async {
          if (val.isEmpty) {
            isFieldEmpty = true;
          } else if (isFieldEmpty) {
            isFieldEmpty = false;
          }

          if (widget.searchType != null &&
              widget.searchType == _SearchType.onRequestData &&
              val.isNotEmpty) {
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
          fillColor: Colors.grey[50],
          constraints: const BoxConstraints.tightFor(height: 40),
          contentPadding: const EdgeInsets.all(8),
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 22),
          suffixIcon: GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, color: Colors.grey, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
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
