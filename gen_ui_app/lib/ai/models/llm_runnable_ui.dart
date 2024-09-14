import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../helpers.dart';
import 'llm_function.dart';

class LlmUiFunction<T> extends LlmFunction {
  final LLmUiRenderer<T> renderer;

  LlmUiFunction(
    LlmFunction function, {
    required this.renderer,
  }) : super(
          name: function.name,
          description: function.description,
          parameters: function.parameters,
          handler: function.handler,
        );
}

extension ListLlmUiFunctionX on List<LlmFunction> {
  Map<String, LLmUiRenderer> toUiRenderers() {
    return Map.fromEntries(
      whereType<LlmUiFunction>().map(
        (e) => MapEntry(e.name, e.renderer),
      ),
    );
  }
}

class LLmUiRenderer<T> {
  final RunnableUiBuilder<T> _builder;
  final RunnableUiParser<T> _parser;
  LLmUiRenderer({
    required RunnableUiBuilder<T> builder,
    required RunnableUiParser<T> parser,
  })  : _parser = parser,
        _builder = builder;

  RunnableUi<T> build(JSON args) => _builder(_parser.decode(args));
}

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

typedef LlmRunnableChangeNotifier<T> = Future<void> Function(T change);

typedef RunnableUiBuilder<T> = RunnableUi<T> Function(
  T value,
);

class RunnableUiParser<T> {
  final T Function(JSON args) _decoder;
  final JSON Function(T value) _encoder;

  const RunnableUiParser({
    required T Function(JSON) decoder,
    required JSON Function(T) encoder,
  })  : _encoder = encoder,
        _decoder = decoder;
  JSON encode(T value) => _encoder(value);
  T decode(JSON args) => _decoder(args);
}

abstract class RunnableUi<T> extends StatefulWidget {
  const RunnableUi({
    super.key,
    required this.value,
  });

  final T value;

  Widget build(BuildContext context, RunnableUiState<T> state);

  @override
  State<RunnableUi> createState() => _RunnableUiState<T>();
}

class _RunnableUiState<T> extends State<RunnableUi<T>> {
  late final RunnableUiState<T> _state;

  @override
  void initState() {
    super.initState();
    _state = RunnableUiState(widget.value);
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(RunnableUi<T> oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.value != oldWidget.value) {
  //     _state.value = widget.value;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) => widget.build(context, _state),
    );
  }
}
