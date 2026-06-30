part of '../custom_dropdown.dart';

class SingleSelectController<T> extends ValueNotifier<T?> {
  SingleSelectController(super._value);

  /// Selects [valueToSelect] as the current value.
  void select(T valueToSelect) {
    value = valueToSelect;
  }

  void clear() {
    value = null;
  }

  bool get hasValue => value != null;
}

class MultiSelectController<T> extends ValueNotifier<List<T>> {
  MultiSelectController(super.value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }

  /// Replaces the current selection with [valuesToSelect].
  void select(List<T> valuesToSelect) {
    value = [...valuesToSelect];
  }

  /// Toggles [valueToToggle] — removes it if already selected, otherwise adds.
  void toggle(T valueToToggle) {
    if (value.contains(valueToToggle)) {
      remove(valueToToggle);
    } else {
      add(valueToToggle);
    }
  }

  void clear() {
    value = [];
  }

  bool get hasValues => value.isNotEmpty;
}
