import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class LlmFunction {
  final String name;
  final String description;
  final Schema? parameters;
  final FunctionCallHandler handler;

  const LlmFunction({
    required this.name,
    required this.description,
    this.parameters,
    required this.handler,
  });

  FunctionDeclaration get declaration => FunctionDeclaration(
        name,
        description,
        parameters,
      );
}

class LlmUiRenderer extends LlmFunction {
  final FunctionUiHandler renderer;
  LlmUiRenderer(LlmFunction function, this.renderer)
      : super(
          name: function.name,
          description: function.description,
          parameters: function.parameters,
          handler: function.handler,
        );
}

typedef FunctionCallHandler = Map<String, Object?> Function(
    Map<String, Object?> args);

typedef FunctionUiHandler = Widget Function(Map<String, Object?> args);

extension ListLlmFunctionX on List<LlmFunction> {
  List<Tool> toTools() {
    return map((e) => Tool(functionDeclarations: [e.declaration])).toList();
  }

  Map<String, FunctionUiHandler> toUiHandlers() {
    final handlers = <String, FunctionUiHandler>{};

    for (final e in this) {
      if (e is LlmUiRenderer) {
        handlers[e.name] = e.renderer;
      }
    }

    return handlers;
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
