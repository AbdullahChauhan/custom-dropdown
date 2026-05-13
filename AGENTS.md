# AGENTS.md

## Project overview

Flutter package: `animated_custom_dropdown` (v3.1.1). A highly customizable animated dropdown widget with single-select, multi-select, search, search-request, and form validation variants.

## Structure

- `lib/custom_dropdown.dart` — sole entrypoint; uses `part` directives (not `export`), all implementation lives in `part` files under `lib/models/`, `lib/utils/`, `lib/widgets/`
- `example/` — standalone Flutter app depending on the package via `path: ../`

**Important:** Because the library uses `part`/`part of`, all `part` files share the same library scope. Private members in `part` files are visible across the entire library, not isolated to their file.

## Commands

```bash
flutter analyze          # static analysis (uses flutter_lints + analysis_options.yaml)
flutter test             # runs tests (no test/ directory exists yet at root)
cd example && flutter test  # run example app tests, if any
```

There are no CI workflows and no test suite in the package root.

## Lint config

`analysis_options.yaml` extends `package:flutter_lints/flutter.yaml` with one override:
- `library_private_types_in_public_api: false` — explicitly disabled

## Key API constraints

- `CustomDropdown<T>` has 6 named constructors: `.search()`, `.searchRequest()`, `.multiSelect()`, `.multiSelectSearch()`, `.multiSelectSearchRequest()`
- Custom types used as `T` **must** override `toString()` to display correctly in the dropdown list
- For search constructors, custom types can mix in `CustomDropdownListFilter` to provide `filter(query)` logic
- `initialItem` and `controller` are mutually exclusive (assert-enforced); same for `initialItems` and `multiSelectController`
- Controllers (`SingleSelectController<T?>`, `MultiSelectController<T>`) are optional — when not provided, internal ones are created and disposed automatically