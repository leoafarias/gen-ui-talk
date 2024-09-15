import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../helpers.dart';

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

typedef FunctionUiHandler = Widget Function(JSON);

class LlmFunction {
  final LlmFunctionDeclaration function;
  final FunctionCallHandler handler;
  final FunctionUiHandler? uiHandler;
  const LlmFunction({
    required this.function,
    required this.handler,
    this.uiHandler,
  });

  String get name => function.name;

  Widget? render(JSON value) => uiHandler?.call(value);

  Widget uiHandlerDeclaration(dynamic value) {
    return uiHandler!.call(value);
  }

  dynamic handlerDeclaration(Map<String, Object?> args) {
    return handler.call(args);
  }

  FunctionDeclaration get declaration => FunctionDeclaration(
        function.name,
        function.description,
        function.parameters,
      );
}
