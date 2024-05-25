part of '../custom_dropdown.dart';

class SingleSelectController<T> extends ValueNotifier<T?> {
  SingleSelectController(super.value);

  void clear() {
    value = null;
  }
}

class MultiSelectController<T> extends ValueNotifier<List<T>> {
  MultiSelectController(super.value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }

  void clear() {
    value = [];
  }
}
