# 4.0.0

A big release: a new overlay **animation system**, **infinite-scroll pagination**, a stack of new customization options, and fixes that sweep most of the open-issue backlog. All additions are backward-compatible.

## ✨ New features

- **Overlay animations** — configure the open/close transition via the new `animation` parameter (`CustomDropdownAnimation`):
  - Built-in transitions: `size`, `fade`, `sizeFade` (default), `scale`, `scaleFade`, `slide` — direction-aware (open up/down).
  - Tune `duration`, `reverseDuration`, `curve`, `reverseCurve`; smoother defaults (`easeOutCubic` open / `easeInCubic` close).
  - `CustomDropdownAnimation.none` to disable, or a `builder` escape hatch for any custom transition.
  - Optional **staggered list-item entrance** via `staggerItems` (tune with `itemStagger` / `itemDuration`).
  - The dropdown arrow now rotates (down ↔ up) in sync with open/close.
- **Infinite scroll / pagination** for the search-request constructors — new `paginatedRequest: (query, page) => …`:
  - Loads page 1 on open/search and appends the next page as you scroll near the bottom, stopping once a page returns fewer than `pageSize` items (default `20`).
  - Optional `loadMoreIndicator` footer. Provide exactly one of `futureRequest` / `paginatedRequest`.
- Material-style floating label — `labelText` (String) or a fully custom `label` (Widget), with `CustomDropdownDecoration.labelStyle` / `floatingLabelStyle` / `floatingLabelBehavior` / `floatingLabelGap` (spacing between the floated label and the field) ([#111](https://github.com/AbdullahChauhan/custom-dropdown/issues/111)).
- `textAlign` for the header, hint, list items, search input, "no result found" text and the floating label ([#71](https://github.com/AbdullahChauhan/custom-dropdown/issues/71); thanks [@hamhoney](https://github.com/hamhoney) for [PR #90](https://github.com/AbdullahChauhan/custom-dropdown/pull/90)).
- `canClearSelection` — a clear button to reset back to the empty/hint state ([#106](https://github.com/AbdullahChauhan/custom-dropdown/issues/106), [#83](https://github.com/AbdullahChauhan/custom-dropdown/issues/83)).
- `searchRequestMinChars` — don't fire the request until at least N characters are typed ([#107](https://github.com/AbdullahChauhan/custom-dropdown/issues/107)).
- `selectOnItemTap` — let a custom `listItemBuilder` own item selection ([#80](https://github.com/AbdullahChauhan/custom-dropdown/issues/80); inspired by [PR #108](https://github.com/AbdullahChauhan/custom-dropdown/pull/108) from [@Giovanny-DS](https://github.com/Giovanny-DS)).
- `overlayDirection` (`auto` / `below` / `above`) to force the side the overlay opens towards ([#92](https://github.com/AbdullahChauhan/custom-dropdown/issues/92)).
- `initiallyOpen` to open the overlay automatically on first build ([#87](https://github.com/AbdullahChauhan/custom-dropdown/issues/87)).
- `autofocusOnSearch` to focus the search field (raising the keyboard) when the overlay opens ([#70](https://github.com/AbdullahChauhan/custom-dropdown/issues/70)).
- Controller selection helpers: `SingleSelectController.select()`, `MultiSelectController.select()` and `MultiSelectController.toggle()` ([#100](https://github.com/AbdullahChauhan/custom-dropdown/issues/100)).
- `CustomDropdownDecoration.closedHeaderHeight` for a fixed, vertically-centered closed-field height ([#105](https://github.com/AbdullahChauhan/custom-dropdown/issues/105)).

## 💅 Improvements

- The default closed error border now follows `errorStyle.color`, so the border and error text match without setting `closedErrorBorder` explicitly ([#105](https://github.com/AbdullahChauhan/custom-dropdown/issues/105)).
- Search a list of custom class instances out of the box — search matches each item's `toString()`; use the `CustomDropdownListFilter` mixin for complex filtering ([#103](https://github.com/AbdullahChauhan/custom-dropdown/issues/103)).

## 🐛 Fixes

- Overlay hidden behind the on-screen keyboard while searching ([#116](https://github.com/AbdullahChauhan/custom-dropdown/issues/116), [#113](https://github.com/AbdullahChauhan/custom-dropdown/issues/113), [#51](https://github.com/AbdullahChauhan/custom-dropdown/issues/51)):
  - Flips above the field using the live keyboard inset, recalculates on keyboard show/hide (`didChangeMetrics`), keeps the dropdown alive (`AutomaticKeepAliveClientMixin`) and scrolls its field back into view — so the overlay no longer disappears when the field sits in a scrollable that resizes for the keyboard.
- Double border, opaque/gray background, extra side padding and bottom underline when an `inputDecorationTheme` is set (Flutter 3.35+), including the gray background shown on validation error ([#115](https://github.com/AbdullahChauhan/custom-dropdown/issues/115), [#117](https://github.com/AbdullahChauhan/custom-dropdown/issues/117), [#110](https://github.com/AbdullahChauhan/custom-dropdown/issues/110), [#68](https://github.com/AbdullahChauhan/custom-dropdown/issues/68), [#86](https://github.com/AbdullahChauhan/custom-dropdown/issues/86), [#84](https://github.com/AbdullahChauhan/custom-dropdown/issues/84), [#97](https://github.com/AbdullahChauhan/custom-dropdown/issues/97); also raised in [PR #94](https://github.com/AbdullahChauhan/custom-dropdown/pull/94) by [@mreslamgeek](https://github.com/mreslamgeek)):
  - The field's internal `InputDecorator` no longer inherits the ambient `inputDecorationTheme`; it only surfaces the form validation error text.
- `overlayController` ignored when a different controller instance is supplied on rebuild ([#114](https://github.com/AbdullahChauhan/custom-dropdown/issues/114)) — the overlay now re-binds to the latest controller.
- `SchedulerPhase` assertion on dismiss, and a stale-callback crash when a search request completes after the field is disposed ([#96](https://github.com/AbdullahChauhan/custom-dropdown/issues/96), [#101](https://github.com/AbdullahChauhan/custom-dropdown/issues/101); thanks [@antoniomtnez](https://github.com/antoniomtnez) for [PR #109](https://github.com/AbdullahChauhan/custom-dropdown/pull/109)).
- `multiSelectSearchRequest` reliably shows "No result found" after an empty search result ([#112](https://github.com/AbdullahChauhan/custom-dropdown/issues/112)).
- Selecting/deselecting no longer mutates a caller's unmodifiable `items`/`initialItems` list ([#62](https://github.com/AbdullahChauhan/custom-dropdown/issues/62)).

## 🙌 Thanks

Thanks to [@hamhoney](https://github.com/hamhoney) ([#90](https://github.com/AbdullahChauhan/custom-dropdown/pull/90)), [@antoniomtnez](https://github.com/antoniomtnez) ([#109](https://github.com/AbdullahChauhan/custom-dropdown/pull/109)), [@Giovanny-DS](https://github.com/Giovanny-DS) ([#108](https://github.com/AbdullahChauhan/custom-dropdown/pull/108)) and [@mreslamgeek](https://github.com/mreslamgeek) ([#94](https://github.com/AbdullahChauhan/custom-dropdown/pull/94)) for PRs and reports.

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
</content>
</invoke>
