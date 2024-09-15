import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../helpers.dart';

class RunnableUiState<T> extends ChangeNotifier {
  RunnableUiState(this._value);
  T _value;

  T get value => _value;

  set value(T newValue) {
    if (const DeepCollectionEquality().equals(_value, newValue)) return;
    _value = newValue;
    notifyListeners();
  }
}

// typedef LlmRunnableChangeNotifier<T> = Future<void> Function(T change);

typedef RunnableUiHandler = RunnableUi Function(JSON);

abstract class RunnableUi<T> extends StatefulWidget {
  const RunnableUi(
    this.data, {
    super.key,
  });

  final T data;

  Widget build(BuildContext context, RunnableUiState<T> state);

  @override
  State<RunnableUi<T>> createState() => _RunnableUiState<T>();
}

class _RunnableUiState<T> extends State<RunnableUi<T>> {
  late final RunnableUiState<T> _state;

  @override
  void initState() {
    super.initState();
    _state = RunnableUiState(widget.data);
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) => widget.build(context, _state),
    );
  }
}
