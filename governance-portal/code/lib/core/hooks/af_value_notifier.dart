import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/foundation.dart';

AfValueNotifier<T> useAfValueNotifier<T>(T initialData) {
  return use(_StateHook(initialData: initialData));
}

class _StateHook<T> extends Hook<AfValueNotifier<T>> {
  const _StateHook({required this.initialData});

  final T initialData;

  @override
  _StateHookState<T> createState() => _StateHookState();
}

class _StateHookState<T> extends HookState<AfValueNotifier<T>, _StateHook<T>> {
  late final _state = AfValueNotifier<T>(hook.initialData);
  // ..addListener(_listener);

  @override
  void dispose() {
    _state.dispose();
  }

  @override
  AfValueNotifier<T> build(BuildContext context) => _state;

  // void _listener() {
  //   setState(() {});
  // }

  @override
  Object? get debugValue => _state.value;

  @override
  String get debugLabel => 'useAfValueNotifier<$T>';
}

class AfValueNotifier<T> extends ValueNotifier<T> {
  // 1. Custom Flag to track disposal state
  bool _isDisposed = false;

  // 2. Public getter to check the state
  bool get isDisposed => _isDisposed;

  AfValueNotifier(super.value);

  // 3. Override dispose() to set the flag
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // 4. Override the value setter to check the flag before notifying
  @override
  set value(T newValue) {
    if (_isDisposed) {
      // Optional: Log a warning instead of crashing
      if (kDebugMode) {
        print('Warning: Attempted to set value on a disposed ValueNotifier.');
      }
      return; // Prevent crash
    }
    super.value = newValue;
  }
}
