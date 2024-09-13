import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

class LlmFunction {
  final String name;
  final String description;
  final Schema? parameters;
  final FunctionCallHandler handler;
  static Map<String, Object?> _defaultHandler(Map<String, Object?> args) =>
      args;
  const LlmFunction({
    required this.name,
    required this.description,
    this.parameters,
    FunctionCallHandler? handler,
  }) : handler = handler ?? _defaultHandler;

  FunctionDeclaration get declaration => FunctionDeclaration(
        name,
        description,
        parameters,
      );
}

typedef FunctionCallHandler = FutureOr<Map<String, Object?>> Function(
    Map<String, Object?> args);

extension ListLlmFunctionX on List<LlmFunction> {
  List<Tool> toTools() {
    return map((e) => Tool(functionDeclarations: [e.declaration])).toList();
  }

  Map<String, FunctionCallHandler> toFunctionHandlers() {
    return {
      for (final e in this) e.name: e.handler,
    };
  }

  Set<String> toAllowedFunctionNames() {
    return map((e) => e.name).toSet();
  }
}
