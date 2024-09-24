import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../helpers.dart';
import 'llm_response.dart';

typedef LlmFunctionHandler = Future<JSON> Function(JSON args);

typedef LlmWidgetBuilder<T> = Widget Function(T);

class LlmFunctionDeclaration {
  final String name;
  final String description;
  final Schema? parameters;
  final LlmFunctionHandler handler;

  const LlmFunctionDeclaration({
    required this.name,
    required this.description,
    this.parameters,
    required this.handler,
  });

  LlmFunctionElement toElement() {
    return LlmFunctionElement(this);
  }
}

class LlmWidgetDeclaration<T> extends LlmFunctionDeclaration {
  final LlmWidgetBuilder<LlmFunctionElement> build;

  const LlmWidgetDeclaration._({
    required this.build,
    required super.name,
    required super.description,
    required super.handler,
  });

  factory LlmWidgetDeclaration({
    required LlmFunctionDeclaration declaration,
    required LlmWidgetBuilder<LlmFunctionElement> build,
  }) {
    return LlmWidgetDeclaration._(
      build: build,
      name: declaration.name,
      description: declaration.description,
      handler: declaration.handler,
    );
  }

  Widget? tryRender(LlmFunctionElement element) {
    return element.name != name ? null : build(element);
  }
}
