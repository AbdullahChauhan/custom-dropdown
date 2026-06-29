# 4.0.0

- Fix: Dropdown overlay hidden behind the on-screen keyboard while searching ([#116](https://github.com/AbdullahChauhan/custom-dropdown/issues/116), [#113](https://github.com/AbdullahChauhan/custom-dropdown/issues/113))
  - The overlay now flips above the field when the keyboard would cover it, using the live keyboard inset instead of the full screen height.
  - Position is recalculated whenever the keyboard shows/hides (via `WidgetsBindingObserver.didChangeMetrics`).
  - The dropdown is kept alive while open (`AutomaticKeepAliveClientMixin`) and its field is scrolled back into view, so the overlay no longer disappears when the field sits in a scrollable that resizes for the keyboard.
- Fix: Double border, opaque background and extra side padding when an `inputDecorationTheme` is set (Flutter 3.35+) ([#115](https://github.com/AbdullahChauhan/custom-dropdown/issues/115), [#117](https://github.com/AbdullahChauhan/custom-dropdown/issues/117), [#110](https://github.com/AbdullahChauhan/custom-dropdown/issues/110))
  - The field's internal `InputDecorator` no longer inherits the ambient `inputDecorationTheme`; it only surfaces the form validation error text.
- Fix: `overlayController` ignored when a different controller instance is supplied on rebuild ([#114](https://github.com/AbdullahChauhan/custom-dropdown/issues/114))
  - The overlay now re-binds to the latest `overlayController`, so external `show()`/`hide()` keep working and tapping the field still opens the dropdown.
- Add: `searchRequestMinChars` for the search-request constructors ([#107](https://github.com/AbdullahChauhan/custom-dropdown/issues/107))
  - The `futureRequest` is not triggered until at least this many characters are typed; the base items are shown below the threshold. Defaults to `0`.
- Add: `canClearSelection` to reset the dropdown back to the empty/hint state ([#106](https://github.com/AbdullahChauhan/custom-dropdown/issues/106))
  - Shows a clear button on the closed field while there is a selection. Single-select resets to `null`; multi-select clears all items. Defaults to `false`.
- Add: `CustomDropdownDecoration.closedHeaderHeight` to set a fixed closed-field height (content centered) ([#105](https://github.com/AbdullahChauhan/custom-dropdown/issues/105)).
- Improve: the default closed error border now follows `errorStyle.color`, so the error border and error text match without setting `closedErrorBorder` explicitly ([#105](https://github.com/AbdullahChauhan/custom-dropdown/issues/105)).
- Add: optional Material-style floating `labelText` ([#111](https://github.com/AbdullahChauhan/custom-dropdown/issues/111))
  - Rests as the placeholder and floats up when the dropdown has a value or is open. Configurable via `CustomDropdownDecoration.labelStyle`, `floatingLabelStyle` and `floatingLabelBehavior`.

# 3.1.1

- Fix: onChanged not invoked after first invocation (Thanks [@ravindrabarthwal for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/76))

# 3.1.0

- Add: Controllers support (Thanks [@hbatalhaStch for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/66))
  - `SingleSelectController`
  - `MultiSelectController`
- Add: Enabled/Disabled state support (Thanks [@KabaDH for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/55))
- Add: Dropdown disabled state decoration support
  - `CustomDropdownDisabledDecoration`
- Add: Items list scroll controller support
  - `itemsScrollController`
- Add: Dropdown overlay controller support
  - `overlayController`
- Add: Dropdown visibility status callback
  - `visibility`
- Update: Enhance decoration support
  - `prefixIcon`
- Remove: Empty items list assertion (Thanks [@hbatalhaStch for the issue](https://github.com/AbdullahChauhan/custom-dropdown/issues/64))

# 3.0.0

- Add: Multi selection support (Thanks [@KabaDH for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/40))
  - `CustomDropdown.multiSelect`
  - `CustomDropdown.multiSelectSearch`
  - `CustomDropdown.multiSelectSearchRequest`
- Add: Decoration support
  - `CustomDropdownDecoration`
    - `SearchFieldDecoration`
    - `ListItemDecoration`
    - `ScrollbarThemeData`
- Add: Dropdown overlay height support (Thanks [@aguilastorm for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/38))
  - `overlayHeight`
- Add: Custom loading widget for search request
  - `searchRequestLoadingIndicator`
- Add: Padding properties:
  - `closedHeaderPadding`
  - `expandedHeaderPadding`
  - `itemsListPadding`
  - `listItemPadding`
- Fix: Stop the scrolling and dropdown should remains in expanded state (Thanks [@s-saens for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/34))
- Breaking: Properties move inside decoration:
  - `closedFillColor`
  - `expandedFillColor`
  - `errorStyle`
  - `closedBorder`
  - `closedBorderRadius`
  - `expandedBorder`
  - `expandedBorderRadius`
  - `closedErrorBorder`
  - `closedErrorBorderRadius`
  - `closedSuffixIcon`
  - `expandedSuffixIcon`

# 2.0.0

- Add: Migration to support List of generatic type `T` (Thanks [@JesusHdez960717 for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/20))
- Add: Mixin `CustomDropdownListFilter` for complex filter on search field
- Add: Builders support
  - `listItemBuilder`
  - `headerBuilder`
  - `hintBuilder`
  - `noResultFoundBuilder`
- Add: `validator` & `validateOnChange` to enhance form validation support
- Add: Other new properties:
  - `initialItem`
  - `searchHintText`
  - `expandedBorder`
  - `expandedBorderRadius`
  - `errorBorderRadius`
  - `hideSelectedFieldWhenExpanded`
  - `noResultFoundText`
  - `expandedFillColor`
  - `expandedSuffixIcon`
  - `maxlines`
- Breaking: Clean `controller` support
- Breaking: Clean `listItemStyle` support
- Breaking: Clean `selectedStyle` support
- Breaking: Clean `errorText` support
- Breaking: `fillColor` change to `closedFillColor`
- Breaking: `fieldSuffixIcon` change to `closedSuffixIcon`
- Breaking: `errorBorderSide` change to `errorBorder`
- Breaking: `borderSide` change to `closedBorder`
- Breaking: `borderRadius` change to `closedBorderRadius`
- Refactor: Overlay rendering approach (change to declarative)

# 1.5.0

- Add: Request delay support for Search request API (Thanks [@JesusHdez960717 for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/19))

# 1.4.0

- Add: Search request API (Search on provided request)
- Update readme.

# 1.3.0

- Update: Flutter version 3.3.9 changes
- Add: List item builder support (Thanks [@Mohamed25885 for PR](https://github.com/AbdullahChauhan/custom-dropdown/pull/14))

# 1.2.2

- Update: Flutter version 3.0.1 changes

# 1.2.1

- Fix: State dispose calls

# 1.2.0

- Add: Search field (Search on list data)
- Fix: State mounted check on dropdown open or close.
- Update readme.

# 1.1.1

- Update: Suffix icon only allowed for dropdown field.
- Fix: Empty list pass (assert added).

# 1.1.0

- Add: Dropdown overlay alignments (top, bottom) according to available screen space.
- Update readme.

# 1.0.1

- Update readme, project description. Format files.

# 1.0.0

- Customizable animated dropdown widget.
