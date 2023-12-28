part of '../custom_dropdown.dart';

class _ValueNotifierList<T> extends ValueNotifier<List<T>> {
  _ValueNotifierList(super.value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }
}
