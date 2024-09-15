import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../helpers.dart';
import 'llm_runnable_ui.dart';

class LlmFunctionDeclaration {
  final String name;
  final String description;
  final Schema? parameters;

  const LlmFunctionDeclaration({
    required this.name,
    required this.description,
    this.parameters,
  });
}

typedef FunctionCallHandler = FutureOr<JSON> Function(JSON args);

class LlmFunction {
  final LlmFunctionDeclaration function;
  final FunctionCallHandler handler;
  final RunnableUiHandler? uiHandler;
  const LlmFunction({
    required this.function,
    required this.handler,
    this.uiHandler,
  });

  String get name => function.name;

  RunnableUi? render(JSON value) => uiHandler?.call(value);

  RunnableUi<dynamic> uiHandlerDeclaration(dynamic value) {
    return uiHandler!.call(value);
  }

  dynamic handlerDeclaration(Map<String, Object?> args) {
    return handler.call(args);
  }
}
